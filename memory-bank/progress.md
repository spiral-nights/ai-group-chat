# Progress

## What Works

- The basic Elixir/Phoenix project structure is in place.
- Core memory bank files have been initialized and updated with project details.
- Basic User Authentication & Account Management setup using `phx.gen.auth` is complete, including user registration, email confirmation (via dev mailbox), and login/logout.
- Basic Chat Room Management setup using `phx.gen.live` is complete, including schema, context, and LiveViews for listing/creating/managing rooms (accessible to authenticated users).
- Real-time text chat functionality within chat rooms using Phoenix Channels is implemented, supporting registered users.
- The application has been refactored to use a `Participant` schema for handling registered users in chat rooms.
- Guest participant functionality has been removed.
- The Account Grouping/Invite System for family members has been implemented and verified, including account creation, invitation sending (via email with embedded HTML body), and a dedicated invitation registration page for invited users.
- Chat room access control has been implemented, requiring explicit participant addition within the same account and updating the chat room UI to allow adding users from the same account.
- The `owner_id` column in the `accounts` table is now nullable.

## What's Left to Build

- Task Assignment feature.
- Shared Calendar feature.
- Integrate AI assistance for task assignment and calendar event creation.
- PWA Functionality (manifest file, service worker).

## Current Status

The foundational authentication, basic chat room management systems, the Account Grouping/Invite System, and the chat room access control requiring explicit participant addition are set up and verified. Real-time text chat functionality has been implemented and refactored to use a `Participant` schema for handling registered users. Guest participant functionality has been successfully removed. The `owner_id` column in the `accounts` table is nullable. The project is now focusing on implementing the core family-oriented features.

## Known Issues

- No known major issues at this stage, though minor refinements or edge case handling may be needed for the completed features.

## Evolution of Project Decisions

- Initial decision to use Elixir/Phoenix with LiveView and Channels for real-time PWA development.
- Decision to integrate with a third-party LLM API for AI capabilities.
- Decision to use `mix phx.gen.auth` for the core authentication system due to its comprehensive features.
- Decision to use `mix phx.gen.live` for basic chat room management.
- Decision to refactor the application to use a `Participant` schema for handling users in chat rooms.
- Decision to use `binary_id` for primary keys in `chat_rooms` and `participants` tables and standard `id` for `messages` table.
- Decision to remove guest participant functionality to focus on registered users within a family account.
- Decision to implement an email-based invitation system for account grouping, with a dedicated registration page for invited users.
- Decision to use Phoenix.Token for secure invitation tokens and Swoosh for email delivery, using embedded HTML for the email body as a workaround for template rendering issues.
- Decision to implement explicit participant addition for chat rooms with same-account verification and update the chat room UI accordingly.
- Decision to make the `owner_id` column in the `accounts` table nullable to support accounts without a designated owner initially.
