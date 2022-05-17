defmodule TwitterClone.Repo.Migrations.UserRelations do
  use Ecto.Migration

  def change do
    create table(:user_relations) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :following_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:user_relations, [:user_id, :following_id])


  end
end
