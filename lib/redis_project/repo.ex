defmodule RedisProject.Repo do
  use Ecto.Repo,
    otp_app: :redis_project,
    adapter: Ecto.Adapters.Postgres
end
