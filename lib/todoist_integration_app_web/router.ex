defmodule TodoistIntegrationWeb.Router do
  use TodoistIntegrationWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    resources "/users", UserController, only: [:index]
    resources "/tasks", TaskController, only: [:update]
  end

  scope "/api", TodoistIntegrationWeb do
    pipe_through :api
  end
end
