defmodule AiGroupChatWeb.ChatRoomLive.FormComponent do
  use AiGroupChatWeb, :live_component

  alias AiGroupChat.Chat

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage chat_room records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="chat_room-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Chat room</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{chat_room: chat_room} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Chat.change_chat_room(chat_room))
     end)}
  end

  @impl true
  def handle_event("validate", %{"chat_room" => chat_room_params}, socket) do
    changeset = Chat.change_chat_room(socket.assigns.chat_room, chat_room_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"chat_room" => chat_room_params}, socket) do
    save_chat_room(socket, socket.assigns.action, chat_room_params)
  end

  defp save_chat_room(socket, :edit, chat_room_params) do
    case Chat.update_chat_room(socket.assigns.chat_room, chat_room_params) do
      {:ok, chat_room} ->
        notify_parent({:saved, chat_room})

        {:noreply,
         socket
         |> put_flash(:info, "Chat room updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_chat_room(socket, :new, chat_room_params) do
    case Chat.create_chat_room(chat_room_params) do
      {:ok, chat_room} ->
        notify_parent({:saved, chat_room})

        {:noreply,
         socket
         |> put_flash(:info, "Chat room created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
