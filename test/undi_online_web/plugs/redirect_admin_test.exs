defmodule UndiOnlineWeb.Plugs.RedirectAdminTest do
  use UndiOnlineWeb.ConnCase, async: true

  alias UndiOnlineWeb.Plugs.RedirectAdmin

  describe "call when admin is logged in" do
    setup :register_and_log_in_admin

    test "redirects away to admin dashboard path", %{conn: conn} do
      conn =
        conn
        |> RedirectAdmin.call([])

      assert redirected_to(conn) == ~p"/admin"
    end
  end

  describe "call when admin is not logged in" do
    test "doesnt redirect admin", %{conn: conn} do
      updated_conn =
        conn
        |> RedirectAdmin.call([])

      assert updated_conn == conn
    end
  end
end
