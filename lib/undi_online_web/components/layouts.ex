defmodule UndiOnlineWeb.Layouts do
  @moduledoc false
  use UndiOnlineWeb, :html

  embed_templates "layouts/*"

  defp app_nav_items do
    [
      %{label: "Dashboard", icon: "hero-home", path: ~p"/"},
      ## Insert app nav items below ##
    ]
  end

  defp admin_nav_items do
    [
      %{label: "Admin", icon: "hero-presentation-chart-line", path: ~p"/admin"},
      %{label: "Users", icon: "hero-user", path: ~p"/admin/users"},
      %{label: "Accounts", icon: "hero-users", path: ~p"/admin/accounts"},
      %{label: "Admins", icon: "hero-identification", path: ~p"/admin/admins"},
      %{label: "Developers", icon: "hero-beaker", path: ~p"/admin/developers"},
      ## Insert admin nav items below ##
      %{label: "Subscriptions", icon: "hero-credit-card", path: ~p"/admin/subscriptions"},
    ]
  end
end
