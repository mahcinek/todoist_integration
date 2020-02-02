defmodule TodoistIntegrationWeb.Router do
  use TodoistIntegrationWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TodoistIntegrationWeb do
    pipe_through :api
  end
end
