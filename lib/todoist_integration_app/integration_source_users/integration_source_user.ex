defmodule TodoistIntegration.IntegrationSourceUsers.IntegrationSourceUser do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "integration_source_users" do
    field :user_id, :binary_id
    field :integration_source_id, :binary_id

    belongs_to :user, TodoistIntegration.Accounts.User
    belongs_to :integration_source, TodoistIntegration.IntegrationsSources.IntegrationSource

    timestamps()
  end

  @doc false
  def changeset(integration_source_user, attrs) do
    integration_source_user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
