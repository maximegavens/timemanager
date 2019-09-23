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
    get "/users", UsersController, :showMine                                              # view account information
    put "/users", UsersController, :updateMine                                            # 1) Edit their account information.
    delete "/users", UsersController, :deleteMine                                         # 2) Delete their account.
    get "/workingtimes", WorkingtimesController, :showMine                                # 4) View their dashboards.
    post "/clocks", ClocksController, :create                                             # 3) Report their departure and arrival times.
    get "/clocks", ClocksController, :showMine                                            # view their last clock
    get "/users/sign_out", UsersController, :signOut                                      # to log out
  end
  scope "/api", ApiWeb do
    # route access manager
    pipe_through :api
    pipe_through :authenticate
    pipe_through :manager
    get "/users/team/:teamID", UsersController, :showTeam                                 # view my team account information
    put "/users/:userID/team/:teamID", UsersController, :updateTeam                       # 5) Manage their team(s). (change user.team by teamID)
    get "/workingtimes/:userID/team/:teamID", WorkingtimesController, :showTeamOne        # 7) View the daily and weekly working hours of an employee over a period of time.
    get "/workingtimes/team/:teamID", WorkingtimesController, :showTeamAll                # 6) View the averages of the daily and weekly hours of the team over a given period. 8) View their employees’ dashboards .
  end

  scope "/api", ApiWeb do
    # route access general manager
    pipe_through :api
    pipe_through :authenticate
    pipe_through :general
    put "/users/promote/:userID", UsersController, :promote                                # 9) Promote a user from the rank of employee to manager.
    get "/workingtimes/all", WorkingtimesController, :index                                # 10) View the dashboards of any users.
    delete "/users/:userID", UsersController, :deleteOne                                   # 11) Delete accounts of any users.
  end

  scope "/api", ApiWeb do
    # route access admin
    pipe_through :api
    pipe_through :authenticate
    pipe_through :admin
    get "/clocks/users/:userID", ClocksController, :index                                  # view all user's clock
    get "/clocks/:id", ClocksController, :show                                             # viex one clock
    get "/workingtimes/:userID/:workingtimeID", WorkingtimesController, :showOne           # view one workingtime
    post "/workingtimes/:userID", WorkingtimesController, :create                          # create workingtime
    put "/workingtimes/:id", WorkingtimesController, :update                               # update workingtime
    delete "/workingtimes/:id", WorkingtimesController, :delete                            # delete workingtime
    get "/users/all", UsersController, :index                                              # view all users
    get "/users/:userID", UsersController, :show                                           # view one user
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
