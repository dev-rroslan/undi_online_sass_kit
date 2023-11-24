defmodule UndiOnline.Billing.HelpersTest do
  use UndiOnline.DataCase, async: true

  alias UndiOnline.Billing.Helpers

  describe "encoding and decoding tokens" do
    test "encode_token/1 returns a token string" do
      assert "" <> Helpers.encode_token("my_token")
    end

    test "decode_token/1 with a valid token returns an ok tuple" do
      encoded_token = Helpers.encode_token("my_token")
      assert Helpers.decode_token(encoded_token) == {:ok, "my_token"}
    end

    test "decode_token/1 with an invalid token returns an error tuple" do
      assert Helpers.decode_token("INVALID TOKEN") == {:error, :invalid}
    end
  end
end
