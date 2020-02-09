defmodule TodoistIntegrationWeb.TaskController do
  use TodoistIntegrationWeb, :controller

  alias TodoistIntegration.IntegrationContent
  alias TodoistIntegration.IntegrationContent.Task
  alias TodoistIntegration.Accounts

  action_fallback TodoistIntegrationWeb.FallbackController

  def search(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    tasks = IntegrationContent.search(exchange_params(params), user.id)
    render(conn, "search.json", tasks: tasks)
  end

  def synch(conn, _params) do
    synch_summary = Accounts.synch_all()
    render(conn, "synch.json", synch_summary: synch_summary)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    user = Guardian.Plug.current_resource(conn)
    task = IntegrationContent.get_task_for_user!(id, user.id)

    with {:ok, %Task{} = task} <-
           IntegrationContent.update_task(task, task_params |> filter_incoming_params()) do
      render(conn, "show.json", task: task)
    end
  end

  defp filter_incoming_params(params) do
    params
    |> Map.take(["content"])
  end

  defp exchange_params(params) do
    param_map =
      params
      |> Map.take(["name", "source"])

    param_map
    |> Map.keys()
    |> Enum.reduce(%{}, fn key, acc ->
      case key do
        "name" -> acc |> Map.merge(%{content: param_map |> Map.fetch!("name")})
        "source" -> acc |> Map.merge(%{source: param_map |> Map.fetch!("source")})
      end
    end)
  end
end
