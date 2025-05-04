# Project Brief: AI-Assisted Group Chat PWA

## Project Vision

To create a seamless and intuitive Progressive Web Application (PWA) that facilitates group communication enhanced by an integrated AI participant. The platform will allow users to create accounts, invite others, set up private chat rooms, and interact with an AI assistant for information retrieval and collaborative task support within the conversation flow.

## Target Audience

- Families coordinating activities and sharing information.

- Groups of friends planning events or discussing topics.

- Small teams or study groups needing a lightweight collaboration tool with AI assistance.

- Users seeking a simple chat solution where guests can join easily without registration.

## Core Features (MVP)

- User Authentication & Account Management:

    - Secure user registration (e.g., email/password).

    - Ability to log in and manage basic profile settings.

    - Built using Elixir/Phoenix authentication mechanisms.

- Account Grouping/Invite System:

    - Primary account holders can invite other registered users (e.g., family members, close friends) to join their "group" or "account space".

    - Members within the same group share a common context (details TBD, could influence future features like shared calendars).

- Chat Room Creation & Management:

    - Authenticated users within an account group can create new chat rooms.

    - Each chat room will have a unique, shareable URL.

    - Basic ability to list and access created/joined chat rooms.

- Real-time Text Chat:

    - Leverage Phoenix Channels for real-time, low-latency text messaging within chat rooms.

    - Display messages from all participants, including the AI.

- Guest Access:

    - Users with the unique chat room URL can join the chat as guests without needing to register or log in.

    - Guests will likely need to provide a temporary display name.

- AI Participant Integration:

    - An AI entity will be present in every chat room.

    - Public AI Interaction: Users can tag or mention the AI (e.g., @AI <query>) to ask questions or request information publicly within the chat. The AI's response appears in the main chat flow.

    - Private AI Interaction: Users can send private messages/queries to the AI (e.g., using a /whisper AI <query> command or a separate input). The AI's response is shown only to the querying user (mechanism TBD - could be a temporary private overlay or separate view).

    - The AI should have access to the recent chat history (within defined limits) to provide contextually relevant responses.

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

- AI Actions & Tool Use:

    - Enable the AI to create actionable items like To-Do lists based on chat content.

    - Allow the AI to generate calendar invites (.ics files or integrate with calendar APIs).

    - Integrate web search capabilities for the AI to look up real-time information.

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
