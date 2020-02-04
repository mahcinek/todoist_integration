defmodule TodoistIntegrationWeb.Router do
  use TodoistIntegrationWeb, :router
  alias TodoistIntegration.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/api", TodoistIntegrationWeb do
    pipe_through [:jwt_authenticated, :api]
    resources "/users", UserController, only: [:index]
    resources "/tasks", TaskController, only: [:update]
  end
end
