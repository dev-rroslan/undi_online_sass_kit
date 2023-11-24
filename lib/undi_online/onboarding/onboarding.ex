defmodule UndiOnline.Onboarding do
  @moduledoc """
  Steps definition and helpers for the account onboarding feature.
  """

  alias UndiOnline.Onboarding.Step

  def require_onboarding?(opts \\ []) do
    Application.get_env(:undi_online, :onboarding_required) == true || Keyword.get(opts, :override_for_test, false)
  end

  def steps do
    [
      %Step{
        key: "step-1",
        title: "Add additional account info"
      },
      %Step{
        key: "step-2",
        title: "Setup app"
      },
      %Step{
        key: "step-3",
        title: "Pick first action"
      }
    ]
  end

  def get_step_for_account(%{onboarding_required: false} = _account), do: nil
  def get_step_for_account(%{onboarding_completed_at: %NaiveDateTime{}} = _account), do: nil
  def get_step_for_account(%{onboarding_step: nil} = _account) do
    steps() |> List.first()
  end
  def get_step_for_account(%{onboarding_step: current_step} = _account) do
    step_keys = Enum.map(steps(), & &1.key)

    case Enum.find_index(step_keys, &  &1 == current_step) do
      nil ->
        nil
      idx ->
        Enum.at(steps(), idx + 1)
    end
  end

  def step_is_current_or_previous?(step, active_step) do
    Enum.find_index(steps(), &(&1 == step)) <= Enum.find_index(steps(), &(&1 == active_step))
  end
end