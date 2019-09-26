defmodule ApiWeb.UsersController do
  use ApiWeb, :controller
  use PhoenixSwagger


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

  def showMine(conn, _param) do
    user_id = Api.RestrictService.extract_user_id(conn)
    users = UserContext.get_users!(user_id)
    render(conn, "show.json", users: users)
  end

  def showTeam(conn, %{"teamID" => teamID}) do
    users = UserContext.get_users_by_team(teamID)
    render(conn, "index.json", users: users)
  end


  def updateMine(conn, %{"users" => users_params}) do
    user_id = Api.RestrictService.extract_user_id(conn)
    users = UserContext.get_users!(user_id)

    with {:ok, %Users{} = users} <- UserContext.update_users(users, users_params) do
      render(conn, "show.json", users: users)
    end
  end

  def deleteMine(conn, _param) do
    user_id = Api.RestrictService.extract_user_id(conn)
    users = UserContext.get_users!(user_id)

    with {:ok, %Users{}} <- UserContext.delete_users(users) do
      send_resp(conn, :no_content, "")
    end
  end

  def deleteOne(conn, %{"userID" => id}) do
    role = Api.RestrictService.extract_role(conn)

    if role == "admin" || role == "general manager" do
      users = UserContext.get_users!(id)
      with {:ok, %Users{}} <- UserContext.delete_users(users) do
        send_resp(conn, :no_content, "")
      end
    else
      Api.RestrictService.unauthorized(conn)
    end
  end

  def signUp(conn, %{"users" => users_params}) do
    IO.inspect(users_params)
    IO.inspect(users_params["role"])

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
    IO.inspect(conn)
    put_req_header(conn, "authorization", "")
    send_resp(conn, :no_content, "")
  end

  def sign_in(email, password) do
    case Comeonin.Bcrypt.check_pass(UserContext.get_user_by_email(email), password) do
      {:ok, users} ->
        expiry = DateTime.add(DateTime.utc_now, 3600 * 24 * 30, :second)
        {:ok, token, _claims} = Token.generate_and_sign(%{"user_id" => users.id, "role" => users.role, "expiry" => expiry})
        {:ok, token}
      err -> err
    end
  end

  def updateTeam(conn, %{"teamID" => teamID, "userID" => userID}) do
    users = UserContext.get_users!(userID)

    with {:ok, %Users{} = users} <- UserContext.update_team(users, %{"team" => teamID}) do
      render(conn, "show.json", users: users)
    end
  end

  def promote(conn, %{"userID" => userID}) do
    users = UserContext.get_users!(userID)

    with {:ok, %Users{} = users} <- UserContext.promote_user(users) do
      render(conn, "show.json", users: users)
    end
  end


  swagger_path :signUp do
    get "/api/users/sign_up"
    description "user register his account"
    response 200, "Success"
    parameters do
      username :path, :string, "user'name", required: true, example: "jack"
      email :path, :string, "user'email", required: true, example: "jack@exe.com"
      role :path, :string, "user'role", required: true, example: "manager"
      password :path, :string, "user'password", required: true, example: "admin"
      team :path, :integer, "user'team", required: true, example: "7"
    end
  end

  swagger_path :showMine do
    get "/api/users"
    description "view account information"
    response 200, "Success"
  end

  swagger_path :updateMine do
    put "/api/users"
    description "edit their account information"
    response 200, "Success"
    parameters do
      username :path, :string, "user'name", required: true, example: "jack"
      email :path, :string, "user'email", required: true, example: "jack@exe.com"
      role :path, :string, "user'role", required: true, example: "manager"
      password :path, :string, "user'password", required: true, example: "admin"
      team :path, :integer, "user'team", required: true, example: "7"
    end
  end

  swagger_path :deleteMine do
    delete "/api/users"
    description "Delete their account"
    response 200, "Success"
  end

  swagger_path :signOut do
    get "/api/users/sign_out"
    description "to log out"
    response 200, "Success"
  end

  swagger_path :showTeam do
    get "/api/users/team/:teamID"
    description "view my team account information"
    response 200, "Success"
  end

  swagger_path :index do
    get "/api/users/all"
    description "view all users"
    response 200, "Success"
  end

  swagger_path :updateTeam do
    put "/api/users/:userID"
    description "change user's team by teamID"
    response 200, "Success"
    parameters do
      team :path, :integer, "user'team", required: true, example: "7"
    end
  end

  swagger_path :promote do
    put "/api/users/promote/:userID"
    description "Promote a user from the rank of employee to manager"
    response 200, "Success"
  end

  swagger_path :deleteOne do
    delete "/api/users/:userID"
    description "Delete accounts of any users"
    response 200, "Success"
  end

  swagger_path :show do
    get "/api/users/:userID"
    description "view one user"
    response 200, "Success"
  end

end



  # swagger path
  # swagger definition
  # complete router
