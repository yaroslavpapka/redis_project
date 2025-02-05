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
    execute_redis_command(["SET", key, value])
    |> handle_write_response(key, value, "Failed to create key-value pair")
  end

  def update_key_value(key, new_value) do
    with {:ok, _} <- execute_redis_command(["GET", key]),
         {:ok, "OK"} <- execute_redis_command(["SET", key, new_value]) do
      {:ok, %{id: key, value: new_value}}
    else
      {:error, _} -> {:error, "Key #{key} does not exist"}
    end
  end

  def delete_key_value(key) do
    case execute_redis_command(["DEL", key]) do
      {:ok, _} -> :ok
      {:error, reason} -> {:error, "Failed to delete key #{key}: #{reason}"}
    end
  end

  defp fetch_key_value(key) do
    case execute_redis_command(["GET", key]) do
      {:ok, value} -> %{id: key, value: value}
      {:error, _} -> {:error, "reason"}
    end
  end

  defp handle_write_response({:ok, "OK"}, key, value, _), do: {:ok, %{id: key, value: value}}
  defp handle_write_response({:error, reason}, _, _, error_msg), do: {:error, "#{error_msg}: #{reason}"}
end
