defmodule UndiOnlineWeb.Admin.SubscriptionLive.Show do
  @moduledoc """
  The admin subscription show page.
  """
  use UndiOnlineWeb, :live_view

  alias UndiOnline.Billing

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    subscription = Billing.get_subscription!(id)

    {:noreply,
     socket
     |> assign(:page_title, "Show Subscription")
     |> assign(:subscription, subscription)}
  end
end
