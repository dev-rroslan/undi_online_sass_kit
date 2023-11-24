defmodule UndiOnline.Billing.Helpers do
  @moduledoc """
  This module contains helpers for the billing modules and codes.
  """

  @signing_key "billing_signing_key"

  def encode_token(token) do
    Phoenix.Token.sign(UndiOnlineWeb.Endpoint, @signing_key, token)
  end

  def decode_token(encoded_token) do
    Phoenix.Token.verify(UndiOnlineWeb.Endpoint, @signing_key, encoded_token, max_age: 2000)
  end
end
