defmodule TodoistIntegration.Repo.Migrations.CreateIntegrationSourceUsers do
  use Ecto.Migration

  def change do
    create table(:integration_source_users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      add :integration_source_id,
          references(:integration_sources, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:integration_source_users, [:user_id])
    create index(:integration_source_users, [:integration_source_id])
  end
end
