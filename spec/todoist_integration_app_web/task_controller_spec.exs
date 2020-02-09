defmodule TaskControllerSpec do
  use ESpec.Phoenix, controller: TodoistIntegrationWeb.TaskController

  import TodoistIntegrationSpec.Factory
  import TodoistIntegrationSpec.Helpers, only: [pluck: 2]
  alias TodoistIntegration.Accounts

  let(:conn, do: build_conn())

  describe "search /api/tasks/search" do
    let :response do
      conn() |> get(task_path(conn(), :search, params()))
    end

    let(:json_body, do: response() |> json_response(200))
    let(:response_tasks, do: json_body() |> Map.get("tasks"))

    let(:params) do
      %{
        name: "content",
        source: "source"
      }
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
      let!(:integration_source, do: insert(:integration_source, name: "todoist"))
      let!(:integration_source_2, do: insert(:integration_source, name: "nottodoist"))

        let!(:integration_source_user) do
          insert(:integration_source_user,
            user_id: user().id,
            integration_source_id: integration_source().id,
            source_api_key: "key"
          )
        end
        let!(:integration_source_user2) do
          insert(:integration_source_user,
            user_id: user().id,
            integration_source_id: integration_source_2().id,
            source_api_key: "key"
          )
        end

        let!(:first_task) do
          insert(:task,
            remote_id: "123",
            content: "content to find",
            user_id: user().id,
            integration_source_id: integration_source().id
          )
        end

        let!(:sec_task) do
          insert(:task,
            remote_id: "123123",
            content: "content",
            user_id: user().id,
            integration_source_id: integration_source().id
          )
        end

        let!(:task_diff_source) do
          insert(:task,
            remote_id: "1231233",
            content: "task",
            user_id: user().id,
            integration_source_id: integration_source_2().id
          )
        end

        let(:tasks, do: [first_task(), sec_task()])

        let(:tasks_maped) do
          tasks()
          |> Enum.map(fn task ->
            %{
              "id" => task.id,
              "remote_id" => task.remote_id,
              "name" => task.content,
              "source" => integration_source().name
            }
          end)
        end

      describe "when params don't match any tasks" do
        it "returns status 200" do
          expect(response().status |> to(be(200)))
        end

        it "no tasks are returned" do
          expect(response_tasks() |> to(be_empty()))
        end
      end

      describe "when params there is only search by content" do
        let(:params) do
          %{
            name: "content"
          }
        end

        it "returns status 200" do
          expect(response().status |> to(be(200)))
        end

        it "tasks are returned" do
          expect(response_tasks() |> not_to(be_empty()))
        end

        it "tasks data matches" do
          expect(
            response_tasks()
            |> pluck(["id", "remote_id", "name", "source"])
            |> to(eq(tasks_maped()))
          )
        end
      end

      describe "when params there is only search by source" do
        describe "params match two tasks form todoist" do
          let(:params) do
            %{
              source: "todoist"
            }
          end

          it "returns status 200" do
            expect(response().status |> to(be(200)))
          end

          it "tasks are returned" do
            expect(response_tasks() |> not_to(be_empty()))
          end

          it "tasks data matches" do
            expect(
              response_tasks()
              |> pluck(["id", "remote_id", "name", "source"])
              |> to(eq(tasks_maped()))
            )
          end
        end

        describe "params match task from different source" do
          let(:params) do
            %{
              source: "nottodoist"
            }
          end
          let(:tasks, do: [task_diff_source()])
          let(:tasks_maped) do
            tasks()
            |> Enum.map(fn task ->
              %{
                "id" => task.id,
                "remote_id" => task.remote_id,
                "name" => task.content,
                "source" => integration_source_2().name
              }
            end)
          end

          it "returns status 200" do
            expect(response().status |> to(be(200)))
          end

          it "tasks are returned" do
            expect(response_tasks() |> not_to(be_empty()))
          end

          it "tasks data matches" do
            expect(
              response_tasks()
              |> pluck(["id", "remote_id", "name", "source"])
              |> to(eq(tasks_maped()))
            )
          end
        end
      end

      describe "when params there is search by content and source" do
        describe "params match both tasks" do
          let(:params) do
            %{
              source: "todoist",
              name: "c"
            }
          end

          it "returns status 200" do
            expect(response().status |> to(be(200)))
          end

          it "tasks are returned" do
            expect(response_tasks() |> not_to(be_empty()))
          end

          it "tasks data matches" do
            expect(
              response_tasks()
              |> pluck(["id", "remote_id", "name", "source"])
              |> to(eq(tasks_maped()))
            )
          end
        end

        describe "params match one task" do
          let(:params) do
            %{
              source: "todoist",
              name: "find"
            }
          end
          let(:tasks, do: [first_task()])

          it "returns status 200" do
            expect(response().status |> to(be(200)))
          end

          it "tasks are returned" do
            expect(response_tasks() |> not_to(be_empty()))
          end

          it "tasks data matches" do
            expect(
              response_tasks()
              |> pluck(["id", "remote_id", "name", "source"])
              |> to(eq(tasks_maped()))
            )
          end
        end
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
    let(:response_task, do: json_body() |> Map.get("data"))
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

      it "updates task content" do
        expect(response_task() |> Map.fetch!("content") |> to(eq("new content")))
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
