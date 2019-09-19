defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end
  pipeline :api do
    plug :accepts, ["json"]
  end
  pipeline :authenticate do
    plug Api.Plugs.Authenticate
  end
  pipeline :manager do
    plug Api.Plugs.OnlyManager
  end
  pipeline :general do
    plug Api.Plugs.OnlyGeneralManager
  end
  pipeline :admin do
    plug Api.Plugs.OnlyAdmin
  end

  scope "/", ApiWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/swagger", PageController, :swagger
  end
  scope "/api", ApiWeb do
    #route access disconnected user
    pipe_through :api
    post "/users/sign_in", UsersController, :signIn                                       # to log in
    post "/users/sign_up", UsersController, :signUp                                       # create account
  end
  scope "/api", ApiWeb do
    # route access connected user
    pipe_through :api
    pipe_through :authenticate
    put "/users/:userID", UsersController, :update                                        # 1) Edit their account information.
    delete "/users/:userID", UsersController, :delete                                     # 2) Delete their account. 11) Delete accounts from all users.
    get "/workingtimes/:userID", WorkingtimesController, :showAll                         # 4) View their dashboards.
    post "/clocks/:userID", ClocksController, :create                                     # 3) Report their departure and arrival times.
    get "/users/sign_out", UsersController, :signOut                                      # to log out
  end

  scope "/api", ApiWeb do
    # route access manager
    pipe_through :api
    pipe_through :authenticate
    pipe_through :manager
    put "/users/:userID/team/:teamID", UsersController, :updateTeam                       # 5) Manage their team(s). (change user.team by teamID)
    get "/workingtimes/:userID/team/:teamID", WorkingtimesController, :showTeamOne        # TODO 7) View the daily and weekly working hours of an employee over a period of time.
    get "/workingtimes/team/:teamID", WorkingtimesController, :showTeamAll                # TODO 6) View the averages of the daily and weekly hours of the team over a given period. 8) View their employees’ dashboards .
  end

  scope "/api", ApiWeb do
    # route access general manager
    pipe_through :api
    pipe_through :authenticate
    pipe_through :general
    put "/users/promote/:userID", UsersController, :promote                                # 9) Promote a user from the rank of employee to manager.
    get "/workingtimes", WorkingtimesController, :index                                    # 10) View the dashboards of all users.
    get "/users", UsersController, :index                                                  # 11) view all users
    get "/users/:userID", UsersController, :show                                           # view one user
  end

  scope "/api", ApiWeb do
    # route access admin
    pipe_through :api
    pipe_through :authenticate
    pipe_through :admin
    get "/clocks/:userID", ClocksController, :index                                        # view all user's clock
    get "/workingtimes/:userID/:workingtimeID", WorkingtimesController, :showOne           # view one workingtime
    post "/workingtimes/:userID", WorkingtimesController, :create                          # create workingtime
    put "/workingtimes/:id", WorkingtimesController, :update                               # update workingtime
    delete "/workingtimes/:id", WorkingtimesController, :delete                            # delete workingtime
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Api"
      }
    }
  end
end
