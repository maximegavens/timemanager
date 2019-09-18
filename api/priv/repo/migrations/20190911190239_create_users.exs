defmodule Api.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :password_hash, :string
      add :team, :integer
      add :role, :string
      add :token, :string
      add :expiry, :naive_datetime

      timestamps()
    end
  end
end
