defmodule AiGroupChat.Accounts.UserNotifier do
  import Swoosh.Email
  alias AiGroupChat.Mailer

  # Delivers the email using the application mailer.
  # Now supports both text and HTML emails
  defp deliver(recipient, subject, body, html_body \\ nil) do
    email =
      new()
      |> to(recipient)
      |> from({"AiGroupChat", "contact@example.com"})
      |> subject(subject)
      |> text_body(body)
      |> maybe_add_html_body(html_body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    else
      error -> 
        # Handle error cases properly
        {:error, error}
    end
  end

  # Helper function to conditionally add HTML body
  defp maybe_add_html_body(email, nil), do: email
  defp maybe_add_html_body(email, html_body), do: html_body(email, html_body)

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Confirmation instructions", """
    ==============================
    Hi #{user.email},
    You can confirm your account by visiting the URL below:
    #{url}
    If you didn't create an account with us, please ignore this.
    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Reset password instructions", """
    ==============================
    Hi #{user.email},
    You can reset your password by visiting the URL below:
    #{url}
    If you didn't request this change, please ignore this.
    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """
    ==============================
    Hi #{user.email},
    You can change your email by visiting the URL below:
    #{url}
    If you didn't request this change, please ignore this.
    ==============================
    """)
  end

  @doc """
  Deliver invitation instructions to join an account.
  """
  def deliver_invitation_instructions(recipient_email, account_name, invitation_url) do
    subject = "Invitation to join #{account_name} on AI Group Chat"
    
    text_body = """
    ==============================
    Hi there,
    
    You've been invited to join #{account_name} on AI Group Chat.
    
    You can accept this invitation by visiting the URL below:
    #{invitation_url}
    
    If you didn't expect this invitation, please ignore this email.
    ==============================
    """
    
    # Using embedded HTML instead of templates to avoid rendering issues
    html_body = """
    <!DOCTYPE html>
    <html>
    <head>
      <title>Invitation to #{account_name}</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          line-height: 1.6;
          color: #333;
          max-width: 600px;
          margin: 0 auto;
          padding: 20px;
        }
        .header {
          background-color: #4a74b5;
          color: white;
          padding: 15px;
          text-align: center;
          border-radius: 5px 5px 0 0;
        }
        .content {
          border: 1px solid #ddd;
          border-top: none;
          padding: 20px;
          border-radius: 0 0 5px 5px;
        }
        .button {
          display: inline-block;
          background-color: #4CAF50;
          color: white;
          padding: 12px 24px;
          text-decoration: none;
          border-radius: 4px;
          margin: 15px 0;
          font-weight: bold;
        }
        .footer {
          margin-top: 20px;
          font-size: 0.8em;
          color: #666;
          text-align: center;
        }
      </style>
    </head>
    <body>
      <div class="header">
        <h1>You're Invited!</h1>
      </div>
      
      <div class="content">
        <p>Hello,</p>
        
        <p>You've been invited to join <strong>#{account_name}</strong> on AI Group Chat.</p>
        
        <p>Click the button below to accept this invitation and set up your account:</p>
        
        <div style="text-align: center;">
          <a href="#{invitation_url}" class="button">Accept Invitation</a>
        </div>
        
        <p>Or copy and paste this URL into your browser:</p>
        <p style="word-break: break-all; background: #f5f5f5; padding: 10px; border-radius: 4px;">
          #{invitation_url}
        </p>
        
        <p>If you didn't expect to receive this invitation, you can safely ignore this email.</p>
        
        <p>Best regards,<br>The AI Group Chat Team</p>
      </div>
      
      <div class="footer">
        <p>© #{DateTime.utc_now().year} AI Group Chat. All rights reserved.</p>
        <p>This email was sent to you because someone invited you to join their AI Group Chat account.</p>
      </div>
    </body>
    </html>
    """
    
    deliver(recipient_email, subject, text_body, html_body)
  end
end
