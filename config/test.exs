use Mix.Config

# Configure your database
config :todoist_integration_app, TodoistIntegration.Repo,
  username: "mpiwek",
  password: "piwek",
  database: "todoist_integration_app_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :todoist_integration_app, TodoistIntegrationWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
