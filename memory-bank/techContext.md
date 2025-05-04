# Technical Context

## Technologies Used

- **Backend:** Elixir, Phoenix Framework, OTP
- **Frontend:** Phoenix LiveView, HTML, Tailwind CSS, JavaScript (minimal)
- **Database:** PostgreSQL
- **Real-time:** Phoenix Channels
- **AI Integration:** Third-party LLM API (e.g., OpenAI, Google Gemini, Anthropic Claude)
- **Styling:** Tailwind CSS

## Development Setup

- Elixir and Erlang installation.
- Phoenix Framework installation.
- PostgreSQL database setup.
- Node.js and npm/yarn for frontend asset management (Tailwind CSS, etc.).
- Environment configuration for database connection and AI API keys.

## Technical Constraints

- Reliance on external LLM API for AI functionality.
- Potential limitations of guest access without full authentication.
- Real-time performance dependent on server resources and network conditions.

## Dependencies

- Elixir and Phoenix dependencies managed with Mix.
- Frontend dependencies managed with npm/yarn.
- Database driver (e.g., Postgrex).
- HTTP client for AI API communication.

## Tool Usage Patterns

- Using Mix for build, dependency management, and running the application.
- Using `iex -S mix phx.server` for running the development server.
- Using database migration tools (e.g., Ecto).
- Using frontend build tools (e.g., Webpack, esbuild) for processing assets.
