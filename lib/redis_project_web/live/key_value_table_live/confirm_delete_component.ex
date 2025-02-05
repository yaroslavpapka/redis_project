defmodule RedisProjectWeb.KeyValueTableLive.ConfirmDeleteComponent do
  use RedisProjectWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.modal
        :if={@show_modal}
        id="delete_key_value_modal"
        show
        on_cancel={JS.push("close_modal", target: @myself)}
      >
        <.header>{@title}</.header>
        <p>Are you sure you want to delete the key "<%= @key_value_table.id %>"?</p>

        <div class="actions">
          <.button
            phx-click="delete_key_value"
            phx-target={@myself}
            phx-disable-with="Deleting..."
            class="btn-danger"
          >
            Yes, Delete
          </.button>
          <.button
            phx-click="close_modal"
            phx-target={@myself}
            class="btn-secondary"
          >
            Cancel
          </.button>
        </div>
      </.modal>
    </div>
    """
  end

  @impl true
  def update(assigns, socket), do: {:ok, assign(socket, assigns)}

  @impl true
  def handle_event("delete_key_value", _, socket) do
    with :ok <- RedisProject.KeyValue.delete_key_value(socket.assigns.key_value_table.id) do
      send(self(), {__MODULE__, {:delete_confirmed, socket.assigns.key_value_table}})
      {:noreply, assign(socket, :show_modal, false)}
    end
  end

  def handle_event("close_modal", _, socket) do
    send(self(), {__MODULE__, :closed})
    {:noreply, assign(socket, :show_modal, false)}
  end
end
