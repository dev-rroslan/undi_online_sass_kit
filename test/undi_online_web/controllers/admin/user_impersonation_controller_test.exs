defmodule UndiOnlineWeb.Admin.UserImpersonationControllerTest do
  use UndiOnlineWeb.ConnCase, async: true

  import UndiOnline.UsersFixtures

  setup :register_and_log_in_admin

  describe "user impersonation" do
    test "sets current_user and redirects", %{conn: conn} do
      user = user_fixture()

      conn =
        post(conn, ~p"/admin/impersonate/#{user.id}", %{})

      assert redirected_to(conn) == ~p"/"

      conn = get(conn,  ~p"/admin")
      assert html_response(conn, 200) =~ "Impersonating"
    end
  end
end
