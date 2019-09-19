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
      {:ok, token} ->
        conn
        |> put_status(:ok)
        |> send_resp(200, token)
      {:error, reason} ->
        conn
        |> send_resp(401, reason)
    end
  end

  def signOut(conn, _params) do
    send_resp(conn, :no_content, "")
  end

  def sign_in(email, password) do
    case Comeonin.Bcrypt.check_pass(UserContext.get_user_by_email(email), password) do
      {:ok, users} ->
        expiry = DateTime.add(DateTime.utc_now, 3600 * 24 * 30, :second)
        {:ok, token, _claims} = Token.generate_and_sign(%{"user_id" => users.id, "role" => users.role, "expiry" => expiry})
        IO.inspect(token)
        IO.inspect(Api.Token.verify_and_validate(token))
        {:ok, token}
      err -> err
    end
  end

  def updateTeam(conn, %{"teamID" => teamID, "userID" => userID}) do
    users = UserContext.get_users!(userID)

    with {:ok, %Users{} = users} <- UserContext.update_team(users, teamID) do
      render(conn, "show.json", users: users)
    end
  end

  def promote(conn, %{"userID" => userID}) do
    users = UserContext.get_users!(userID)

    with {:ok, %Users{} = users} <- UserContext.promote_user(users) do
      render(conn, "show.json", users: users)
    end
  end

  # swagger path
  # swagger definition
  # complete router

end
