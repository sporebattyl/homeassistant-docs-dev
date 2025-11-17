# Home Assistant Documentation & Development

**Purpose**: Documentation, architecture planning, and development resources for Home Assistant configuration.

**Designed for**: Claude Code Web development (no API access required)

---

## What's in this repo

**Core Documentation**:
- `.claude/CLAUDE.md` - System rules and agent instructions
- `docs/` - Technical documentation and guides
- `DOCUMENTATION_HIERARCHY.md` - Navigation guide
- `MASTER_DOCUMENTATION_INDEX.md` - Complete index
- `AGENTS.md` - Agent selection and usage

**Development Tools**:
- `scripts/` - Validation, deployment, and utility scripts
- `packages-examples/` - Sample climate automation packages

**Planning & Analysis**:
- `temp/` - Session notes and temporary analysis (gitignored)

---

## What's NOT in this repo

**Excluded for security/size**:
- Live Home Assistant config files (`packages/`, `configuration.yaml`)
- Secrets and API tokens (use `README_SECRETS.md` as template)
- HACS components (`www/community/`)
- Large log files and databases
- Deployment tracking (`.last-deployment`)

**Access the live config**: See main repo at `github.com/sporebattyl/config`

---

## Usage with Claude Code Web

**What works** (no API access required):
- ✅ Documentation editing and restructuring
- ✅ Architecture planning and design
- ✅ YAML refactoring (examples in `packages-examples/`)
- ✅ Static linting (yamllint)
- ✅ Script development
- ✅ Template creation

**What doesn't work** (requires local environment):
- ❌ MCP tools (`mcp__ha-entity-search__*`)
- ❌ Live API testing (`ha-validate`, entity state queries)
- ❌ Deployment to live server
- ❌ Real-time log analysis

---

## Sync workflow

**After making changes in Claude Code Web**:
```bash
# On your local machine
cd /home/drewcifer/homeassistant-config
bash scripts/sync-from-docs-dev.sh
```

This pulls changes from the docs-dev repo into your main config repo.

**To push local changes to docs-dev repo**:
```bash
# On your local machine
cd /home/drewcifer/homeassistant-config
bash scripts/sync-to-docs-dev.sh
```

---

## Quick Start

**1. Clone this repo in Claude Code Web**:
```
github.com/sporebattyl/homeassistant-docs-dev
```

**2. Review documentation**:
- Start with `.claude/CLAUDE.md` for system rules
- Check `DOCUMENTATION_HIERARCHY.md` for navigation
- Review `packages-examples/` for YAML patterns

**3. Make changes**:
- Edit documentation
- Plan new features
- Refactor YAML examples
- Design architecture

**4. Commit and push**:
```bash
git commit -m "Descriptive message"
git push origin main
```

**5. Sync to local** (on your local machine):
```bash
bash scripts/sync-from-docs-dev.sh
```

---

## Recommended Claude Code Web workflows

**Documentation work** (high value for free tokens):
- Restructure and improve CLAUDE.md
- Create workflow guides and decision trees
- Document architecture and design patterns
- Update troubleshooting guides

**Planning and design**:
- Design new automation features
- Plan YAML refactoring projects
- Create template libraries
- Architecture diagrams and specs

**YAML development**:
- Edit example packages in `packages-examples/`
- Create reusable templates
- Refactor for modernization
- Static validation with yamllint

**Gemini collaboration**:
- Use `mcp__gemini-cli__chat` for deep analysis
- Architecture reviews and recommendations
- Code optimization suggestions

---

## Repository structure

```
homeassistant-docs-dev/
├── .claude/
│   └── CLAUDE.md              # System rules and instructions
├── docs/                       # Technical documentation
├── scripts/                    # Development and utility scripts
├── packages-examples/          # Sample automation packages
│   ├── climate_fresh_start.yaml
│   ├── climate_dashboard_enhancements.yaml
│   └── climate_energy_management.yaml
├── temp/                       # Session work (gitignored)
│   ├── sessions/
│   └── analysis/
├── DOCUMENTATION_HIERARCHY.md  # Navigation guide
├── MASTER_DOCUMENTATION_INDEX.md
├── AGENTS.md
├── README_SECRETS.md           # Credential template
└── README.md                   # This file
```

---

## Links

- **Main config repo**: https://github.com/sporebattyl/config
- **Home Assistant**: http://192.168.88.125:8123 (local network only)
- **Claude Code**: https://code.claude.com

---

## License

Personal configuration - not licensed for public use.
