defmodule UndiOnline.MixProject do
  use Mix.Project

  def project do
    [
      app: :undi_online,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {UndiOnline.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 3.1"},
      # ADDITIONAL PACKAGES
      {:stripity_stripe, "~> 2.0"},
      {:eqrcode, "~> 0.1.10"},
      {:nimble_totp, "~> 1.0.0"},
      {:wallaby, "~> 0.30.6", runtime: false, only: :test},
      {:waffle, "~> 1.1.7"},
      {:waffle_ecto, "~> 0.0.12"},

      # If using S3:
      {:ex_aws, "~> 2.5.0"},
      {:ex_aws_s3, "~> 2.5.2"},
      {:hackney, "~> 1.20.1"},
      {:sweet_xml, "~> 0.7.4"},
      {:ueberauth, "~> 0.10.5"},
      {:ueberauth_github, "~> 0.8.3"},
      {:cachex, "~> 3.6.0"},
      {:absinthe, "~> 1.7.6"},
      {:absinthe_plug, "~> 1.5.8"},
      {:flop, "~> 0.24.1"},
      {:flop_phoenix, "~> 0.22.4"},
      {:guardian, "~> 2.3.2"},
      {:premailex, "~> 0.3.19"},
      {:oban, "~> 2.17.3"},
      {:credo, "~> 1.7.1", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.13.0", only: [:dev, :test], runtime: false},
      {:req, "~> 0.4.5"},

      # DEFAULT PACKAGES
      {:phoenix, "~> 1.7.10"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.1"},
      {:floki, ">= 0.30.0"},
      {:phoenix_live_dashboard, "~> 0.8.2"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:plug_cowboy, "~> 2.5"},
      {:saas_kit, "~> 1.0.3", only: :dev},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
