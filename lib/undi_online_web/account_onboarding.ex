defmodule UndiOnlineWeb.AccountOnboarding do
  @moduledoc """
  Plug and LiveView hook for mauybe redirect user into
  the onboarding flow.
  """
  use UndiOnlineWeb, :verified_routes
  alias UndiOnline.Onboarding

  def require_onboarded_account(%{assigns: %{current_account: %{} = account}} = conn, _opts) do
    with true <- Onboarding.require_onboarding?(),
         %{key: step} <- Onboarding.get_step_for_account(account) do

      conn
      |> Phoenix.Controller.redirect(to: ~p"/onboarding/#{step}")
      |> Plug.Conn.halt()
    else
      _ ->
        conn
    end
  end

  def require_onboarded_account(conn, _opts), do: conn

  def on_mount(:require_onboarded_account, _params, session, %{assigns: %{current_account: %{} = account}} = socket) do
    override_for_test = Map.get(session, "override_for_test") == true

    with true <- Onboarding.require_onboarding?(override_for_test: override_for_test),
         %{key: step} <- Onboarding.get_step_for_account(account) do

      {:halt, Phoenix.LiveView.redirect(socket, to: "/onboarding/#{step}")}
    else
      _ ->
        {:cont, socket}
    end
  end

  def on_mount(:require_onboarded_account, _params, _session, socket) do
    {:cont, socket}
  end

  def on_mount(:refute_onboarded_account, _params, session, socket) do
    override_for_test = Map.get(session, "override_for_test") == true

    if Onboarding.require_onboarding?(override_for_test: override_for_test) && get_next_step(socket.assigns.current_account) do
      {:cont, socket}
    else
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/")}
    end
  end

  def get_next_step(account) do
    Onboarding.get_step_for_account(account)
  end
end