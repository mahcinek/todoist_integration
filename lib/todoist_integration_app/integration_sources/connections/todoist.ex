defmodule TodoistIntegration.IntegrationSources.Connections.Todoist do
  import TodoistIntegration.IntegrationSources.Connections.BaseConnection

  @base_url "https://api.todoist.com/rest/v1/"

  def get_tasks(client) do
    case Tesla.get(client, "/tasks") do
      {:ok, response} -> response.body
      {:error, errors} -> {:error, errors}
    end
  end

  def call(user_token) do
    user_token
    |> bearer_token_client(@base_url)
    |> get_tasks()
    |> Enum.map(fn t ->
      %{content: Map.get(t, "content"), remote_id: Map.get(t, "id") |> Integer.to_string()}
    end)
  end
end
