defmodule TwitterClone.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :banner_image, :string
      add :profile_image, :string
      add :hashed_password, :string
      add :date_of_birth, :date
      add :email, :string
      add :api_token, :string
      add :role, :string, null: false

      timestamps()
    end
    create unique_index(:users, [:username])
  end
end
