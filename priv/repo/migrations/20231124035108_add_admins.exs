defmodule UndiOnline.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:admins, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :email, :citext, null: false
      add :password_hash, :string, null: false
      add :confirmed_at, :naive_datetime

      timestamps()
    end

    create unique_index(:admins, [:email])
  end
end
