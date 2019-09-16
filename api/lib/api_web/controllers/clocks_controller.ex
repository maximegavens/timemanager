defmodule ApiWeb.ClocksController do
  use ApiWeb, :controller

  alias Api.ClockContext
  alias Api.ClockContext.Clocks
  alias Api.UserContext

  action_fallback ApiWeb.FallbackController

  def index(conn, %{"userID" => id}) do
    clocks = ClockContext.get_clocks_by_user_id(id)
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"userID" => id}) do
    user = UserContext.get_users(id)
    time = NaiveDateTime.utc_now
    previousClock = ClockContext.get_previous_clock_by_user_id(id)
    if previousClock == nil do
      clocks_params = %{"time" => time, "status" => true}

      if user != nil do
        with {:ok, %Clocks{} = clocks} <- ClockContext.create_clocks(user, clocks_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.clocks_path(conn, :show, clocks))
          |> render("show.json", clocks: clocks)
        end
      else
        send_resp(conn, :no_content, "")
      end
    else
      clocks_params = %{"time" => time, "status" => !previousClock.status}

      if user != nil do
        with {:ok, %Clocks{} = clocks} <- ClockContext.create_clocks(user, clocks_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.clocks_path(conn, :show, clocks))
          |> render("show.json", clocks: clocks)
        end
      else
        send_resp(conn, :no_content, "")
      end
    end
  end


  def show(conn, %{"id" => id}) do
    clocks = ClockContext.get_clocks!(id)
    render(conn, "show.json", clocks: clocks)
  end

  def update(conn, %{"id" => id, "clocks" => clocks_params}) do
    clocks = ClockContext.get_clocks!(id)

    with {:ok, %Clocks{} = clocks} <- ClockContext.update_clocks(clocks, clocks_params) do
      render(conn, "show.json", clocks: clocks)
    end
  end

  def delete(conn, %{"id" => id}) do
    clocks = ClockContext.get_clocks!(id)

    with {:ok, %Clocks{}} <- ClockContext.delete_clocks(clocks) do
      send_resp(conn, :no_content, "")
    end
  end
end
