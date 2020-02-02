defmodule TodoistIntegration.IntegrationContentTest do
  use TodoistIntegration.DataCase

  alias TodoistIntegration.IntegrationContent

  describe "tasks" do
    alias TodoistIntegration.IntegrationContent.Task

    @valid_attrs %{name: "some name", remote_id: 42, source: "some source"}
    @update_attrs %{name: "some updated name", remote_id: 43, source: "some updated source"}
    @invalid_attrs %{name: nil, remote_id: nil, source: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> IntegrationContent.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert IntegrationContent.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert IntegrationContent.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = IntegrationContent.create_task(@valid_attrs)
      assert task.name == "some name"
      assert task.remote_id == 42
      assert task.source == "some source"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = IntegrationContent.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, %Task{} = task} = IntegrationContent.update_task(task, @update_attrs)
      assert task.name == "some updated name"
      assert task.remote_id == 43
      assert task.source == "some updated source"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = IntegrationContent.update_task(task, @invalid_attrs)
      assert task == IntegrationContent.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = IntegrationContent.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> IntegrationContent.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = IntegrationContent.change_task(task)
    end
  end

  describe "tasks" do
    alias TodoistIntegration.IntegrationContent.Task

    @valid_attrs %{name: "some name", remote_id: 42}
    @update_attrs %{name: "some updated name", remote_id: 43}
    @invalid_attrs %{name: nil, remote_id: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> IntegrationContent.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert IntegrationContent.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert IntegrationContent.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = IntegrationContent.create_task(@valid_attrs)
      assert task.name == "some name"
      assert task.remote_id == 42
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = IntegrationContent.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, %Task{} = task} = IntegrationContent.update_task(task, @update_attrs)
      assert task.name == "some updated name"
      assert task.remote_id == 43
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = IntegrationContent.update_task(task, @invalid_attrs)
      assert task == IntegrationContent.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = IntegrationContent.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> IntegrationContent.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = IntegrationContent.change_task(task)
    end
  end
end
