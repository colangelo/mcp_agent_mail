# MCP Agent Mail - justfile
# Run `just` to see available commands

# Default: list available recipes
default:
    @just --list

# Start the HTTP server with bearer token
serve:
    ./scripts/run_server_with_token.sh

# Start the HTTP server (no token helper)
serve-raw *ARGS:
    uv run python -m mcp_agent_mail.cli serve-http {{ARGS}}

# Start the stdio server (for CLI integration)
serve-stdio:
    uv run python -m mcp_agent_mail.cli serve-stdio

# Integrate with Claude Code only
integrate-claude *ARGS:
    ./scripts/integrate_claude_code.sh {{ARGS}}

# Auto-detect and integrate all installed coding agents
integrate-all *ARGS:
    ./scripts/automatically_detect_all_installed_coding_agents_and_install_mcp_agent_mail_in_all.sh {{ARGS}}

# Run full installation
install *ARGS:
    ./scripts/install.sh {{ARGS}}

# Run linting with auto-fix
lint:
    uv run python -m mcp_agent_mail.cli lint

# Run type checking
typecheck:
    uv run python -m mcp_agent_mail.cli typecheck

# Run tests
test *ARGS:
    uv run pytest {{ARGS}}

# List known projects
list-projects:
    uv run python -m mcp_agent_mail.cli list-projects

# Run database migrations
migrate:
    uv run python -m mcp_agent_mail.cli migrate

# Diagnose and repair mailbox health issues
doctor *ARGS:
    uv run python -m mcp_agent_mail.cli doctor {{ARGS}}

# Show mail diagnostics and routing status
mail-status:
    uv run python -m mcp_agent_mail.cli mail status

# List active file reservations for a project
reservations PROJECT:
    uv run python -m mcp_agent_mail.cli file_reservations active '{{PROJECT}}'

# List pending acks for an agent
acks PROJECT AGENT:
    uv run python -m mcp_agent_mail.cli acks pending '{{PROJECT}}' '{{AGENT}}'

# Show server config
config-show:
    uv run python -m mcp_agent_mail.cli config show

# DANGER: Reset everything (database + storage)
[confirm("This will DELETE all data. Are you sure?")]
reset:
    uv run python -m mcp_agent_mail.cli clear-and-reset-everything
