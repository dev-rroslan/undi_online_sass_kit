defmodule UndiOnlineWeb.OnboardingLive.StepTwo do
  @moduledoc """
  Step two of the onboarding steps. Change this component to fit your needs.
  Make sure the user triggers the handle_event complete.
  """
  use UndiOnlineWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id}>
      <div class="flex h-48 justify-center items-center">
        <.button phx-target={@myself} phx-click="complete" class="text-gray-900 bg-white border border-gray-300 focus:outline-none hover:bg-gray-100 focus:ring-4 focus:ring-gray-200 font-medium rounded-lg text-sm px-5 py-2.5 mr-2 mb-2 dark:bg-gray-800 dark:text-white dark:border-gray-600 dark:hover:bg-gray-700 dark:hover:border-gray-600 dark:focus:ring-gray-700">Complete step</.button>
      </div>

      <div class="flex justify-end mt-8 mb-2">
        <.button phx-click="continue" disabled={!@step_completed}>Continue</.button>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:step_completed, false)}
  end

  @impl true
  def handle_event("complete", _, socket) do
    {:noreply, assign(socket, :step_completed, true)}
  end
end