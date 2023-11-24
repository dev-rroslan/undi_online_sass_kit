defmodule UndiOnlineWeb.OnboardingLive.New do
  @moduledoc """
  This LiveView is used for onboarding and each onboarding step is
  mounted as a component. The components is defined in
  get_component/1
  """
  use UndiOnlineWeb, :live_view

  alias UndiOnline.Onboarding
  alias UndiOnline.Accounts

  import UndiOnlineWeb.AccountOnboarding, only: [get_next_step: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => "" <> _} = _params, _url, socket) do
    next_step = get_next_step(socket.assigns.current_account)

    {
      :noreply,
      socket
      |> assign(:step, next_step)
      |> assign(:steps, Onboarding.steps())
      |> assign(:component, get_component(next_step))
    }
  end

  def handle_params(_params, _url, socket) do
    next_step = get_next_step(socket.assigns.current_account)

    if next_step do
      {:noreply, push_patch(socket, to: "/onboarding/#{next_step.key}")}
    else
      {:noreply, push_redirect(socket, to: "/app")}
    end
  end

  @impl true
  def handle_event("continue", _, socket) do
    case Accounts.update_account(socket.assigns.current_account, get_attributes(socket.assigns.step)) do
      {:ok, _account} ->
        {:noreply,
         socket
         |> push_redirect(to: ~p"/onboarding")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def get_component(step) do
    case step.key do
      "step-2" -> UndiOnlineWeb.OnboardingLive.StepTwo
      "step-3" -> UndiOnlineWeb.OnboardingLive.StepThree
      _ -> UndiOnlineWeb.OnboardingLive.StepOne
    end
  end

  def is_active?(step, active_step) do
    Onboarding.step_is_current_or_previous?(step, active_step)
  end

  def get_attributes(step) do
    is_last? = List.last(Onboarding.steps()) == step

    %{
      onboarding_step: step.key,
      onboarding_completed_at: (if is_last?, do: NaiveDateTime.local_now(), else: nil)
    }
  end
end