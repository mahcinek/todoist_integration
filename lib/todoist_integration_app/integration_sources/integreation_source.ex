defmodule TodoistIntegration.IntegrationSources.IntegreationSource do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "integration_sources" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(integreation_source, attrs) do
    integreation_source
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
