defmodule ApiWeb.UsersView do
  use ApiWeb, :view
  alias ApiWeb.UsersView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UsersView, "users.json")}
  end

  def render("show.json", %{users: users}) do
    %{data: render_one(users, UsersView, "users.json")}
  end

  def render("users.json", %{users: users}) do
    %{id: users.id,
      username: users.username,
      email: users.email,
      status: users.status,
      team: users.team,
      password: users.password}
  end
end
