# System Patterns

## System Architecture

The project follows a client-server architecture. The backend is built with Elixir/Phoenix, leveraging its OTP capabilities for concurrency and fault tolerance. The frontend utilizes Phoenix LiveView for dynamic and real-time user interfaces, minimizing the need for extensive client-side JavaScript. Real-time communication is handled via Phoenix Channels.

## Key Technical Decisions

- **Backend Framework:** Elixir/Phoenix for its scalability, performance, and real-time capabilities.
- **Frontend Framework:** Phoenix LiveView for server-rendered dynamic UIs and simplified real-time updates.
- **Real-time Communication:** Phoenix Channels for efficient and low-latency messaging.
- **Database:** PostgreSQL (or similar relational DB) for structured data storage.
- **AI Integration:** External LLM API integration for AI functionality.

## Design Patterns in Use

- **Phoenix Contexts:** Organizing business logic into distinct contexts.
- **Phoenix Channels:** Implementing real-time communication.
- **Phoenix LiveView:** Building interactive and real-time user interfaces.

## Component Relationships

- **Users:** Interact with the Phoenix LiveView frontend.
- **LiveView:** Communicates with the Phoenix backend and Channels. Handles user interactions and displays chat messages.
- **Phoenix Channels:** Manages real-time message broadcasting within chat rooms via a dedicated `ChatRoomSocket`.
- **Backend Contexts:** Handle user authentication, account management, chat room management, participant management, message persistence, and AI integration logic.
- **Database:** Persists user data, chat room information, participant data (linking users/guests to rooms), and message history.
- **AI API:** Provides AI responses based on user queries and chat context.

## Critical Implementation Paths

- User authentication and authorization flow.
- Participant management (creating/finding participants for registered and anonymous users).
- Real-time message delivery and display in chat rooms, linked via participants.
- AI request and response handling, including context provision.
- Guest access mechanism for chat rooms (partially addressed via anonymous participants).
