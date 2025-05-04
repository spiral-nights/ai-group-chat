# Active Context

## Current Work Focus

Implementing real-time text chat functionality within chat rooms using Phoenix Channels and refactoring the application to use a `Participant` schema for handling both registered and anonymous users.

## Recent Changes

- Implemented real-time text chat functionality within chat rooms using Phoenix Channels.
- Refactored the application to use a `Participant` schema to represent users in chat rooms, allowing for both registered and anonymous users.
- Created a new `Participant` schema and migration.
- Modified the `Message` schema and migration to reference `Participant` instead of `User`.
- Updated the `Chat` context to include functions for managing participants and messages.
- Updated the `ChatRoomLive.Show` LiveView to handle participant creation and message display.
- Corrected data type inconsistencies in migrations and schemas (using `binary_id` and `id`).

## Next Steps

- Begin implementing the Account Grouping/Invite System.
- Refine the Guest Access mechanism, particularly the anonymous user identification and display name handling.
- Implement the AI Participant Integration (public and private interaction).
- Continue implementing other core features as outlined in the MVP section of the project brief.

## Active Decisions and Considerations

- Utilizing Elixir/Phoenix with LiveView and Channels for real-time PWA development.
- Using a `Participant` schema to handle both registered and anonymous users in chat rooms.
- Generating a random identifier for anonymous users' display names.
- Using `binary_id` for primary keys in `chat_rooms` and `participants` tables and standard `id` for `messages` table.

## Important Patterns and Preferences

- Following Elixir/Phoenix conventions and best practices.
- Prioritizing real-time performance and scalability.
- Ensuring routes requiring authentication are properly protected.
- Using a consistent approach for handling data types (UUIDs/binary_ids) in schemas and migrations.

## Learnings and Project Insights

- Using a `Participant` schema simplifies handling both registered and anonymous users in chat rooms.
- Careful attention to data types and foreign key relationships is crucial for database integrity.
- It's important to consider the order of migrations to avoid dependency issues.
- Generating a random identifier provides a simple way to identify anonymous users.
