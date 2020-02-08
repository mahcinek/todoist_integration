defmodule TodoistIntegration.IntegrationSources.Connections.Todoist do
  import TodoistIntegration.IntegrationSources.Connections.BaseConnection

  @base_url ""

  def client(base_url, token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, base_url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "Bearer " <> token}]}
    ]

    Tesla.client(middleware)
  end

  def get_tasks(client) do
    case Tesla.get(client, "/tasks") do
      {:ok, response} -> response.body
      {:error, errors} -> {:error, errors}
    end
  end

  def call(user_token) do
    @base_url
    |> Todoist.client(user_token)
    |> Todoist.get_tasks()
    |> Enum.map(fn t -> %Task{name: Map.get(t, "content"), remote_id: Map.get(t, "id")} end)
  end
end
