defmodule TodoistIntegrationWeb.TaskController do
  use TodoistIntegrationWeb, :controller

  alias TodoistIntegration.IntegrationContent
  alias TodoistIntegration.IntegrationContent.Task

  action_fallback TodoistIntegrationWeb.FallbackController

  def search(conn, _params) do
    tasks = IntegrationContent.list_tasks()
    render(conn, "index.json", tasks: tasks)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = IntegrationContent.get_task!(id)

    with {:ok, %Task{} = task} <-
           IntegrationContent.update_task(task, task_params |> filter_incoming_params()) do
      render(conn, "show.json", task: task)
    end
  end

  defp filter_incoming_params(params) do
    params
    |> Map.take([:name])
  end
end
