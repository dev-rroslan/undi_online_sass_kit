defmodule UndiOnline.Repo.Migrations.AddNameFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :name, :string
      add :image, :string
    end
  end
end
