defmodule RedisProject.KeyValue.KeyValueTable do
  use Ecto.Schema
  import Ecto.Changeset

  schema "key_values" do
    field :value, :string
    field :key, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(key_value_table, attrs) do
    key_value_table
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
  end
end
