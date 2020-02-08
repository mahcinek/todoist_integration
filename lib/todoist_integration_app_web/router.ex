defmodule TodoistIntegrationWeb.Router do
  use TodoistIntegrationWeb, :router
  alias TodoistIntegration.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/unsecureapi", TodoistIntegrationWeb do
    pipe_through [:api]
    resources "/users", UserController, only: [:index]
  end

  scope "/api", TodoistIntegrationWeb do
    pipe_through [:jwt_authenticated, :api]
    post("/synch", TaskController, :synch)

    resources "/tasks", TaskController, only: [:update] do
      get("/search", TaskController, :search)
    end
  end
end
