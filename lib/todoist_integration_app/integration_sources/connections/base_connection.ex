defmodule TodoistIntegration.IntegrationSources.Connections.BaseConnection do
  def client(token, base_url) do
    middleware = [
      {Tesla.Middleware.BaseUrl, base_url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "Bearer " <> token}]}
    ]

    Tesla.client(middleware)
  end
end
