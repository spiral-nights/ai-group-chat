defmodule AiGroupChatWeb.InvitationRegistrationLive do
  use AiGroupChatWeb, :live_view
  require Logger

  alias AiGroupChat.Accounts
  alias AiGroupChat.Accounts.User
  alias AiGroupChat.Repo

  def mount(%{"token" => token}, _session, socket) do
    case Accounts.get_invitation_by_token(token) do
      %Accounts.Invitation{} = invitation ->
        inviting_user = Accounts.get_user!(invitation.inviting_user_id)
        account = Repo.get!(AiGroupChat.Accounts.Account, invitation.account_id)

        changeset =
          %User{}
          |> User.registration_changeset(%{email: invitation.email})
          |> Map.put(:action, :insert) # Ensure action is insert for new user

        socket =
          socket
          |> assign(trigger_submit: false, check_errors: false)
          |> assign(invitation: invitation, inviting_user: inviting_user, account: account, invitation_email_prefilled: true)
          |> assign_form(changeset)

        {:ok, socket, temporary_assigns: [form: nil]}

      _ ->
        # Invalid or expired token, redirect to normal registration
        {:redirect, ~p"/users/register"}
    end
  end

  def mount(_params, _session, _socket) do
    # Should not be mounted without a token
    {:redirect, ~p"/users/register"}
  end


  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        # Associate user with the invited account
        case Accounts.associate_user_with_account(user, socket.assigns.invitation.account_id) do
          {:ok, _updated_user} ->
            # Successfully associated, delete invitation
            Accounts.delete_invitation(socket.assigns.invitation)
            Logger.info("User #{user.id} registered via invitation and associated with account #{socket.assigns.invitation.account_id}")

          {:error, _reason} ->
            # Failed to associate user, log error
            Logger.error(
              "Failed to associate user #{user.id} with account #{socket.assigns.invitation.account_id} after invitation registration."
            )
        end

        # Deliver confirmation instructions
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
