defmodule AiGroupChatWeb.UserRegistrationLive do
  use AiGroupChatWeb, :live_view
  require Logger

  alias AiGroupChat.Accounts
  alias AiGroupChat.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Register for an account
        <:subtitle>
          Already registered?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            Log in
          </.link>
          to your account now.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        socket =
          case get_in(socket.assigns, [:invitation_token]) do
            nil -> handle_normal_registration(socket, user)
            token -> handle_invitation_registration(socket, user, token)
          end

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

  defp handle_normal_registration(socket, user) do
    case Accounts.create_account(%{name: user.email}, user) do
      {:ok, _account} ->
        Logger.info("Account created for user #{user.id}")
        socket

      {:error, changeset} ->
        Logger.error("Failed to create account for user #{user.id}: #{inspect(changeset.errors)}")
        # Continue even if account creation fails for now
        socket
    end
  end

  defp handle_invitation_registration(socket, user, token) do
    case Accounts.get_invitation_by_token(token) do
      %Accounts.Invitation{} = invitation when invitation.email == user.email ->
        case Accounts.associate_user_with_account(user, invitation.account_id) do
          {:ok, _updated_user} ->
            Accounts.delete_invitation(invitation)
            assign(socket, :invitation_token, nil)

          {:error, _reason} ->
            Logger.error(
              "Failed to associate user #{user.id} with account #{invitation.account_id} after registration."
            )

            # Fallback to creating a new account if association fails
            handle_normal_registration(socket, user)
        end

      _ ->
        # Invitation not found, token invalid, or email mismatch, fallback to creating a new account
        handle_normal_registration(socket, user)
    end
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
