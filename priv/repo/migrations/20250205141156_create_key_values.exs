defmodule RedisProject.Repo.Migrations.CreateKeyValues do
  use Ecto.Migration

  def change do
    create table(:key_values) do
      add :key, :string
      add :value, :string

      timestamps(type: :utc_datetime)
    end
  end
end
