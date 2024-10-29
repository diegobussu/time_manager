defmodule TimeManagerApi.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :owner_id, references(:users, on_delete: :delete_all)
      add :members, {:array, :id}
      timestamps()
    end

    create unique_index(:teams, [:name])
  end
end
