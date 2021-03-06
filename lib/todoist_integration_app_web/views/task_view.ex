defmodule TodoistIntegrationWeb.TaskView do
  use TodoistIntegrationWeb, :view
  alias TodoistIntegrationWeb.TaskView

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("synch.json", %{synch_summary: synch_summary}) do
    synch_summary
  end

  def render("search.json", %{tasks: tasks}) do
    %{tasks: render_many(tasks, TaskView, "search_task.json")}
  end

  def render("search_task.json", %{task: task}) do
    %{
      id: task.id,
      remote_id: task.remote_id,
      name: task.content,
      source: task.integration_source.name
    }
  end

  def render("task.json", %{task: task}) do
    %{id: task.id, remote_id: task.remote_id, content: task.content}
  end
end
