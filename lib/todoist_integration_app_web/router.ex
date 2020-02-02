defmodule TodoistIntegrationWeb.Router do
  use TodoistIntegrationWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    resources "/users", UserController, except: [:new, :edit]
    resources "/tasks", TaskController, only: [:create, :delete, :update]
  end

  scope "/api", TodoistIntegrationWeb do
    pipe_through :api
  end
end
