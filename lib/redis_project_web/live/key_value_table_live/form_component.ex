defmodule RedisProjectWeb.KeyValueTableLive.FormComponent do
  use RedisProjectWeb, :live_component

  alias RedisProject.KeyValue

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.modal :if={@show_modal} id="key_value_modal" show on_cancel={JS.push("close", target: @myself)}>
        <div class="p-4 bg-white rounded-lg shadow-md">
          <.header>{@title}</.header>

          <.simple_form for={@form} id="key_value_table-form" phx-target={@myself} phx-submit="save">
            <.input field={@form[:id]} type="text" label="Key" value={@key_value_table.id} readonly={@key_value_table.id != ""} />
            <.input field={@form[:value]} type="text" label="Value" value={@key_value_table.value} />
            <:actions>
              <.button phx-disable-with="Saving...">Save</.button>
            </:actions>
          </.simple_form>
        </div>
      </.modal>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    form = to_form(%{source: assigns.key_value_table, data: assigns.key_value_table})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, form)
     |> assign(:show_modal, true)}
  end

  @impl true
  def handle_event("save", %{"id" => key, "value" => value}, socket) do
    case KeyValue.create_key_value(%{key: key, value: value}) do
      {:ok, key_value_table} ->
        send(self(), {__MODULE__, {:created, key_value_table}})
        {:noreply, assign(socket, :show_modal, false)}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Failed to save key value: #{inspect(reason)}")}
    end
  end

  def handle_event("close", _, socket) do
    send(self(), {__MODULE__, :closed})
    {:noreply, assign(socket, :show_modal, false)}
  end
end
