defmodule UndiOnline.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UndiOnlineWeb.Telemetry,
      UndiOnline.Repo,
      {DNSCluster, query: Application.get_env(:undi_online, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: UndiOnline.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: UndiOnline.Finch},
      # Start a worker by calling: UndiOnline.Worker.start_link(arg)
      # {UndiOnline.Worker, arg},
      # Start to serve requests, typically the last entry
      UndiOnlineWeb.Endpoint,
      webhook_processor_service(),
      {Cachex, name: :general_cache}, # You can add additional caches with different names

      {Oban, oban_config()},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UndiOnline.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UndiOnlineWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp oban_config do
    Application.fetch_env!(:undi_online, Oban)
  end

  # Dont start the genserver in test mode
  defp webhook_processor_service do
    if Application.get_env(:undi_online, :env) == :test,
      do: UndiOnline.Billing.Stripe.WebhookProcessor.Stub,
      else: UndiOnline.Billing.Stripe.WebhookProcessor
  end
end
