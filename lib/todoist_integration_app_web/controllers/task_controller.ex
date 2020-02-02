defmodule TodoistIntegrationWeb.TaskController do
  use TodoistIntegrationWeb, :controller

  alias TodoistIntegration.IntegrationContent
  alias TodoistIntegration.IntegrationContent.Task

  action_fallback TodoistIntegrationWeb.FallbackController

  def index(conn, _params) do
    tasks = IntegrationContent.list_tasks()
    render(conn, "index.json", tasks: tasks)
  end

  def create(conn, %{"task" => task_params}) do
    with {:ok, %Task{} = task} <- IntegrationContent.create_task(task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.task_path(conn, :show, task))
      |> render("show.json", task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    task = IntegrationContent.get_task!(id)
    render(conn, "show.json", task: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = IntegrationContent.get_task!(id)

    with {:ok, %Task{} = task} <- IntegrationContent.update_task(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = IntegrationContent.get_task!(id)

    with {:ok, %Task{}} <- IntegrationContent.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end
end
