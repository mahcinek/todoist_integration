defmodule TodoistIntegration.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :remote_id, :integer
      add :name, :text
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :integration_source_id, references(:integration_sources, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:tasks, [:user_id])
    create index(:tasks, [:integration_source_id])
  end
end
