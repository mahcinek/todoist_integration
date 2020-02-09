defmodule AccountsSpec do
  use ESpec, model: TodoistIntegration.Accounts.User
  alias TodoistIntegration.Accounts

  import TodoistIntegrationSpec.Factory
  import TodoistIntegrationSpec.Helpers, only: [pluck: 2]

  before do
    # basic remote todoist return mock
    allow(
      TodoistIntegration.IntegrationSources.Connections.Todoist
      |> to(
        accept(:call, fn _params ->
          [%{content: "aaa", remote_id: "123"}, %{content: "bbb", remote_id: "123123"}]
        end)
      )
    )
  end

  describe "list_users/0" do
    subject(do: Accounts.list_users())

    let!(:items, do: insert_list(2, :user))

    let(:returned_items, do: subject() |> pluck(:id))
    let(:returned_tokens, do: subject() |> Enum.map(fn x -> x.auth_token end))
    let(:expected_items, do: items() |> pluck(:id))

    it "returns all banner items" do
      expected_items() |> should(have_all(fn x -> x in returned_items() end))
      returned_items() |> should(have_count(2))
    end

    it "returns not empty auth_tokens" do
      expect(returned_items() |> not_to(match_list([%{auth_token: nil}, %{auth_token: nil}])))
    end
  end

  describe "synch_all/0" do
    subject(do: Accounts.synch_all())

    let(:returned_value, do: subject())
    let(:created, do: subject() |> Map.fetch(:created))
    let(:updated, do: subject() |> Map.fetch(:updated))
    let(:deleted, do: subject() |> Map.fetch(:deleted))
    let!(:user, do: insert(:user))
    # could be moved to factories
    let!(:integration_source, do: insert(:integration_source, name: "todoist"))

    let!(:integration_source_user) do
      insert(:integration_source_user,
        user_id: user().id,
        integration_source_id: integration_source().id,
        source_api_key: "key"
      )
    end

    let!(:user_id, do: user().id)

    it "returns not empty auth_tokens" do
      expect(returned_value() |> Map.keys() |> to(eq([:created, :deleted, :updated])))
    end

    context "when there are tasks to add" do
      it "inserts both tasks from mock" do
        expect(created()) |> to(eq({:ok, 2}))
      end
    end

    context "when there are tasks to update" do
      let!(:first_task) do
        insert(:task,
          remote_id: "123",
          content: "content to replace",
          user_id: user_id(),
          integration_source_id: integration_source().id
        )
      end

      let!(:sec_task) do
        insert(:task,
          remote_id: "123123",
          content: "content to replace",
          user_id: user_id(),
          integration_source_id: integration_source().id
        )
      end

      it "updates both tasks from mock" do
        expect(updated()) |> to(eq({:ok, 2}))
      end
    end

    context "when there are tasks to delete" do
      let!(:first_task) do
        insert(:task,
          remote_id: "1",
          content: "new task",
          user_id: user_id(),
          integration_source_id: integration_source().id
        )
      end

      let!(:sec_task) do
        insert(:task,
          remote_id: "1",
          content: "task 2",
          user_id: user_id(),
          integration_source_id: integration_source().id
        )
      end

      it "deletes old and creates new tasks from mock" do
        expect(created()) |> to(eq({:ok, 2}))
        expect(deleted()) |> to(eq({:ok, 2}))
      end
    end
  end
end
