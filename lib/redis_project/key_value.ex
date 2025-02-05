defmodule RedisProject.KeyValue do
  @moduledoc """
  The KeyValue context responsible for interacting with Redis.
  """

  defp execute_redis_command(command), do: Redix.command(:redix, command)

  def list_key_values do
    with {:ok, keys} <- execute_redis_command(["KEYS", "*"]) do
      Enum.map(keys, &fetch_key_value/1)
    else
      {:error, reason} -> {:error, "Failed to list keys: #{reason}"}
    end
  end

  def get_key_value!(key), do: fetch_key_value(key)

  def create_key_value(%{key: key, value: value}) do
    with {:ok, 0} <- execute_redis_command(["EXISTS", key]),
         {:ok, "OK"} <- execute_redis_command(["SET", key, value]) do
      {:ok, %{id: key, value: value}}
    else
      {:ok, 1} -> {:error, "Key #{key} already exists"}
      {:error, reason} -> {:error, "Redis error: #{inspect(reason)}"}
    end
  end

  def update_key_value(key, new_value) do
    with {:ok, 1} <- execute_redis_command(["EXISTS", key]),
         {:ok, "OK"} <- execute_redis_command(["SET", key, new_value]) do
      {:ok, %{id: key, value: new_value}}
    else
      {:ok, 0} -> {:error, "Key #{key} does not exist"}
      {:error, reason} -> {:error, "Redis error: #{inspect(reason)}"}
    end
  end

  def delete_key_value(key) do
    case execute_redis_command(["DEL", key]) do
      {:ok, _} -> :ok
      {:error, reason} -> {:error, "Failed to delete key #{key}: #{reason}"}
    end
  end

  def key_exists?(key) do
    case execute_redis_command(["EXISTS", key]) do
      {:ok, 1} -> true
      _ -> false
    end
  end

  def fetch_key_value(key) do
    with true <- key_exists?(key),
         {:ok, value} <- execute_redis_command(["GET", key]) do
      %{id: key, value: value}
    else
      false -> {:error, "Key #{key} does not exist"}
      _ -> {:error, "Failed to fetch value"}
    end
  end
end
