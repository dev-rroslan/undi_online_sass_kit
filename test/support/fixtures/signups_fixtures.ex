defmodule UndiOnline.SignupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UndiOnline.Signups` context.
  """

  def unique_signup_email, do: "signup#{System.unique_integer()}@example.com"

  def signup_fixture(attrs \\ %{}) do
    {:ok, signup} =
      attrs
      |> Enum.into(%{
        email: unique_signup_email(),
        topic: "some topic"
      })
      |> UndiOnline.Signups.create_signup()

    signup
  end
end
