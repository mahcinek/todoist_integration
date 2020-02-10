defmodule TodoistIntegration.IntegrationSources.Connections.Todoist do
  import TodoistIntegration.IntegrationSources.Connections.BaseConnection

  @base_url "https://api.todoist.com/rest/v1/"

  defp get_tasks(client) do
    case Tesla.get(client, "/tasks") do
      {:ok, response} -> response.body
      {:error, errors} -> {:error, errors}
    end
  end

  defp update_task(client, remote_id, content) do
    case Tesla.post(client, "/tasks/#{remote_id}", %{"content" => content} |> Jason.encode!(),
           headers: [{"content-type", "application/json"}]
         ) do
      {:ok, response} -> response.body
      {:error, errors} -> {:error, errors}
    end
  end

  def call(user_token) do
    IO.inspect("aa")

    user_token
    |> bearer_token_client(@base_url)
    |> get_tasks()
    |> Enum.map(fn t ->
      %{content: Map.get(t, "content"), remote_id: Map.get(t, "id") |> Integer.to_string()}
    end)
  end

  def call_update(user_token, remote_id, content) do
    response =
      user_token
      |> bearer_token_client(@base_url)
      |> update_task(remote_id, content)

    IO.inspect("dupa")
    {:ok, response}
  end
end
