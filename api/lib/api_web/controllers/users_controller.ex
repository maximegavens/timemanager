defmodule ApiWeb.UsersController do
  use ApiWeb, :controller

  alias Api.UserContext
  alias Api.UserContext.Users

  action_fallback ApiWeb.FallbackController

  def index(conn, params) do
    email = params["email"]
    username = params["username"]
    if email == nil || username == nil do
      users = UserContext.list_users()
      render(conn, "index.json", users: users)
    else
      users = UserContext.list_users_with_params(email, username)
      IO.inspect(users)
      render(conn, "show.json", users: users)
    end
  end

  def create(conn, %{"users" => users_params}) do
    with {:ok, %Users{} = users} <- UserContext.create_users(users_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.users_path(conn, :show, users))
      |> render("show.json", users: users)
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
end
