defmodule ApiWeb.ClocksController do
  use ApiWeb, :controller
  use PhoenixSwagger


  alias Api.ClockContext
  alias Api.ClockContext.Clocks
  alias Api.UserContext
  alias Api.WorkingtimeContext

  action_fallback ApiWeb.FallbackController

  def index(conn, %{"userID" => id}) do
    clocks = ClockContext.get_clocks_by_user_id(id)
    render(conn, "index.json", clocks: clocks)
  end

  def showMine(conn, _param) do
    user_id = Api.RestrictService.extract_user_id(conn)
    previousClock = ClockContext.get_previous_clock_by_user_id(user_id)
    render(conn, "show.json", clocks: previousClock)
  end

  def create(conn, _param) do
    user_id = Api.RestrictService.extract_user_id(conn)
    user = UserContext.get_users!(user_id)

    # TODO CONFIG PARIS DATETIME
    time = NaiveDateTime.utc_now
    previousClock = ClockContext.get_previous_clock_by_user_id(user_id)
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
      if previousClock.status == true do
        WorkingtimeContext.create_workingtimes(user, %{"start" => previousClock.time, "end" => time})
      end

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

  swagger_path :create do
    post "/api/clocks"
    description "Report their departure and arrival times"
    response 200, "Success"
  end

  swagger_path :showMine do
    get "/api/clocks"
    description "view their last clock"
    response 200, "Success"
  end

  swagger_path :index do
    get "/api/clocks/users/:userID"
    description "view all user's clock"
    response 200, "Success"
  end

  swagger_path :show do
    get "/api/clocks/:id"
    description "view one clock"
    response 200, "Success"
  end
end
