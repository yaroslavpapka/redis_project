defmodule RedisProject.KeyValueFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RedisProject.KeyValue` context.
  """

  @doc """
  Generate a key_value_table.
  """
  def key_value_table_fixture(attrs \\ %{}) do
    {:ok, key_value_table} =
      attrs
      |> Enum.into(%{
        key: "some key",
        value: "some value"
      })
      |> RedisProject.KeyValue.create_key_value()

    key_value_table
  end
end
