# Project Brief: AI-Assisted Family Group Application PWA

## Project Vision

To create a seamless and intuitive Progressive Web Application (PWA) that facilitates family coordination and communication, enhanced by an integrated AI participant. The platform will allow registered family members within the same account to assign tasks, create shared calendar events, and interact with an AI assistant for task assignment and calendar event creation support.

## Target Audience

- Families coordinating activities and sharing information.

## Core Features (MVP)

- User Authentication & Account Management:
    - Secure user registration (e.g., email/password).
    - Ability to log in and manage basic profile settings.
    - Built using Elixir/Phoenix authentication mechanisms.

- Account Grouping/Invite System:
    - Primary account holders can invite other registered users (family members) to join their "account space".
    - Members within the same account share a common context.

- Chat Room Creation & Management:
    - Authenticated users within an account can create new chat rooms and are automatically added as participants.
    - Users must be added to a chat room by an existing participant within the same account.
    - Basic ability to list and access joined chat rooms.

- Real-time Text Chat:
    - Leverage Phoenix Channels for real-time, low-latency text messaging within chat rooms.
    - Display messages from all participants, including the AI.

- Task Assignment:
    - Users within an account can assign tasks to other users in the same account.
    - Ability to view assigned tasks.

- Shared Calendar:
    - Users within an account can create and view events on a shared calendar.

- AI Participant Integration:
    - An AI entity will be present in every chat room.
    - Users can interact with the AI to get assistance with assigning tasks and creating calendar events.
    - The AI should have access to the recent chat history (within defined limits) to provide contextually relevant responses for task and calendar actions.

- PWA Functionality:
    - Manifest file for installability ("Add to Home Screen").
    - Basic service worker for offline caching (e.g., caching static assets, potentially showing a basic offline page).

## Technology Stack

- Backend Framework: Elixir / Phoenix Framework
- Real-time Communication: Phoenix Channels / LiveView (preferred for seamless UI updates)
- Database: PostgreSQL (or another suitable relational database)
- Frontend: Phoenix LiveView (recommended), HTML, Tailwind CSS (for styling), JavaScript (minimal, as needed)
- AI Integration: API integration with a third-party Large Language Model (LLM) provider (e.g., OpenAI API, Google Gemini API, Anthropic Claude API).
- Deployment: Cloud hosting provider suitable for Elixir/Phoenix (e.g., Fly.io, Gigalixir, Render).

## Future Enhancements

- Rich Media Support: Allow users to upload and share images or files within chat rooms.
- Advanced AI Capabilities: Image analysis (if images are supported), document summarization.
- Notifications: Implement push notifications for new messages or mentions.
- User Profiles & Presence: More detailed user profiles, online status indicators.
- Chat Management: Moderation tools, ability to rename rooms, manage participants.
- Persistence: Longer-term storage and searchability of chat history.
- Enhanced PWA Features: More robust offline capabilities, background sync.

## Non-Functional Requirements

- Scalability: The application should be designed to handle a growing number of users and concurrent chat rooms efficiently, leveraging Elixir/OTP's strengths.
- Security: Implement standard security practices for authentication, authorization, data encryption (at rest and in transit), and protection against common web vulnerabilities. Ensure API keys for AI services are securely managed.
- Performance: Ensure low latency for real-time chat messages and responsive AI interactions. Optimize database queries and WebSocket communication.
- Reliability: Aim for high availability and fault tolerance.
- Usability: Provide a clean, intuitive, and responsive user interface that works well on desktop and mobile devices.
- Privacy: Clearly define data handling policies, especially regarding chat content provided to the AI service. Consider options for data anonymization or retention limits.
