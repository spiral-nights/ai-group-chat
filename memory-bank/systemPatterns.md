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

- **Users:** Interact with the Phoenix LiveView frontend. Registered users belong to an account. Each account has one owner user.
- **Accounts:** Represent family groups.
- **Invitations:** Facilitate inviting users to accounts via email.
- **LiveView:** Communicates with the Phoenix backend and Channels. Handles user interactions and displays chat messages, tasks, and calendar events, and manages the invitation acceptance flow and adding participants to chat rooms.
- **Phoenix Channels:** Manages real-time message broadcasting within chat rooms via a dedicated `ChatRoomSocket`.
- **Backend Contexts:** Handle user authentication, account management (creation, ownership), invitation management (creation, retrieval, deletion), chat room management (creation, participant addition), participant management (linking registered users to rooms), message persistence, task management, calendar event management, and AI integration logic.
- **Database:** Persists user data, account information (including owner), invitation data, chat room information, participant data (linking registered users to rooms), message history, task data, and calendar event data.
- **AI API:** Provides AI responses based on user queries and chat context, specifically for task and calendar actions.

## Critical Implementation Paths

- User authentication and authorization flow.
- Account creation and ownership assignment.
- Invitation creation and email delivery.
- Invitation acceptance flow for both authenticated and unauthenticated users.
- Associating users with accounts.
- Chat room creation and automatically adding the creator as a participant.
- Adding users to chat rooms with account verification.
- Participant management (creating/finding participants for registered users).
- Real-time message delivery and display in chat rooms, linked via participants.
- Task assignment and management within an account.
- Shared calendar event creation and management within an account.
- AI request and response handling for task and calendar actions, including context provision.
