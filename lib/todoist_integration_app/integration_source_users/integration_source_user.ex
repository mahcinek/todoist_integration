defmodule TodoistIntegration.IntegrationSourceUsers.IntegrationSourceUser do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "integration_source_users" do
    field :source_api_key, :string

    belongs_to :user, TodoistIntegration.Accounts.User
    belongs_to :integration_source, TodoistIntegration.IntegrationSources.IntegreationSource

    timestamps()
  end

  @doc false
  def changeset(integration_source_user, attrs) do
    integration_source_user
    |> cast(attrs, [:source_api_key])
    |> validate_required([:source_api_key])
  end
end
