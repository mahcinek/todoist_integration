defmodule TodoistIntegration.Repo do
  use Ecto.Repo,
    otp_app: :todoist_integration_app,
    adapter: Ecto.Adapters.Postgres
end
