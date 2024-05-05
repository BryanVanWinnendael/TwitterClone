import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :twitter_clone, TwitterClone.Repo,
  username: "root",
  password: "t",
  hostname: "89.168.49.82",
  database: "twitter_clone_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :twitter_clone_web, TwitterCloneWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "a7eGx14UEaBB6cGo7w4+t95E7mrb2BtyVTHJLgRcrnFcGcGSyO9Fc/6zT0VL5FQy",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# In test we don't send emails.
config :twitter_clone, TwitterClone.Mailer, adapter: Swoosh.Adapters.Test

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
