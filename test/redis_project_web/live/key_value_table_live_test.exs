defmodule RedisProjectWeb.KeyValueTableLiveTest do
  use RedisProjectWeb.ConnCase

  import Phoenix.LiveViewTest
  import RedisProject.KeyValueFixtures
  @create_attrs %{value: "some value", key: "some key"}
  @update_attrs %{value: "some updated value", key: "some updated key"}
  @invalid_attrs %{value: nil, key: nil}

  defp create_key_value_table(_) do
    key_value_table = key_value_table_fixture()
    %{key_value_table: key_value_table}
  end

  describe "Index" do
    setup [:create_key_value_table]

    test "lists all key_values", %{conn: conn, key_value_table: key_value_table} do
      {:ok, _index_live, html} = live(conn, ~p"/key_values")

      assert html =~ "Listing Key Values"
      assert html =~ key_value_table.value
    end

    test "saves new key_value_table", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/key_values")

      assert index_live |> element("button", "New Key Value") |> render_click()
      assert has_element?(index_live, "#key_value_modal", "New Key Value")
    end

    test "updates key_value_table in listing", %{conn: conn, key_value_table: key_value_table} do
      {:ok, index_live, _html} = live(conn, ~p"/key_values")

      assert index_live
             |> element("button[phx-value-id='#{key_value_table.id}']", "Edit")
             |> render_click()
    end

    test "deletes key_value_table in listing", %{conn: conn, key_value_table: key_value_table} do
      {:ok, index_live, _html} = live(conn, ~p"/key_values")

      assert index_live
             |> element("button[phx-value-id='#{key_value_table.id}']", "Delete")
             |> render_click()

      refute has_element?(index_live, "#key_values-#{key_value_table.id}")
    end
  end

  describe "Show" do
    setup [:create_key_value_table]

    test "displays key_value_table", %{conn: conn, key_value_table: key_value_table} do
      {:ok, _show_live, html} = live(conn, ~p"/key_values")

      assert html =~ "Listing Key Values"
      assert html =~ key_value_table.value
    end
  end
end
