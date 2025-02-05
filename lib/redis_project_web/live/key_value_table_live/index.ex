defmodule RedisProjectWeb.KeyValueTableLive.Index do
  use RedisProjectWeb, :live_view

  alias RedisProject.KeyValue

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:show_modal, false)
     |> assign(:delete_modal, false)
     |> stream(:key_values, KeyValue.list_key_values())}
  end

  @impl true
  def handle_event("new_key_value", _, socket) do
    open_modal(socket, %{id: "", value: ""}, "New Key Value")
  end

  def handle_event("edit_key_value", %{"id" => id}, socket) do
    key_value = KeyValue.get_key_value!(id)
    open_modal(socket, %{id: key_value.id, value: key_value.value}, "Edit Key Value")
  end

  def handle_event("confirm_delete", %{"id" => id}, socket) do
    {:noreply, assign(socket, key_value_table: KeyValue.get_key_value!(id), delete_modal: true)}
  end

  @impl true
  def handle_info({component, {:created, key_value}}, socket) when component == RedisProjectWeb.KeyValueTableLive.FormComponent do
    update_stream(socket, &stream_insert(&1, :key_values, key_value, at: 0), "Key value saved successfully")
  end

  def handle_info({component, {:delete_confirmed, key_value}}, socket) when component == RedisProjectWeb.KeyValueTableLive.ConfirmDeleteComponent do
    update_stream(socket, &stream_delete(&1, :key_values, key_value), "Key value deleted successfully")
  end

  def handle_info({_component, :closed}, socket) do
    {:noreply, assign(socket, show_modal: false, delete_modal: false)}
  end

  defp open_modal(socket, key_value, title) do
    {:noreply, assign(socket, key_value_table: key_value, page_title: title, show_modal: true)}
  end

  defp update_stream(socket, update_fun, message) do
    socket
    |> update_fun.()
    |> assign(show_modal: false, delete_modal: false)
    |> put_flash(:info, message)
    |> then(&{:noreply, &1})
  end
end
