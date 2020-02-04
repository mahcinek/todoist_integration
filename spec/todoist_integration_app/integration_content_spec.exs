defmodule UserSpec do
  use ESpec, model: TodoistIntegration.IntegrationContent.Task

  alias TodoistIntegration.IntegrationContent

  import TodoistIntegrationSpec.Factory
  import TodoistIntegrationSpec.Helpers, only: [pluck: 2]

  describe "list_users/0" do
    subject(do: IntegrationContent.download_tasks(base_url(), token()))

    let(:token, do: "token")
    let(:base_url, do: "https://api.todoist.com/rest/v1")
    let(:returned_items, do: subject() )

    it "returns not empty auth_tokens" do
      expect(returned_items() |> to(match_list([%{ auth_token: nil}, %{ auth_token: nil}])))
    end
  end
end
