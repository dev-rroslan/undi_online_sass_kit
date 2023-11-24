defmodule UndiOnlineWeb.Admin.DeveloperLiveTest do
  use UndiOnlineWeb.ConnCase

  import Phoenix.LiveViewTest

  setup :register_and_log_in_admin

  describe "Index" do
    test "Displays the page", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/developers")

      assert html =~ "Developer Page"
    end
  end
end
