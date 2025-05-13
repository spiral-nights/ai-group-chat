defmodule AiGroupChatWeb.InvitationLive.Index do
  use AiGroupChatWeb, :live_view

  alias AiGroupChat.Accounts
  alias AiGroupChat.Repo

  def mount(_params, _session, socket) do
    changeset =
      %Accounts.Invitation{}
      |> Accounts.Invitation.changeset(%{})

    {:ok, assign(socket, form: to_form(changeset), result: nil)}
  end

  def handle_event("send_invitation", %{"invitation" => %{"email" => email}}, socket) do
    # Get the current user from socket assigns and preload their account
    current_user = socket.assigns.current_user
    user_with_account = Repo.preload(current_user, :account)
    current_account = user_with_account.account

    case Accounts.create_invitation(user_with_account, current_account, email) do
      {:ok, _invitation} ->
        {:noreply, assign(socket, result: {:ok, "Invitation sent to #{email}!"})}

      {:error, changeset} ->
        {:noreply,
         assign(socket, form: to_form(changeset), result: {:error, "Failed to send invitation."})}
    end
  end
end
