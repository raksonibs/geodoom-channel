use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :battledome, Battledome.Endpoint,
  secret_key_base: "f/ifIJE4uwNsW6avQwVIpTLMrkEWuveWbnrwvw+WwOWGuDji6D9Khmv8AskkQT0i"

# Configure your database
config :battledome, Battledome.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "battledome_prod",
  pool_size: 20
