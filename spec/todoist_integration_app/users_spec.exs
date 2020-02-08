defmodule UserSpec do
  use ESpec, model: TodoistIntegration.Accounts.User

  alias TodoistIntegration.Accounts

  import TodoistIntegrationSpec.Factory
  import TodoistIntegrationSpec.Helpers, only: [pluck: 2]

  describe "list_users/0" do
    subject(do: Accounts.list_users())

    let!(:items, do: insert_list(2, :user))

    let(:returned_items, do: subject() |> pluck(:id))
    let(:returned_tokens, do: subject() |> Enum.map(fn x -> x.auth_token end))
    let(:expected_items, do: items() |> pluck(:id))

    it "returns all banner items" do
      expected_items() |> should(have_all(fn x -> x in returned_items() end))
      returned_items() |> should(have_count(3)) #includes user from seeds
    end

    it "returns not empty auth_tokens" do
      expect(returned_items() |> not_to(match_list([%{ auth_token: nil}, %{ auth_token: nil}])))
    end
  end

  describe "synch_all/0" do
    subject(do: Accounts.synch_all())

    let(:returned_items, do: subject() |> pluck(:id))

    it "returns not empty auth_tokens" do
      expect(returned_items() |> not_to(match_list([%{ auth_token: nil}, %{ auth_token: nil}])))
    end
  end
end
