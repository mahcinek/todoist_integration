defmodule UserSpec do
  use ESpec, model: TodoistIntegration.Accounts.User

  alias TodoistIntegration.Accounts

  import TodoistIntegrationSpec.Factory
  import TodoistIntegrationSpec.Helpers, only: [pluck: 2]

  describe "list_users/0" do
    subject(do: Accounts.list_users())

    let!(:items, do: insert_list(2, :user))

    let(:returned_items, do: subject() |> pluck(:id))
    let(:expected_items, do: items() |> pluck(:id))

    it "returns all banner items" do
      expect(returned_items() |> to(match_list(expected_items())))
    end
  end
end
