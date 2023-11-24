import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

config :undi_online, Oban, testing: :manual

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :undi_online, UndiOnline.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "undi_online_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :undi_online, UndiOnlineWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "EVU1FL02BRwB0Es5pBScn485drXgRmTxcQuWTdHCjkdV2uPrGw8PPSnu6sYexEve",
  server: true

# In test we don't send emails.
config :undi_online, UndiOnline.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :undi_online, onboarding_required: false
config :undi_online, require_2fa_setup: false
