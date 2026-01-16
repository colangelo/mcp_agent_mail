# MCP Agent Mail

Coordinated multi-agent messaging and coordination MCP server. Provides mail-like communication, file reservations, and thread-based messaging for AI coding agents.

## Quick Reference

```bash
just serve              # Start HTTP server with bearer token
just integrate-claude   # Integrate with Claude Code
just test               # Run tests
just lint               # Lint with auto-fix
just typecheck          # Type checking
just doctor             # Health diagnostics
```

## Tech Stack

- **Python 3.14** (only target, no backwards compatibility)
- **uv** for packaging (never pip, use `uv add` not `uv pip`)
- **fastmcp** for MCP server implementation
- **SQLModel + SQLAlchemy** async with aiosqlite
- **FastAPI + Uvicorn** for HTTP transport
- **Rich** for console output
- **Typer** for CLI

## Project Structure

```
src/mcp_agent_mail/
├── app.py          # MCP tools and resources (main server logic)
├── cli.py          # Typer CLI commands
├── config.py       # Settings via python-decouple
├── db.py           # Database setup (async SQLModel)
├── http.py         # HTTP transport layer
├── storage.py      # Storage layer (messages, reservations)
├── models.py       # SQLModel entities
├── guard.py        # Git pre-commit guard
├── share.py        # Static sharing/export
└── templates/      # Jinja2 templates for viewer
```

## Configuration

- **`.env`** - Configuration via python-decouple (never os.getenv or dotenv)
- **`CLAUDE_CONFIG_DIR`** - Override Claude Code config location (default: `~/.config/claude` or `~/.claude`)
- **`HTTP_BEARER_TOKEN`** - Auth token for HTTP transport
- **Storage**: SQLite at `storage.sqlite3`, archive in `~/.local/share/mcp-agent-mail/`

### Config Pattern (always use this)
```python
from decouple import Config as DecoupleConfig, RepositoryEnv
decouple_config = DecoupleConfig(RepositoryEnv(".env"))
VALUE = decouple_config("KEY", default="default")
```

## Development Workflow

After code changes, always run:
```bash
just lint       # ruff check --fix --unsafe-fixes
just typecheck  # uvx ty check
```

Run tests: `just test` or `uv run pytest`

## Integration Scripts

- `scripts/integrate_claude_code.sh` - Claude Code integration (respects `$CLAUDE_CONFIG_DIR`)
- `scripts/automatically_detect_all_installed_coding_agents_and_install_mcp_agent_mail_in_all.sh` - All agents
- Detection checks: `$CLAUDE_CONFIG_DIR`, `~/.config/claude`, `~/.claude` (in that order)

## Key MCP Tools

- `ensure_project` / `register_agent` - Identity management
- `send_message` / `fetch_inbox` / `acknowledge_message` - Messaging
- `file_reservation_paths` - Advisory file locks (prevents agent conflicts)
- `macro_start_session` / `macro_prepare_thread` - Common workflows

## Critical Rules

1. **Never delete files** without explicit permission
2. **Never use destructive git commands** (`git reset --hard`, `git clean -fd`, `rm -rf`)
3. **Never create "V2" or duplicate files** - always modify existing files in place
4. **Never run regex-based code transformation scripts** - make changes manually
5. **Always lint + typecheck** after code changes

## Documentation

- `AGENTS.md` - Detailed agent guidelines and rules
- `third_party_docs/PYTHON_FASTMCP_BEST_PRACTICES.md` - fastmcp best practices
- `third_party_docs/fastmcp_distilled_docs.md` - fastmcp reference
- `third_party_docs/mcp_protocol_specs.md` - MCP protocol specs

## Database Guidelines (SQLModel Async)

**Do:**
- Use `create_async_engine()` + `async_sessionmaker`
- Await all DB operations: `await session.execute()`, `await session.commit()`
- One AsyncSession per request/task
- Load relationships eagerly (`selectinload`, `joinedload`)

**Don't:**
- Share AsyncSession across concurrent tasks
- Rely on lazy loads in async code
- Mix sync drivers with async sessions
- Double-await result helpers (`.all()` is sync after execute)
