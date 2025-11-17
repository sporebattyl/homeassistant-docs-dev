# temp/ - Shared Workspace for CLI/Web Collaboration

**Purpose**: Sync session notes, analysis, and planning between local CLI and Claude Code Web

---

## How it works

**The temp/ directory is now tracked in git**, enabling you to:

1. **Start work in Claude Code Web** → Create analysis files, session notes
2. **Commit and push** → Sync to GitHub
3. **Pull on local CLI** → Continue work with MCP tools and API access
4. **Push back to GitHub** → Share results with web environment

---

## Directory structure

```
temp/
├── sessions/           # Session handoffs and continuity notes
├── analysis/           # Technical analysis and findings
└── README.md          # This file
```

---

## Example workflows

### Workflow 1: Planning in Web → Implementation in CLI

**In Claude Code Web**:
```markdown
# temp/sessions/new-automation-plan.md

## Goal
Add dew point-based dehumidifier control

## Research needed
- Current dehumidifier entity IDs
- Existing humidity thresholds
- Dew point calculation sensors

## Implementation approach
[design notes...]
```

**Commit and push** in web

**On local CLI**:
```bash
cd /home/drewcifer/homeassistant-config
bash scripts/sync-from-docs-dev.sh

# Now you have the plan, can use MCP tools to gather entity states
mcp__ha-entity-search__get_state({
  pattern: "sensor.*dew_point*"
})

# Implement the automation with full API access
```

---

### Workflow 2: Analysis in CLI → Review in Web

**On local CLI**:
```bash
# Run analysis with MCP tools
mcp__ha-entity-search__health_check({
  checks: ["unavailable", "stale"]
})

# Save results to temp/
echo "Results..." > ../homeassistant-docs-dev/temp/analysis/entity-health-check.md

# Push to docs-dev repo
bash scripts/sync-to-docs-dev.sh
cd ../homeassistant-docs-dev
git add temp/
git commit -m "Add entity health check analysis"
git push origin main
```

**In Claude Code Web**:
- Review analysis
- Create action plan
- Document findings

---

### Workflow 3: Continuous session handoff

**Claude Code Web session ending**:
```bash
# Create handoff in temp/sessions/
# File: 2025-11-16-dashboard-refactor.md
git commit -m "Session handoff: Dashboard refactor progress"
git push
```

**Next CLI session**:
```bash
bash scripts/sync-from-docs-dev.sh
cat ../homeassistant-docs-dev/temp/sessions/2025-11-16-dashboard-refactor.md
# Continue where you left off with full MCP access
```

---

## File naming conventions

**Sessions**: `YYYY-MM-DD-description.md`
- `2025-11-16-climate-optimization.md`
- `2025-11-17-dashboard-fixes.md`

**Analysis**: `topic-type.md`
- `entity-health-check.md`
- `automation-performance-analysis.md`
- `energy-usage-findings.md`

---

## Cleanup policy

**Monthly cleanup** (optional):
- Archive completed sessions to `archive/sessions/`
- Remove outdated analysis files
- Keep active work in `temp/`

**No automatic cleanup** since this is now tracked in git. Manual cleanup recommended.

---

## Best practices

✅ **DO**:
- Use temp/ for work-in-progress collaboration
- Create clear session handoffs
- Document analysis findings
- Commit regularly

❌ **DON'T**:
- Store secrets or API tokens (use README_SECRETS.md pattern)
- Keep stale files indefinitely
- Use temp/ for permanent documentation (use docs/ instead)

---

## Git workflow

**After creating/updating temp files**:
```bash
git add temp/
git commit -m "Session: [description]"
git push origin main
```

**To pull updates**:
```bash
git pull origin main
# Or use sync scripts from main repo
```

---

This enables true collaborative development across environments! 🚀
