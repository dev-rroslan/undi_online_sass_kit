defmodule UndiOnline.Admins.Auth do
  @moduledoc """
  Admin authentication module. Admin authentication is based on
  the Guardian and Bcrypt library.
  """

  alias UndiOnline.Repo
  alias UndiOnline.Admins.Admin

  @doc """
  Tries to authenticate the user via email and password.

  ## Examples
      iex> authenticate_admin("some@email.com", "secret")
      {:ok, %User{}}

      iex> authenticate_admin("some@email.com", "wrong")
      {:error, "Error message"}
  """
  def authenticate_admin(email, password) do
    Repo.get_by(Admin, email: email)
    |> check_password(password)
  end

  defp check_password(admin, password) do
    hash = if is_nil(admin), do: "no-admin", else: admin.password_hash

    if Bcrypt.verify_pass(password, hash) do
      {:ok, admin}
    else
      {:error, "Incorrect email or password"}
    end
  end
end
