defmodule UserSpec do
  use ESpec, model: TodoistIntegration.Accounts.User

  alias TodoistIntegration.Accounts

  import TodoistIntegrationSpec.Factory
  import TodoistIntegrationSpec.Helpers, only: [pluck: 2]

  describe "list_users/0" do
    subject(do: Accounts.list_users())

    let!(:items, do: insert_list(2, :user))

    let(:returned_items, do: subject() |> pluck(:id))
    let(:returned_tokens, do: subject() |> Enum.map(fn x -> x.auth_token))
    let(:expected_items, do: items() |> pluck(:id))

    it "returns all banner items" do
      expect(returned_items() |> to(match_list(expected_items())))
    end

    it "returns not empty auth_tokens" do
      expect(returned_items() |> not_to(match_list([%{ auth_token: nil}, %{ auth_token: nil}])))
    end
  end
end
