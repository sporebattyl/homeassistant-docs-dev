# Repository Guidelines

## Project Structure & Module Organization
- Top-level `configuration.yaml` only hosts core includes, toggles, and `!secret` references; feature bundles live under `packages/` (e.g., `packages/climate_*`).  
- Automations reside in `automations/` with topic-based filenames. Each automation must declare `id`, Title Case `alias`, and concise `description`.  
- Custom integrations belong in `custom_components/`; `custom_components/hass-mcp/` is the active MCP app. Place experiments under `packages/*.disabled` instead of deleting them.  
- Reference docs or decision logs in `docs/`, lab notes in `development/`, and disposable safety configs in `test/`.

## Build, Test, and Development Commands
- `ha core check` — validate YAML before committing; locally, `hass --script check_config --config .` mirrors this.  
- `ha core restart` — restart Home Assistant only after a clean check.  
- Inside `custom_components/hass-mcp/`: `uv sync` refreshes pinned deps, `uv run pytest` runs the suite, and `uv run pytest tests/test_server.py -k ping` is the quick health check.  
- Tail logs via `tail -f logs/home-assistant.log` or `tail -f tools/dashboard-audit/logs/*` while testing new flows.

## Coding Style & Naming Conventions
- YAML uses two-space indents, lowercase snake_case IDs, and Title Case aliases. Comment sparingly to clarify non-obvious logic.  
- Python follows four-space indents, type hints, sorted imports, and async patterns seen in `custom_components/hass-mcp/app/`. Keep coroutines single-responsibility.  
- Jinja templates in `templates/` should apply explicit filters and avoid hidden constants.

## Testing Guidelines
- Mirror production scenarios inside `test/` to keep `check_config` deterministic.  
- Name unit tests `test_<feature>.py`, mark async paths with `@pytest.mark.asyncio`, and cover both success paths and guard rails (e.g., watchdog automations).  
- Gate PRs on a clean `ha core check` plus passing pytest run; capture command output for PR notes.

## Commit & Pull Request Guidelines
- Write imperative commit subjects similar to “Stabilize climate dashboard fallback”; keep each commit scoped to one concern.  
- PR descriptions should list affected domains, link issues, paste `ha core check`/`pytest` snippets, and include UI screenshots for Lovelace changes.  
- Conclude PRs with concise “Deployment Notes” outlining restart steps or token rotations.

## Security & Configuration Tips
- Never store credentials in repo; reference them via `!secret` entries in `secrets.yaml`.  
- Rotate long-lived tokens noted in `development/influxdb-deployment/*.sh` and scrub sensitive log lines before sharing.  
- Treat archives in `backups/` as confidential artifacts and handle accordingly.
