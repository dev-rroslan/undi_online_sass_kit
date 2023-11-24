defmodule UndiOnline.Admins.GenerateAdmin do
  @moduledoc """
  This module contains logic for generating a new admin.
  """
  alias UndiOnline.Admins
  alias UndiOnline.Admins.Admin
  alias UndiOnline.Repo

  def zero_admins?, do: Repo.aggregate(Admin, :count) == 0

  def generate_admin(email) do
    password = generate_password()

    case Admins.create_admin(%{email: email, password: password, password_confirmation: password}) do
      {:ok, _admin} -> {:ok, email, password}
      error -> error
    end
  end

  defp generate_password() do
    :crypto.strong_rand_bytes(12)
    |> Base.url_encode64()
    |> binary_part(0, 12)
  end
end
