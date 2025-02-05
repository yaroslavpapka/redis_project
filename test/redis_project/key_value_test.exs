defmodule RedisProject.KeyValueTest do
  use ExUnit.Case, async: true

  alias RedisProject.KeyValue

  setup do
    Redix.command(:redix, ["FLUSHDB"])
    :ok
  end

  describe "list_key_values/0" do
    test "returns all key-value pairs" do
      Redix.command(:redix, ["SET", "key1", "value1"])
      Redix.command(:redix, ["SET", "key2", "value2"])

      result = KeyValue.list_key_values()
      assert [%{id: "key1", value: "value1"}, %{id: "key2", value: "value2"}] = Enum.sort(result, &(&1.id <= &2.id))
    end
  end

  describe "get_key_value!/1" do
    test "returns the correct value for a given key" do
      Redix.command(:redix, ["SET", "test_key", "test_value"])
      assert %{id: "test_key", value: "test_value"} == KeyValue.get_key_value!("test_key")
    end
  end

  describe "create_key_value/1" do
    test "creates a key-value pair" do
      assert {:ok, %{id: "new_key", value: "new_value"}} = KeyValue.create_key_value(%{key: "new_key", value: "new_value"})
      assert %{id: "new_key", value: "new_value"} == KeyValue.get_key_value!("new_key")
    end
  end

  describe "update_key_value/2" do
    test "updates an existing key" do
      Redix.command(:redix, ["SET", "existing_key", "old_value"])
      assert {:ok, %{id: "existing_key", value: "new_value"}} = KeyValue.update_key_value("existing_key", "new_value")
      assert %{id: "existing_key", value: "new_value"} == KeyValue.get_key_value!("existing_key")
    end
  end

  describe "delete_key_value/1" do
    test "deletes an existing key" do
      Redix.command(:redix, ["SET", "to_delete", "some_value"])
      assert :ok == KeyValue.delete_key_value("to_delete")
      assert {:error, "Key to_delete does not exist"} == KeyValue.get_key_value!("to_delete")
    end
  end
end
