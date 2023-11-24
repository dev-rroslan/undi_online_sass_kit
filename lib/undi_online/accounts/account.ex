defmodule UndiOnline.Accounts.Account do
  @moduledoc """
  The Account Schema
  """
  use UndiOnline.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    default_limit: 20,
    filterable: [:search_phrase, :name],
    sortable: [:name],
    compound_fields: [search_phrase: [:name]]
  }
  schema "accounts" do
    field :name, :string
    field :personal, :boolean, default: false
    field :onboarding_required, :boolean, default: false
    field :onboarding_step, :string
    field :onboarding_completed_at, :naive_datetime

    belongs_to :created_by, UndiOnline.Users.User, foreign_key: :created_by_user_id
    has_many :memberships, UndiOnline.Accounts.Membership
    has_many :members, through: [:memberships, :member]

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :personal, :onboarding_required, :onboarding_step, :onboarding_completed_at])
    |> validate_required([:name, :personal])
    |> unique_constraint(:personal, name: :accounts_limit_personal_index)
    |> maybe_require_onboarding(attrs)
  end

  # Look into if this is the correct logic.
  # maybe just use put_new..
  defp maybe_require_onboarding(changeset, attrs) do
    required? = Map.get(attrs, :onboarding_required, Application.get_env(:undi_online, :onboarding_required))
    put_change(changeset, :onboarding_required, required?)
  end
end
