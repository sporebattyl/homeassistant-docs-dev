# Example Session: CLI/Web Collaboration

**Date**: 2025-11-16
**Environment**: Claude Code Web
**Status**: Example/Template

---

## What I'm working on

[Brief description of current task]

---

## Progress so far

- [x] Step 1 completed
- [x] Step 2 completed
- [ ] Step 3 in progress
- [ ] Step 4 pending

---

## What needs CLI access

These tasks require MCP tools and API access (switch to local CLI):

1. **Query entity states**:
   ```typescript
   mcp__ha-entity-search__get_state({
     pattern: "sensor.climate_*_temperature"
   })
   ```

2. **Check logs for errors**:
   ```typescript
   mcp__ha-entity-search__get_logs({
     source: "core",
     level: "ERROR",
     lines: 50
   })
   ```

3. **Validate configuration**:
   ```bash
   ha-validate
   ```

---

## What can continue in Web

These tasks don't need API access (can stay in web):

- Documentation updates
- YAML refactoring (examples)
- Architecture planning
- Code review

---

## Files to review

- `/packages-examples/climate_fresh_start.yaml`
- `/docs/climate/README.md`

---

## Next steps

1. Finish step 3 in web environment
2. Commit and push
3. Switch to CLI for steps requiring API access
4. Document results back to temp/analysis/

---

## Notes

[Any important context, gotchas, or observations]

---

**Handoff command** (local CLI):
```bash
cd /home/drewcifer/homeassistant-config
bash scripts/sync-from-docs-dev.sh
cat ../homeassistant-docs-dev/temp/sessions/2025-11-16-example-session.md
```
