# Active Context

## Current Work Focus

Implementing local storage-based identification for guest participants to prevent duplicate participant records.

## Recent Changes

- Modified `assets/js/app.js` to:
    - Remove cookie handling.
    - Push a "guest-id-event" after mount, including the guest_id from local storage (if any).
    - Handle the "store-guest-id" event to save the guest_id to local storage.
- Modified `lib/ai_group_chat_web/live/chat_room_live/show.ex` to:
    - Remove participant creation/lookup logic from the `mount` function.
    - Add a `handle_event` for "guest-id-event" to handle participant lookup/creation based on the guest_id from local storage or the logged-in user.
    - Generate a new guest_id using `create_guest_id` if no guest_id is found.
- Removed the `lib/ai_group_chat_web/plugs/extract_guest_cookies.ex` file.
- Removed the `ExtractGuestCookies` plug from the router in `lib/ai_group_chat_web/router.ex`.

## Next Steps

- Begin implementing the Account Grouping/Invite System.
- Refine the Guest Access mechanism, particularly the anonymous user display name handling (currently uses a slice of the guest_id).
- Implement the AI Participant Integration (public and private interaction).
- Continue implementing other core features as outlined in the MVP section of the project brief.

## Active Decisions and Considerations

- Utilizing Elixir/Phoenix with LiveView and Channels for real-time PWA development.
- Using a `Participant` schema to handle both registered and anonymous users in chat rooms.
- Implementing local storage-based identification for guest users to maintain their participant record across sessions.
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
- Local storage-based identification provides a way to persist guest identity across sessions without requiring registration, and avoids the need for a plug.
- Pushing events from the LiveView to the client is a good way to trigger client-side storage updates.
