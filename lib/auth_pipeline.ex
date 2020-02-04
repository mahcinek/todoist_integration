defmodule TodoistIntegration.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :todoist_integration_app,
  module: TodoistIntegration.Guardian,
  error_handler: TodoistIntegration.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
