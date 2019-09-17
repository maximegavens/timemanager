defmodule ApiWeb.WorkingtimesController do
  use ApiWeb, :controller

  alias Api.WorkingtimeContext
  alias Api.WorkingtimeContext.Workingtimes
  alias Api.UserContext

  action_fallback ApiWeb.FallbackController

  def index(conn, _param) do
    workingtimes = WorkingtimeContext.list_workingtimes()
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def indexManager(conn, %{"managerID" => id}) do
    manager = UserContext.get_users(id)

    if manager != nil do
      workingtimes = WorkingtimeContext.get_workingtimes_by_team_id(manager.team)
      render(conn, "index.json", workintimes: workingtimes)
    end
  end


  def showAll(conn, param) do
    userID = param["userID"]
    start = param["start"]
    endd = param["end"]
    if start == nil do
      if endd == nil do
        workingtimes = WorkingtimeContext.get_workingtimes_by_user_id(userID)
        render(conn, "index.json", workingtimes: workingtimes)
      else
        workingtimes = WorkingtimeContext.get_workingtimes_by_user_id_and_end(userID, endd)
        render(conn, "index.json", workingtimes: workingtimes)
      end
    else
      if endd == nil do
        workingtimes = WorkingtimeContext.get_workingtimes_by_user_id_and_start(userID, start)
        render(conn, "index.json", workingtimes: workingtimes)
      else
        workingtimes = WorkingtimeContext.get_workingtimes_by_user_id_and_start_and_end(userID, start, endd)
        render(conn, "index.json", workingtimes: workingtimes)
      end
    end
  end


  def showOne(conn, %{"userID" => userID, "workingtimeID" => workingtimeID}) do
    workingtimes = WorkingtimeContext.get_workingtimes_by_user_id_and_workingtime_id(userID, workingtimeID)
    IO.inspect(workingtimes)
    render(conn, "show.json", workingtimes: workingtimes)
  end


  def create(conn, %{"userID" => id, "workingtimes" => workingtimes_params}) do
    user = UserContext.get_users(id)
    IO.inspect(user)

    if user != nil do
      with {:ok, %Workingtimes{} = workingtimes} <- WorkingtimeContext.create_workingtimes(user, workingtimes_params) do
        IO.inspect(workingtimes)
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.workingtimes_path(conn, :showOne, workingtimes.user_id, workingtimes.id))
        |> render("show.json", workingtimes: workingtimes)
      end
    end
    send_resp(conn, :no_content, "")
  end


  def update(conn, %{"id" => id, "workingtimes" => workingtimes_params}) do
    workingtimes = WorkingtimeContext.get_workingtimes!(id)

    with {:ok, %Workingtimes{} = workingtimes} <- WorkingtimeContext.update_workingtimes(workingtimes, workingtimes_params) do
      render(conn, "show.json", workingtimes: workingtimes)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtimes = WorkingtimeContext.get_workingtimes!(id)

    with {:ok, %Workingtimes{}} <- WorkingtimeContext.delete_workingtimes(workingtimes) do
      send_resp(conn, :no_content, "")
    end
  end
end