defmodule TaskControllerSpec do
  use ESpec.Phoenix, controller: TodoistIntegrationWeb.TaskController

  import TodoistIntegrationSpec.Factory
  import TodoistIntegrationSpec.Helpers, only: [pluck: 2]
  alias TodoistIntegration.Accounts

  let(:conn, do: build_conn())

  describe "index /api/tasks/search" do
    let :response do
      conn() |> get(task_path(conn(), :search))
    end

    let(:json_body, do: response() |> json_response(200))
    let(:response_tasks, do: json_body() |> Map.get("data"))

    describe "when there is no auth key provided" do
      it_behaves_like(Return401ResponseSpec)
    end

    describe "when there is auth key" do
      let(:conn) do
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{jwt()}")
      end

      let(:user, do: insert(:user))
      let(:jwt, do: Accounts.with_auth_token(user()).auth_token)

      it "returns status 200" do
        expect(response().status |> to(be(200)))
      end
    end
  end

  describe "update /api/tasks/:id" do
    let :response do
      conn()
      |> patch(task_path(conn(), :update, task_id()), %{"task" => params()})
    end

    let(:params) do
      %{
        content: "new content"
      }
    end

    let(:json_body, do: response() |> json_response(200))
    let(:response_tasks, do: json_body() |> Map.get("data"))
    let(:task_id, do: "id")

    describe "when there is no auth key provided" do
      it_behaves_like(Return401ResponseSpec)
    end

    describe "when there is auth key" do
      let(:conn) do
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{jwt()}")
      end

      let(:user, do: insert(:user))
      let(:jwt, do: Accounts.with_auth_token(user()).auth_token)
      let(:task_to_update, do: insert(:task, user_id: user().id))
      let(:task_id, do: task_to_update().id)

      it "returns status 200" do
        expect(response().status |> to(be(200)))
      end
    end
  end

  describe "index /api/tasks/synch" do
    # external response is mocked globally in accounts_spec.exs
    let(:json_body, do: response() |> json_response(200))
    let(:response_tasks, do: json_body() |> Map.get("data"))

    let :response do
      conn() |> post(task_path(conn(), :synch))
    end

    describe "when there is no auth key provided" do
      it_behaves_like(Return401ResponseSpec)
    end

    describe "when there is auth key" do
      let(:conn) do
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{jwt()}")
      end

      let(:user, do: insert(:user))
      let(:jwt, do: Accounts.with_auth_token(user()).auth_token)

      it "returns status 200" do
        expect(response().status |> to(be(200)))
      end

      it "returns json response" do
        expect(json_body() |> Map.keys() |> to(eq(["created", "deleted", "updated"])))
      end
    end
  end
end
