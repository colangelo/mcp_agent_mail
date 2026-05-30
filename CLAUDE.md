# MCP Agent Mail — Claude Code

Coordinated multi-agent messaging MCP server: mail-like communication, advisory file
reservations, and thread-based coordination for AI coding agents.

**[`AGENTS.md`](AGENTS.md) is the canonical, tool-neutral source of truth** and is imported
below, so it is always in context. Do **not** restate its rules here — that is how the two
files drift apart. AGENTS.md owns:

- the file-deletion and destructive-git prohibitions (RULE NUMBER 1, break-glass list);
- the uv + Python 3.14 + `pyproject.toml`-only policy;
- the `python-decouple` config pattern (`.env`, never `os.getenv`/`dotenv`);
- the SQLModel-async do/don'ts;
- the mandatory lint + typecheck gates;
- the no-`V2`-files / no-regex-codemod / no-tech-debt rules;
- the full MCP Agent Mail coordination workflow (identities, reservations, threads, macros,
  worktrees, guards, build slots, Product Bus);
- the Beads / UBS / ast-grep / cass / warp_grep tooling notes.

@AGENTS.md

---

Everything below is **fork- and Claude-Code-specific** and intentionally *not* in AGENTS.md.

## Quick commands (Justfile)

Run `just` for the full list. Most-used:

| Recipe | Action |
|--------|--------|
| `just serve` | HTTP server with bearer token (`run_server_with_token.sh`) |
| `just serve-stdio` | stdio server — used by Claude Code / CLI integration |
| `just integrate-claude` | Integrate with Claude Code only |
| `just integrate-all` | Auto-detect + integrate every installed coding agent |
| `just test` | `uv run pytest` |
| `just lint` | Ruff auto-fix — **this is the AGENTS.md lint gate** |
| `just typecheck` | `ty` check — **this is the AGENTS.md typecheck gate** |
| `just doctor` | Mailbox health diagnostics + repair |
| `just config-show` | Show resolved server config |
| `just reset` | ⚠️ DELETES all data — confirm-gated |

After any code change, run `just lint && just typecheck` (the gates AGENTS.md requires).

## Claude Code config directory

This fork's integration scripts resolve the Claude config directory in priority order — set
`CLAUDE_CONFIG_DIR` to override a relocated install:

1. `$CLAUDE_CONFIG_DIR` — if set (and, for detection, the dir exists)
2. `~/.config/claude` — current default
3. `~/.claude` — legacy fallback

Implemented in `scripts/integrate_claude_code.sh` and
`scripts/automatically_detect_all_installed_coding_agents_and_install_mcp_agent_mail_in_all.sh`.

## Project map

```
src/mcp_agent_mail/
├── app.py          # MCP tools + resources (main server logic)
├── cli.py          # Typer CLI — backs the Justfile recipes
├── config.py       # Settings via python-decouple
├── db.py           # Async SQLModel engine/session setup
├── http.py         # HTTP transport (FastAPI + Uvicorn)
├── storage.py      # Messages, threads, advisory file reservations
├── models.py       # SQLModel entities
├── guard.py        # Git pre-commit / pre-push guard
├── share.py        # Static viewer export
├── llm.py          # LLM helpers (thread summarization)
├── utils.py        # Shared helpers (agent-name validation, etc.)
└── templates/      # Jinja2 templates for the web viewer
```

Stack: Python 3.14 · uv · fastmcp · SQLModel/SQLAlchemy (aiosqlite) · FastAPI/Uvicorn ·
Typer · Rich.
