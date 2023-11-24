defmodule UndiOnlineWeb.CommandPaletteTest do
  use UndiOnline.DataCase

  alias UndiOnlineWeb.CommandPalette
  alias UndiOnlineWeb.CommandPalette.Result

  describe "search/1" do
    test "with en empty string, it returns no results" do
      assert CommandPalette.search("") == []
    end

    test "with a string that has now match, it returns no results" do
      assert CommandPalette.search("gibberish") == []
    end

    test "with a string that has a match, it returns a list if results" do
      assert [
               %Result{
                 record: %{label: "Settings", path: "/users/settings"},
                 type: :route,
                 first_type: true,
                 index: 0
               }
             ] = CommandPalette.search("sett")
    end
  end
end
