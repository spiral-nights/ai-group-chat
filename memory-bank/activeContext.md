# Active Context

## Current Work Focus

Memory bank update to reflect the completed invitation registration feature and recent changes.

## Recent Changes

- Created a new LiveView module `InvitationRegistrationLive` (`lib/ai_group_chat_web/live/invitation_registration_live.ex`) and its corresponding template (`lib/ai_group_chat_web/live/invitation_registration_live/invitation_registration.html.heex`) for invitation-based registration.
- Added a new route `/users/register/:token` to `lib/ai_group_chat_web/router.ex` for the invitation registration page.
- Removed the redundant `/invitations/:token` route from `lib/ai_group_chat_web/router.ex` and the `InvitationLive.Accept` LiveView module and file (`lib/ai_group_chat_web/live/invitation_live/accept.ex`).
- Refactored the `handle_event("save", ...)` function in `lib/ai_group_chat_web/live/user_registration_live.ex` to separate normal and invitation registration logic into `handle_normal_registration` and `handle_invitation_registration`.
- Updated the invitation URL in `lib/ai_group_chat/accounts.ex` to point to the new `/users/register/:token` route.
- Modified the `create_accounts` migration (`priv/repo/migrations/20250508034036_create_accounts.exs`) to make the `owner_id` column nullable from the start.
- Removed the unnecessary `make_accounts_owner_id_nullable` migration file (`priv/repo/migrations/20250513042319_make_accounts_owner_id_nullable.exs`).
- Updated the email sending code in `lib/ai_group_chat/accounts/user_notifier.ex` to embed the HTML email body directly within the `deliver_invitation_instructions` function and updated the `deliver` function to support an optional HTML body.
- Created the `AiGroupChatWeb.EmailComponents` module (`lib/ai_group_chat_web/email_components.ex`) and configured it to use `Phoenix.Template` for rendering (though this approach was later abandoned for embedded HTML in `user_notifier.ex`).
- Moved the `invitation.html.heex` template to `lib/ai_group_chat_web/invitation.html.heex` (though this template is not currently used for sending invitations).
- Corrected the `mount` function in `lib/ai_group_chat_web/live/invitation_live/index.ex` to initialize the invitation form changeset correctly, resolving the "can't be blank" error on the invite sending page.
- Added the necessary `alias AiGroupChat.Repo` in `lib/ai_group_chat_web/live/invitation_registration_live.ex` to resolve the `AiGroupChat.Accounts.Repo.get!/2` undefined function error.
- Debugged issues related to template rendering in `AiGroupChatWeb.EmailComponents`, including removing a recursive `render/2` function and correcting a `render_to_string` call (these changes are not currently active for invitation emails due to embedded HTML).
- The user manually resolved the `:inner_content` not found error on the invitation registration page and verified the invitation registration feature is now working.
- Implemented displaying the list of participants in the chat room and updated the participant check logic in `lib/ai_group_chat_web/live/chat_room_live/show.ex`.
- Implemented real-time participant list updates in `lib/ai_group_chat_web/live/chat_room_live/show.ex` by broadcasting participant additions and handling the broadcast to refetch and update the participant list.

## Next Steps

- Implement the Task Assignment feature.
- Implement the Shared Calendar feature.
- Integrate AI assistance for task assignment and calendar event creation.
- Implement PWA Functionality (manifest file, service worker).
- Continue implementing other core features as outlined in the updated project brief.

## Active Decisions and Considerations

- Utilizing Elixir/Phoenix with LiveView and Channels for real-time PWA development.
- Focusing on registered users within an account for all core features.
- Using a `Participant` schema to handle registered users in chat rooms.
- Implementing an email-based invitation system for account grouping with a dedicated registration page for invited users.
- Handling invitation acceptance by associating the registered user with the invited account and deleting the invitation.
- Implementing explicit participant addition for chat rooms with same-account verification.
- Ensuring database schema and application code are aligned, particularly regarding UUID foreign keys and nullable columns (specifically `owner_id` in `accounts`).
- Using Phoenix.Token for secure invitation tokens and Swoosh for email delivery.
- Currently using embedded HTML for the invitation email body in `user_notifier.ex` to avoid template rendering issues.
- Carefully managing database migrations and schema changes, including modifying existing migrations when necessary and dropping/recreating the database in development.

## Important Patterns and Preferences

- Following Elixir/Phoenix conventions and best practices.
- Prioritizing real-time performance and scalability.
- Ensuring routes requiring authentication are properly protected.
- Using a consistent approach for handling data types (UUIDs/binary_ids) in schemas and migrations.
- Using Phoenix.Token for secure invitation tokens and Swoosh for email delivery.
- Carefully managing database migrations and schema changes.
- Using embedded HTML for email bodies as a workaround for template rendering issues in `user_notifier.ex`.

## Learnings and Project Insights

- The `Participant` schema can be adapted to handle only registered users.
- Removing guest access simplifies the authentication and participant management logic.
- Explicitly defining foreign key fields in schemas is generally good practice, but Ecto's `belongs_to` can handle it implicitly if the naming convention is followed.
- Implementing a dedicated invitation registration page simplifies the flow for unauthenticated invited users compared to redirecting to the general registration page.
- Using dedicated email component modules helps organize email templates and rendering logic, but requires careful configuration for template discovery and can sometimes present rendering challenges.
- Careful attention to migration dependencies and rollbacks is crucial when modifying database schemas, and sometimes modifying prior migrations and dropping/recreating the database is necessary in development.
- Implementing explicit participant addition requires updating both backend logic and frontend UI/event handling.
- It's important to double-check the database schema after manual resets to ensure it matches the intended state defined in the migration files.
- Explicitly preloading associations in LiveView `handle_event` functions may be necessary if the `require_authenticated_user` plug doesn't automatically preload them.
- Carefully review and test database interactions to prevent type mismatch errors.
- Debugging template rendering issues requires verifying module configuration, template location, and the arguments passed to rendering functions. Embedded HTML can be a workaround for complex template rendering issues.
- Recursive function calls can cause infinite loops and stack overflows.
- The `:inner_content` error indicates a mismatch between a LiveView's layout rendering and the provision of template content.
- The user has successfully completed the invitation registration feature manually.
