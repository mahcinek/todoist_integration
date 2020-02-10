defmodule TodoistIntegration.IntegrationContent do
  @moduledoc """
  The IntegrationContent context.
  """

  import Ecto.Query, warn: false
  alias TodoistIntegration.Repo
  alias TodoistIntegration.IntegrationSources
  alias TodoistIntegration.IntegrationSourceUsers.IntegrationSourceUser
  alias TodoistIntegration.IntegrationContent.Task

  @preload_associations [:integration_source]

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  defp preload_associations(query) do
    query |> Repo.preload(@preload_associations)
  end

  def list_tasks_by_user_and_integration_source(user_id, integration_source_id) do
    Task
    |> where(
      [task],
      task.user_id == ^user_id and task.integration_source_id == ^integration_source_id
    )
    |> Repo.all()
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  def get_task_for_user!(id, user_id), do: Repo.get_by!(Task, %{id: id, user_id: user_id})

  def search(%{source: source, content: content}, user_id) do
    case IntegrationSources.get_integreation_source_by_name!(source) do
      nil ->
        []

      integration_source ->
        search_by_integration_source_query(integration_source)
        |> filter_by_user(user_id)
        |> filter_by_content(content)
        |> Repo.all()
        |> preload_associations()
    end
  end

  def search(%{content: content}, user_id) do
    from(t in Task,
      where:
        like(t.content, ^"%#{String.replace(content, "%", "\\%")}%") and t.user_id == ^user_id
    )
    |> Repo.all()
    |> preload_associations()
  end

  def search(%{source: source}, user_id) do
    case IntegrationSources.get_integreation_source_by_name!(source) do
      nil ->
        []

      integration_source ->
        search_by_integration_source_query(integration_source)
        |> filter_by_user(user_id)
        |> Repo.all()
        |> preload_associations()
    end
  end

  def search(_params, user_id) do
    from(t in Task,
      where: t.user_id == ^user_id
    )
    |> Repo.all()
    |> preload_associations()
  end

  defp search_by_integration_source_query(integration_source) do
    integration_source_id = integration_source.id
    from(t in Task, where: t.integration_source_id == ^integration_source_id)
  end

  defp filter_by_user(query, user_id) do
    query
    |> where([task], task.user_id == ^user_id)
  end

  defp filter_by_content(query, content) do
    query
    |> where([task], like(task.content, ^"%#{String.replace(content, "%", "\\%")}%"))
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def update_task_local_and_remote(%Task{} = task, attrs, user) do
    integration_source = get_integration_source(task)

    user_token =
      Repo.get_by(IntegrationSourceUser, %{
        integration_source_id: integration_source.id,
        user_id: user.id
      }).source_api_key

    attrs = %{content: Map.fetch!(attrs, "content")}

    transaction =
      Ecto.Multi.new()
      |> Ecto.Multi.run(:remote_update, fn _repo, _params ->
        remote_update(
          task.remote_id,
          attrs |> Map.fetch!(:content),
          integration_source.name,
          user_token
        )
      end)
      |> Ecto.Multi.update(
        :update,
        task
        |> Ecto.Changeset.change(attrs)
      )
      |> Repo.transaction()

    case transaction do
      {:ok, info} ->
        {:ok, info |> Map.fetch!(:update)}
    end
  end

  defp remote_update(remote_id, content, integration_source_name, user_token) do
    apply(
      Module.concat([
        "TodoistIntegration.IntegrationSources.Connections",
        Macro.camelize(integration_source_name)
      ]),
      :call_update,
      [user_token, remote_id, content]
    )

    {:ok, nil}
  end

  defp get_integration_source(task) do
    task_with_integration =
      task
      |> preload_associations

    task_with_integration.integration_source
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end

  def deal_with_tasks(integration_source, user, token) do
    tasks_form_integration = IntegrationSources.get_tasks(integration_source.name, token)
    local_tasks = list_tasks_by_user_and_integration_source(user.id, integration_source.id)

    task_from_integration_ids = Enum.map(tasks_form_integration, fn t -> t.remote_id end)
    local_task_ids = Enum.map(local_tasks, fn t -> t.remote_id end)

    task_ids_to_delete = local_task_ids -- task_from_integration_ids

    local_tasks_after_removal =
      Enum.filter(local_tasks, fn t -> t.remote_id not in task_ids_to_delete end)

    task_ids_to_update = local_task_ids -- task_ids_to_delete

    {tasks_to_update, tasks_to_insert} =
      Enum.split_with(tasks_form_integration, fn t -> t.remote_id in task_ids_to_update end)

    transaction =
      Ecto.Multi.new()
      |> Ecto.Multi.delete_all(:delete_all, find_tasks_to_delete(task_ids_to_delete))
      |> Ecto.Multi.append(insert_tasks(tasks_to_insert, user, integration_source))
      |> Ecto.Multi.append(update_tasks(tasks_to_update, local_tasks_after_removal))
      |> Repo.transaction()

    case transaction do
      {:ok, multi_info} -> {:ok, parse_multi_info(multi_info)}
      {:error, errors} -> {:error, errors}
    end
  end

  defp insert_tasks(tasks, user, integration_source) do
    tasks =
      tasks
      |> Enum.map(fn t ->
        Map.merge(t, %{
          user_id: user.id,
          integration_source_id: integration_source.id,
          inserted_at: now(),
          updated_at: now()
        })
      end)

    Ecto.Multi.new()
    |> Ecto.Multi.insert_all(:insert_all, Task, tasks)
  end

  defp update_tasks(tasks_from_integration, local_tasks) do
    Enum.reduce(tasks_from_integration, Ecto.Multi.new(), fn task, multi ->
      {:ok, remote_id} = Map.fetch(task, :remote_id)
      {:ok, content} = Map.fetch(task, :content)
      local_task = Enum.find(local_tasks, fn t -> t.remote_id == remote_id end)

      unless content == local_task.content do
        Ecto.Multi.update(
          multi,
          {:task, remote_id},
          local_task
          |> Ecto.Changeset.change(task)
        )
      else
        multi
      end
    end)
  end

  defp now() do
    NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
  end

  defp find_tasks_to_delete(task_ids_to_delete) do
    from(t in Task, where: t.remote_id in ^task_ids_to_delete)
  end

  defp parse_multi_info(multi_info) do
    map_size = Map.keys(multi_info) |> length()

    %{
      deleted: Map.fetch!(multi_info, :delete_all) |> elem(0),
      created: Map.fetch!(multi_info, :insert_all) |> elem(0),
      updated:
        if map_size > 2 do
          map_size - 2
        else
          0
        end
    }
  end
end
