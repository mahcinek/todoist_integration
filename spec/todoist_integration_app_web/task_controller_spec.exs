defmodule TaskControllerSpec do
  use ESpec.Phoenix, controller: TodoistIntegrationWeb.TaskController

  import TodoistIntegrationSpec.Factory
  import TodoistIntegrationSpec.Helpers, only: [pluck: 2]

  let(:conn, do: build_conn())

  describe "index /api/tasks/search" do
    let(:json_body, do: response() |> json_response(200))
    let(:response_tasks, do: json_body() |> Map.get("data"))

    let :response do
      conn() |> get(task_path(conn(), :search))
    end

    describe "when there is no auth key provided" do
      it_behaves_like(Return401ResponseSpec)
    end
  end

  describe "index /api/tasks/synch" do
    let(:json_body, do: response() |> json_response(200))
    let(:response_tasks, do: json_body() |> Map.get("data"))

    let :response do
      conn() |> post(task_path(conn(), :synch))
    end

    describe "when there is no auth key provided" do
      it_behaves_like(Return401ResponseSpec)
    end
  end
end
