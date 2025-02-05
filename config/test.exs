import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :redis_project, RedisProjectWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "+IJt3V1XXBCHObFT71Rwa23/wK+PqJqGEj+G0nJ2P3x1OR/fHY9+8t5zJNFHfwJ4",
  server: false

# In test we don't send emails.
config :redis_project, RedisProject.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true
