# Progress

## What Works

- The basic Elixir/Phoenix project structure is in place.
- Core memory bank files have been initialized and updated with project details.
- Basic User Authentication & Account Management setup using `phx.gen.auth` is complete, including user registration, email confirmation (via dev mailbox), and login/logout.
- Basic Chat Room Management setup using `phx.gen.live` is complete, including schema, context, and LiveViews for listing/creating/managing rooms (accessible to authenticated users).
- Real-time text chat functionality within chat rooms using Phoenix Channels is implemented, supporting both registered and anonymous users.
- The application has been refactored to use a `Participant` schema for handling users in chat rooms.

## What's Left to Build

- Account Grouping/Invite System.
- Guest Access mechanism for chat rooms.
- AI Participant Integration (public and private interaction).
- PWA Functionality (manifest file, service worker).

## Current Status

The foundational authentication and basic chat room management systems are set up and verified. Real-time text chat functionality has been implemented and refactored to use a `Participant` schema for handling both registered and anonymous users.

## Known Issues

- No known issues at this stage.

## Evolution of Project Decisions

- Initial decision to use Elixir/Phoenix with LiveView and Channels for real-time PWA development.
- Decision to integrate with a third-party LLM API for AI capabilities.
- Decision to use `mix phx.gen.auth` for the core authentication system due to its comprehensive features.
- Decision to use `mix phx.gen.live` for basic chat room management.
- Decision to refactor the application to use a `Participant` schema for handling both registered and anonymous users.
- Decision to use `binary_id` for primary keys in `chat_rooms` and `participants` tables and standard `id` for `messages` table.
