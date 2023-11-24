defmodule UndiOnline.Admins.AdminNotifierTest do
  use UndiOnline.DataCase, async: true

  alias UndiOnline.Admins.AdminNotifier

  test "admin login link email" do
    message = %{url: ~s(#somelinkwithtoken), email: "john.doe@example.com"}

    email = AdminNotifier.admin_login_link(message)

    assert email.to == [{"", "john.doe@example.com"}]
    assert email.from == {"", "noreply@example.com"}
    assert email.html_body =~ "href=\"#somelinkwithtoken\""
  end
end
