# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :todoist_integration_app,
  namespace: TodoistIntegration,
  ecto_repos: [TodoistIntegration.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :todoist_integration_app, TodoistIntegrationWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sphhMG8ejKIX89FPpO8pxAYyTM/5JU5DLwqKGJINelJlCikwZnVDO/kBvEZbB04z",
  render_errors: [view: TodoistIntegrationWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: TodoistIntegration.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
