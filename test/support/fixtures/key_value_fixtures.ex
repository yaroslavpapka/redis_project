defmodule RedisProject.KeyValueFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RedisProject.KeyValue` context.
  """

  @doc """
  Generate a key_value_table.
  """
 def key_value_table_fixture(attrs \\ %{}) do
   random_suffix = :crypto.strong_rand_bytes(4) |> Base.encode16()
   key = attrs[:key] || "some_key_#{random_suffix}"
   value = attrs[:value] || "some_value_#{random_suffix}"

   {:ok, key_value_table} =
     attrs
     |> Enum.into(%{key: key, value: value})
     |> RedisProject.KeyValue.create_key_value()

   key_value_table
 end

end
