defmodule TodoistIntegration.Repo.Migrations.CreateIntegrationSources do
  use Ecto.Migration

  def change do
    create table(:integration_sources, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string

      timestamps()
    end
  end
end
