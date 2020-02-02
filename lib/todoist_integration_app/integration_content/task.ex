defmodule TodoistIntegration.IntegrationContent.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tasks" do
    field :name, :string
    field :remote_id, :integer

    belongs_to :user, TodoistIntegration.Accounts.User
    belongs_to :integration_source, TodoistIntegration.IntegrationSources.IntegreationSource

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:remote_id, :name])
    |> validate_required([:remote_id, :name])
  end
end
