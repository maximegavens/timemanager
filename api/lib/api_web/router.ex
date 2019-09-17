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

  scope "/", ApiWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/swagger", PageController, :swagger
  end

  scope "/api", ApiWeb do
    pipe_through :api

    get "/users", UsersController, :index
    get "/users/manager/:managerID", UsersController, :indexManager
    get "/users/:userID", UsersController, :show
    post "/users", UsersController, :create
    put "/users/:userID", UsersController, :update
    delete "/users/:userID", UsersController, :delete

    get "/workingtimes", WorkingtimesController, :index
    get "/workingtimes/manager/:managerID", WorkingtimesController, :indexManager
    get "/workingtimes/:userID", WorkingtimesController, :showAll
    get "/workingtimes/:userID/:workingtimeID", WorkingtimesController, :showOne
    post "/workingtimes/:userID", WorkingtimesController, :create
    put "/workingtimes/:id", WorkingtimesController, :update
    delete "/workingtimes/:id", WorkingtimesController, :delete

    get "/clocks/:userID", ClocksController, :index
    get "/clocks/:id", ClocksController, :show
    post "/clocks/:userID", ClocksController, :create
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
