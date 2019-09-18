defmodule ApiWeb.UsersController do
  use ApiWeb, :controller

  alias Api.UserContext
  alias Api.UserContext.Users
  alias Api.Token

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.json", users: users)
  end

  def indexManager(conn, %{"managerID" => id}) do
    manager = UserContext.get_users!(id)

    if manager != nil do
      users = UserContext.get_users_by_team(manager.team)
      render(conn, "index.json", users: users)
    end
  end

  def show(conn, %{"userID" => id}) do
    users = UserContext.get_users!(id)
    render(conn, "show.json", users: users)
  end

  def update(conn, %{"userID" => id, "users" => users_params}) do
    users = UserContext.get_users!(id)

    with {:ok, %Users{} = users} <- UserContext.update_users(users, users_params) do
      render(conn, "show.json", users: users)
    end
  end

  def delete(conn, %{"userID" => id}) do
    users = UserContext.get_users!(id)

    with {:ok, %Users{}} <- UserContext.delete_users(users) do
      send_resp(conn, :no_content, "")
    end
  end


  def signUp(conn, %{"users" => users_params}) do

    with {:ok, %Users{} = users} <- UserContext.create_users(users_params) do
      IO.inspect(users)
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.users_path(conn, :show, users))
      |> render("show.json", users: users)
    end
  end

  def signIn(conn, %{"email" => email, "password" => password}) do
    case sign_in(email, password) do
      # TODO replace users by auth_token
      {:ok, users} ->
        IO.inspect(users)
        conn
        |> put_status(:ok)
        |> render("show.json", users: users)
      {:error, reason} ->
        conn
        |> send_resp(401, reason)
    end
  end

  def signOut(conn) do
    case get_auth_token(conn) do
      {:ok, token} ->
        case UserContext.get_user_by_token(token) do
          nil -> {:error, :not_found}
          users ->
            users_params = %{"token" => "", "expiry" => ""}
            UserContext.update_users(users, users_params)
            render(conn, "show.json", users: users)
        end
      error -> error
    end
  end

  def sign_in(email, password) do
    case Comeonin.Bcrypt.check_pass(UserContext.get_user_by_email(email), password) do
      {:ok, users} ->
        {:ok, token, _claims} = Token.generate_and_sign()
        expiry = DateTime.add(DateTime.utc_now, 3600 * 24 * 30, :second)
        case UserContext.update_token(users, %{"token" => token, "expiry" => expiry}) do
          users -> users
        end
      err -> err
    end
  end

  def get_auth_token(conn) do
    case extract_token(conn) do
      {:ok, token} -> verify_token(token)
      error -> error
    end
  end

  defp extract_token(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [auth_header] -> get_token_from_header(auth_header)
      _ -> {:error, :missing_auth_header}
    end
  end

  defp get_token_from_header(auth_header) do
    {:ok, reg} = Regex.compile("Bearer\:?\s+(.*)$", "i")
    case Regex.run(reg, auth_header) do
      [_, match] -> {:ok, String.trim(match)}
      _ -> {:error, "token not found"}
    end
  end

  def verify_token(token) do
    case Joken.Signer.verify(token, Joken.Signer.create("HS256", "secret")) do
      {:ok, id} -> {:ok, token}
      error -> error
    end
  end
end
