defmodule UndiOnline.Repo.Migrations.AddOnboardingFieldsToAccounts do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :onboarding_required, :boolean, default: false
      add :onboarding_step, :string
      add :onboarding_completed_at, :naive_datetime
    end
  end
end