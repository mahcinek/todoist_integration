defmodule TodoistIntegration.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :auth_token, :string, virtual: true

    has_many :integration_source_users,
             TodoistIntegration.IntegrationSourceUsers.IntegrationSourceUser

    has_many :integration_sources, through: [:integration_source_users, :integration_source]
    has_many :tasks, TodoistIntegration.IntegrationContent.Task
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end
end
