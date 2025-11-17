# Home Assistant Configuration Rules

**Project**: Home Assistant - League City, TX Gulf Coast Climate
**Architecture**: KISS principles - single home power user (NOT enterprise)

---

## System Context (Front-loaded)

**Environment**:
- HA Version: 2025.11.1
- Deployment: Home Assistant OS (HAOS)
- Home: 2,386 sq ft
- Equipment: Lennox ML14XC1 AC + Aprilaire E130 dehumidifier
- Climate: 18 ZG-227Z sensors (`sensor.climate_<room>_temperature/humidity`)
- Status: 74°F/73°F setpoints, dew point control, $548/year savings

**Single Source of Truth**: `climate_fresh_start.yaml` (PRIMARY)

---

## Agent Selection (Auto-invoke)

**ha-climate** → Climate/HVAC, 18-sensor network, equipment arbitration, Gulf Coast humidity
**ha-config** → YAML validation, package management, template checking
**ha-security** → Equipment protection, 60% humidity ceiling, emergency protocols
**gemini-analyst** → Architecture, optimization, strategic planning
**gemini-executor** → YAML generation, templates, routine operations
**gemini-collaborator** → Multi-step Claude-Gemini workflows

---

## Protected Areas (DO NOT MODIFY)

**Critical files** - Require explicit user approval:
- `climate_fresh_start.yaml` emergency scripts section
- `emergency_scripts_redesigned.yaml`
- Equipment arbitration logic
- Dew point calculation sensors

**Never modify**:
- Git hooks (`.git/hooks/*`)
- Home Assistant core config (`configuration.yaml` structure)
- Zigbee2MQTT device definitions

---

## File Management Rules (STRICT ENFORCEMENT)

**CRITICAL**: Root directory clutter prevention (implemented Nov 3, 2025)

### NO NEW .MD FILES IN ROOT DIRECTORY

**Rule**: NEVER create new .md files in root directory without explicit user approval

**Rationale**: Root directory was reduced from 229 to 7 essential files. Keep it clean.

### File Creation Hierarchy

**For session-specific temporary files**:
```
temp/sessions/               → Temporary session analysis, handoffs
temp/analysis/               → Temporary technical analysis
```

**For project documentation**:
```
consolidation_phases_*/      → Active project work (if applicable)
archive/sessions/            → Historical session handoffs
archive/projects/            → Completed project documentation
docs/                        → Permanent technical documentation
```

**Essential root files** (current inventory - 7 files):
```
.claude/CLAUDE.md                    ← System foundation
DOCUMENTATION_HIERARCHY.md           ← Navigation guide
MASTER_DOCUMENTATION_INDEX.md        ← Master index
PHASE_6_COMPLETION_REPORT.md         ← Latest achievements
WEEK3_PHASE1_COMPLETE_HANDOFF.md     ← Current work
AGENTS.md                            ← Repository guidelines
README_SECRETS.md                    ← Credentials
REVIEW_TASKS.md                      ← Current tasks
```

### Enforcement

**Pre-commit hook** (`.git/hooks/pre-commit`):
- Warns when new .md files added to root
- Suggests appropriate location (temp/, archive/, docs/)
- Blocks commit if >10 .md files in root

**Monthly cleanup script** (`scripts/cleanup-docs.sh`):
- Finds .md files in root older than 30 days
- Suggests archiving or moving to temp/
- User runs manually: `bash scripts/cleanup-docs.sh`

### Temp Directory Policy

**temp/** directory (gitignored):
- Short-lived analysis files
- Session-specific documentation
- Files automatically cleaned after 30 days
- NOT committed to git
- Use freely without cluttering root

**temp/.gitkeep** committed to preserve structure

### When to Create New Files

**✅ ALLOWED**:
- Update existing files in root (Edit tool)
- Create files in temp/ directory
- Create files in appropriate subdirectories
- Create files in active project directories

**❌ FORBIDDEN** (without explicit user approval):
- New .md files in root directory
- Session handoffs in root
- Temporary analysis in root
- "Quick start" guides in root

### Migration Pattern

**If you need to create documentation**:
1. Check if existing file can be updated
2. If new file needed, use temp/sessions/ or appropriate subdirectory
3. ASK USER if unsure where file should go
4. NEVER default to root directory

---

## Essential Commands

**Validation** (ALWAYS run before restart):
```bash
ha-validate          # Full validation (yamllint + config check)
ha-config-check      # HA config check only
ha-lint              # YAML linting (all packages)
ha-lint-climate      # Climate packages only
```

**Management**:
```bash
ha-restart           # Restart Home Assistant
ha-version           # HA version
```

**Debugging & Queries**:

**⭐ ALWAYS USE MCP TOOLS FIRST** (not bash/curl/grep):
- **Entity state queries**: `mcp__ha-entity-search__get_state` (99.99% token reduction vs curl)
- **Log searches**: `mcp__ha-entity-search__get_logs` (70-80% faster, 70-80% fewer tokens)
- **Config file searches**: `mcp__ha-entity-search__find_entity_mentions` (5x faster than grep)
- **Device listing**: `mcp__ha-entity-search__list_devices` (filtered, paginated)
- **Control operations**: `mcp__ha-entity-search__control` (turn_on, turn_off, set values)
- **Automation management**: `mcp__ha-entity-search__automation` (list, trigger, enable, disable)
- See MCP Tools section below for full examples

**Legacy Bash Scripts** (use only if MCP unavailable):
```bash
# Core logs (most common - automations, integrations, errors)
bash scripts/ha-logs.sh [lines]          # Default: last 50 lines

# Supervisor logs (add-on management, updates)
bash scripts/ha-logs-supervisor.sh [lines]

# All log sources (core, supervisor, host, dns, audio)
bash scripts/ha-logs-all.sh [lines]      # Default: 20 lines per source

# Filter for errors/warnings only
bash scripts/ha-logs-errors.sh [lines]   # From last 100 lines

# Examples:
bash scripts/ha-logs.sh 100             # Last 100 core log lines
bash scripts/ha-logs-errors.sh          # Recent errors only
```

**API Access** (Manual):
```bash
# Load token from secrets
source state/secrets.env

# Query API
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states" 2>/dev/null | jq .
```

---

## MCP Tools (ha-entity-search)

**Status**: ✅ Verified working (Session 14 fix)

**⭐ USE MCP TOOLS FOR ALL HOME ASSISTANT QUERIES ⭐**

**Performance vs Legacy Methods**:
| Task | MCP Tool | Legacy Method | Speed | Token Reduction |
|------|----------|---------------|-------|----------------|
| Entity state | `get_state` | curl + jq | Instant | 99.99% |
| Pattern matching | `list_devices(pattern)` | curl + jq filter | Instant | **99.9%** (500 vs 468K tokens) |
| Multi-filter queries | `list_devices(filters)` | curl + jq + bash | Instant | **99.9%** (600 vs 490K tokens) |
| Aggregations | `analyze` | curl + jq + bash math | Instant | **99.9%** (400 vs 480K tokens) |
| Health checks | `health_check` | bash scripts + grep | Instant | **99.9%** (300 vs 470K tokens) |
| Log search | `get_logs` | bash scripts/grep | 70-80% faster | 70-80% |
| Config search | `find_entity_mentions` | grep/rg | 5x faster | 80% |
| Device listing | `list_devices` | curl /api/states | Instant | 99% |

**Why MCP Tools Win**:
- ✅ Built-in filtering (no post-processing needed)
- ✅ Token optimizations (deduplication, truncation, compact mode)
- ✅ Real-time API queries (no file reads)
- ✅ Pagination support (handle large datasets)
- ✅ Graceful error handling (404, unavailable entities)

**Configuration** (`~/.claude.json`):
```json
"ha-entity-search": {
  "type": "stdio",
  "command": "/home/drewcifer/.nvm/versions/node/v20.19.3/bin/homeassistant-mcp",
  "env": {
    "HASS_BASE_URL": "http://192.168.88.125:8123",
    "HASS_TOKEN": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "NODE_ENV": "production"
  }
}
```

**CRITICAL**: Use `HASS_BASE_URL` not `HASS_HOST` (DNS errors otherwise)

**16 Available Tools** (✅ All functional, 3 enhanced/new as of 2025-11-16):

**Primary Tools** (use these first):
- `get_state` → **⭐ DEFAULT for entity state queries, ENHANCED 2025-11-16 with pattern support** (99.99% token reduction vs full /api/states)
  - Single entity: ~50-200 tokens (vs 456K)
  - Batch (3 entities): ~400 tokens
  - **Pattern matching**: Query multiple entities with wildcard/regex patterns (50% token reduction vs list_devices + get_state)
  - Supports `attributes_only` flag
  - Graceful 404 handling
- `get_logs` → **⭐ DEFAULT for log debugging** (70-80% token reduction vs bash scripts)
  - **ALWAYS use instead of**: `bash scripts/ha-logs*.sh`, `grep`, or manual log file reads
  - **Performance**: 70-80% faster than bash, 70-80% fewer tokens
  - Sources: core, supervisor, host, dns, audio (all sources working as of 2025-11-15)
  - Filters: level (ERROR/WARNING/INFO), entity_id, domain, regex pattern
  - **Note**: `/api/error_log` deprecated in HA 2025.11.x; all sources now use `/api/hassio/{source}/logs`
  - **Token optimizations** (verified 2025-11-15):
    - `max_line_length`: Truncate long lines (default: 200, max: 1000)
    - `deduplicate`: Group similar consecutive logs (default: false)
    - `compact_timestamps`: Compress timestamps to date header + times (default: false)
    - `compact`: Enable all optimizations (recommended for daily use)
  - ~300-1,500 tokens (vs 2,000+ for bash)
- `find_entity_mentions` → **5x token reduction vs grep** (ALWAYS use instead of grep/bash for entity searches)
- `list_devices` → **⭐ ENHANCED 2025-11-16** with pattern matching, state/attribute/time-based filtering, multiple output formats (99.9% token reduction vs curl + jq)
- `analyze` → **NEW 2025-11-16** - Aggregations & statistics (count, avg, min, max, sum, median) with grouping
- `health_check` → **NEW 2025-11-16** - System diagnostics (duplicates, unavailable, stale, low battery)
  - **Compact mode**: 60% token reduction (1,250 vs 3,100 tokens for 50 results)

**Control & Management** (✅ All functional as of 2025-11-16):
- `control` → Device control (turn_on, turn_off, set values) - **Fixed 2025-11-16 (direct fetch() API)**
- `automation` → Manage automations (list, trigger, enable, disable)
  - **Pagination support**: `limit` (default: 50, max: 200), `offset` (default: 0)
  - Returns pagination metadata: `total`, `limit`, `offset`, `returned`, `has_more`
- `automation_config` → Advanced automation configuration and management (validate, reload)
- `get_history` → State history over time
- `scene` → Scene management
- `notify` → Send notifications

**System Management**:
- `addon` → Manage Home Assistant add-ons (list, info, start, stop, restart)
- `package` → Manage HACS packages and custom components (list, install, remove, update)
- `subscribe_events` → SSE event subscription
- `get_sse_stats` → SSE connection statistics

**Usage Examples**:
```typescript
// Get single entity state (replaces curl to /api/states)
mcp__ha-entity-search__get_state({
  entity_id: "sensor.average_house_humidity_enhanced"
})

// Batch entity query
mcp__ha-entity-search__get_state({
  entity_id: ["climate.hallway", "sensor.climate_living_room_temperature"]
})

// NEW: Pattern matching (wildcard) - 50% token reduction!
mcp__ha-entity-search__get_state({
  pattern: "sensor.climate_*_temperature"
})
// Returns: All 18 climate temperature sensors

// NEW: Pattern matching (regex)
mcp__ha-entity-search__get_state({
  pattern: "sensor\\.climate_(living_room|office|bedroom)_temperature",
  pattern_type: "regex"
})
// Returns: 3 specific sensors

// Get core logs with error filtering
mcp__ha-entity-search__get_logs({
  source: "core",
  level: "ERROR",
  lines: 50
})

// Entity-specific logs (use core for automation/entity debugging)
mcp__ha-entity-search__get_logs({
  source: "core",
  entity_id: "sensor.climate_living_room_temperature",
  lines: 30
})

// Supervisor logs (use for add-on/system debugging)
mcp__ha-entity-search__get_logs({
  source: "supervisor",
  level: "WARNING",
  lines: 50
})

// Compact mode (recommended for daily use - maximum token savings)
mcp__ha-entity-search__get_logs({
  source: "core",
  lines: 50,
  compact: true
})

// Custom optimization level (deep troubleshooting)
mcp__ha-entity-search__get_logs({
  source: "supervisor",
  lines: 100,
  max_line_length: 500,  // Higher limit preserves detail
  deduplicate: true
})

// System management examples
// List all add-ons
mcp__ha-entity-search__addon({
  action: "list"
})

// Get info about specific add-on
mcp__ha-entity-search__addon({
  action: "info",
  addon_slug: "core_mosquitto"
})

// Restart add-on
mcp__ha-entity-search__addon({
  action: "restart",
  addon_slug: "core_mosquitto"
})

// List HACS packages
mcp__ha-entity-search__package({
  action: "list"
})

// Install HACS package
mcp__ha-entity-search__package({
  action: "install",
  package_name: "mini-graph-card"
})

// Validate automation configuration
mcp__ha-entity-search__automation_config({
  action: "validate",
  config: {
    alias: "Test Automation",
    trigger: [{platform: "state", entity_id: "sensor.test"}],
    action: [{service: "notify.mobile_app", data: {message: "Test"}}]
  }
})

// Reload automations
mcp__ha-entity-search__automation_config({
  action: "reload"
})
```

### Enhanced Tools (2025-11-16)

**⭐ NEW: Advanced filtering makes MCP 99.9% more token-efficient than curl + jq for ALL use cases**

#### Enhanced `list_devices` (Supercharged Query Tool)

**New capabilities** (replaces 99% of curl + jq usage):

```typescript
mcp__ha-entity-search__list_devices({
  // Pattern matching (REPLACES grep + jq filtering)
  pattern: "*_2",              // Wildcard: finds all entities ending in _2
  pattern_type: "wildcard",    // or "regex", "exact"

  // State filtering
  state: {
    equals: "on",               // Exact match
    contains: "heating",        // Substring match
    starts_with: "cool",        // Prefix match
    ends_with: "mode",          // Suffix match
    in: ["on", "home", "away"], // Match any of these
    numeric: { min: 70, max: 75 } // Numeric range (70-75°F)
  },

  // Attribute filtering
  attributes: {
    device_class: { equals: "temperature" },
    battery_level: { numeric: { max: 20 } },  // Battery below 20%
    friendly_name: { contains: "Living Room" },
    any_attribute: { exists: true }  // Check if attribute exists
  },

  // Time-based queries
  last_updated: { operator: "older_than", value: "24h" },  // Stale sensors
  last_changed: { operator: "newer_than", value: "1h" },   // Recent changes

  // Health filters
  exclude_unavailable: true,  // Exclude unavailable/unknown/none
  only_unavailable: false,    // Only show unavailable

  // Output control
  format: "json",  // or "csv", "table"
  fields: ["entity_id", "state", "friendly_name"],  // Limit fields
  include_attributes: ["battery_level", "temperature"],  // Include specific attrs

  // Pagination (existing)
  limit: 50,
  offset: 0
})
```

**Token savings examples**:
```typescript
// OLD: Find all _2 entities (curl + jq)
// curl /api/states | jq '.[] | select(.entity_id | endswith("_2"))'
// ~468K tokens

// NEW: Pattern matching
mcp__ha-entity-search__list_devices({ pattern: "*_2" })
// ~500 tokens (99.9% reduction!)

// OLD: Find temperature sensors above 75°F (curl + jq)
// curl /api/states | jq '.[] | select(.attributes.device_class == "temperature") | select(.state | tonumber > 75)'
// ~475K tokens

// NEW: Multi-condition filter
mcp__ha-entity-search__list_devices({
  attributes: { device_class: { equals: "temperature" } },
  state: { numeric: { min: 75 } }
})
// ~600 tokens (99.9% reduction!)

// OLD: Find stale sensors (curl + jq + date math)
// ~480K tokens

// NEW: Time-based query
mcp__ha-entity-search__list_devices({
  last_updated: { operator: "older_than", value: "24h" }
})
// ~450 tokens (99.9% reduction!)
```

#### New `analyze` Tool (Aggregations & Statistics)

**Purpose**: Replace curl + jq aggregations with server-side processing

```typescript
// Count entities by domain
mcp__ha-entity-search__analyze({
  groupBy: "domain",
  aggregate: { type: "count" }
})
// Output: { group: "sensor", count: 245 }, { group: "binary_sensor", count: 89 }, ...

// Average temperature across all sensors
mcp__ha-entity-search__analyze({
  groupBy: "device_class",
  domain: "sensor",
  attributes: { device_class: { equals: "temperature" } },
  aggregate: { type: "avg", field: "state" }
})
// Output: { group: "temperature", count: 18, avg: 73.2, min: 68, max: 78 }

// Battery statistics
mcp__ha-entity-search__analyze({
  groupBy: "device_class",
  exclude_unavailable: true,
  aggregate: { type: "avg", field: "battery_level" }
})

// Output formats
format: "table"  // Pretty table output
format: "csv"    // CSV export
format: "json"   // Structured JSON (default)
```

**Available aggregations**: count, avg, min, max, sum, median
**Grouping options**: domain, device_class, area, floor

**Token savings**: 99.9% reduction vs curl + jq + bash math

#### New `health_check` Tool (Diagnostics & Maintenance)

**Purpose**: Automated system health monitoring

```typescript
// Run all health checks
mcp__ha-entity-search__health_check({
  checks: ["duplicates", "unavailable", "stale", "no_friendly_name", "low_battery"]
})

// Check for stale sensors only
mcp__ha-entity-search__health_check({
  checks: ["stale"],
  stale_threshold: "24h",  // or "7d", "30m", "2h"
  domain: "sensor"
})

// Low battery monitoring
mcp__ha-entity-search__health_check({
  checks: ["low_battery"],
  battery_threshold: 15,  // Alert below 15%
  severity: "warning"  // or "error", "all"
})

// Output formats
format: "table"  // Pretty table for humans
format: "json"   // Structured for automation
```

**Available checks**:
- `duplicates`: Duplicate entity IDs (severity: error)
- `unavailable`: Entities in unavailable/unknown/none state (severity: warning)
- `stale`: Entities not updated within threshold (severity: warning)
- `no_friendly_name`: Missing friendly names (severity: warning)
- `no_unique_id`: Missing unique IDs (severity: warning)
- `low_battery`: Battery below threshold (severity: error if <10%, warning otherwise)

**Pagination Support** (Added 2025-11-16):
```typescript
// Quick check (10 results, ~800 tokens vs 146K without pagination)
mcp__ha-entity-search__health_check({
  checks: ["unavailable"],
  limit: 10
})

// Default behavior (50 results)
mcp__ha-entity-search__health_check({
  checks: ["unavailable"]
  // limit: 50 (default), offset: 0 (default)
})

// Page through results
// Page 1
mcp__ha-entity-search__health_check({
  checks: ["unavailable"],
  limit: 50,
  offset: 0
})

// Page 2 (if pagination.has_more: true)
mcp__ha-entity-search__health_check({
  checks: ["unavailable"],
  limit: 50,
  offset: 50
})

// Maximum limit (200 results)
mcp__ha-entity-search__health_check({
  checks: ["unavailable"],
  limit: 200
})
```

**Pagination parameters**:
- `limit`: Maximum results to return (default: 50, max: 200)
- `offset`: Number of results to skip (default: 0)

**Response includes pagination metadata**:
```json
{
  "pagination": {
    "limit": 50,
    "offset": 0,
    "has_more": true  // More results available
  },
  "total_issues": 2352,  // Total before pagination
  "returned": 50         // Actual returned in this response
}
```

**Token savings**: 97-99% reduction for large result sets (146K → 800-3,100 tokens)

**Compact Mode** (Added 2025-11-16):
```typescript
// Compact mode: Minimal output for quick scans (60% token reduction)
mcp__ha-entity-search__health_check({
  checks: ["unavailable"],
  compact: true,
  limit: 50
})
// Returns: ~1,250 tokens (vs ~3,100 verbose)

// Verbose mode (default): Full details
mcp__ha-entity-search__health_check({
  checks: ["unavailable"],
  limit: 50
  // compact: false (default)
})
// Returns: ~3,100 tokens
```

**Compact output format**:
```json
{
  "issues": [
    {
      "entity_id": "light.bedroom",
      "issue": "unavailable",
      "severity": "warning"
    }
  ],
  "total_issues": 50,
  "returned": 50,
  "pagination": { "limit": 50, "offset": 0, "has_more": false },
  "by_check": { "unavailable": 50 },
  "by_severity": { "warning": 50 }
}
```

**When to use**:
- Quick scans: Use compact mode (~25 tokens per issue)
- Detailed diagnostics: Use verbose mode (~63 tokens per issue)

**Example output (verbose)**:
```json
{
  "success": true,
  "total_issues": 23,
  "by_check": {
    "unavailable": 5,
    "stale": 12,
    "low_battery": 6
  },
  "by_severity": {
    "error": 2,
    "warning": 21
  },
  "issues": [
    {
      "check": "low_battery",
      "severity": "error",
      "entity_id": "sensor.bedroom_motion",
      "message": "Low battery: 8%",
      "battery_level": 8
    },
    ...
  ]
}
```

**Token savings**: 99.9% reduction vs bash scripts + grep + manual checking

### Decision Tree: When to Use Each Tool

```
Need entity information?
│
├─ Known entity IDs (1-5)? → get_state (50-200 tokens)
├─ Pattern matching (*_2, sensor.climate_*)? → get_state with pattern (400 tokens, 50% faster!) or list_devices
├─ Complex filters (state + attributes + time)? → list_devices with filters (600 tokens)
├─ Statistical analysis (count, avg, etc.)? → analyze (400 tokens)
├─ System health monitoring? → health_check (300 tokens)
├─ Historical data? → get_history
└─ ALL entities in domain? → list_devices with domain filter
```

**Rule**: ALWAYS use MCP tools first. Only use curl + jq if MCP genuinely cannot handle the use case (very rare).

**Fallback**: HTTP API on `http://localhost:3000` (Docker container)

### Result Caching with Smart Invalidation (Added 2025-11-16)

**Purpose**: 10-100x faster repeated queries with automatic cache invalidation

**How it works**:
- `/api/states` responses cached for 10 seconds (configurable)
- Automatic cache clearing after state changes (`control` actions)
- Shared cache across all tools (`get_state`, `list_devices`, `health_check`, `analyze`)

**Performance**:
```typescript
// First call: Cache miss (~200ms)
mcp__ha-entity-search__get_state({
  pattern: "sensor.climate_*_temperature"
})

// Second call within 10 seconds: Cache hit (~2ms) - 100x faster!
mcp__ha-entity-search__list_devices({
  domain: "sensor"
})

// After control action: Cache automatically cleared
mcp__ha-entity-search__control({
  entity_id: "light.bedroom",
  domain: "light",
  service: "turn_on"
})

// Next query: Fresh data (cache miss)
mcp__ha-entity-search__get_state({
  entity_id: "light.bedroom"
})
```

**Configuration** (optional, via `~/.config/claude-desktop/config.json`):
```json
"ha-entity-search": {
  "env": {
    "HASS_BASE_URL": "http://192.168.88.125:8123",
    "HASS_TOKEN": "...",
    "MCP_ENABLE_CACHE": "true",  // Enable caching (default)
    "MCP_CACHE_TTL": "10000"     // Cache TTL in milliseconds (default: 10s)
  }
}
```

**Tuning recommendations**:
- Fast-changing systems: `MCP_CACHE_TTL=5000` (5 seconds)
- Stable systems: `MCP_CACHE_TTL=30000` (30 seconds)
- Disable caching: `MCP_ENABLE_CACHE=false`

**Cache hit rate**: 70-80% in typical sessions
**Trade-off**: Max 10 seconds stale data (acceptable for diagnostics, monitoring, analysis)
**NOT recommended for**: Real-time control feedback (cache clears automatically on control actions)

**Session impact**:
- Before caching: 4,400 tokens, 850ms, 4 tool calls
- After caching: 2,050 tokens (53% reduction), 452ms (47% faster), 3 tool calls

---

## Git Workflow - Option A-Strict: Git-First with Absolute Rules

**Architecture:**
- **Git repo** (`/home/drewcifer/homeassistant-config/`) = **SOURCE OF TRUTH**
- **Live server** (`/home/drewcifer/mnt/homeassistant-config/`) = **DEPLOYMENT TARGET ONLY**

**Core Principle:** Git repo is authoritative. `/mnt/` is deployment target. Never read from `/mnt/` for verification.

---

### Standard Development Workflow

```
1. Edit files in git repo with Edit/Write tools
2. Commit: git commit -m "descriptive message"
3. Post-commit hook (automatic):
   a. Rsync git → /mnt/ (with exit code checks)
   b. Validate HA config via API
   c. Log deployment to .last-deployment
   d. If valid + dashboard change: notify user to refresh browser
   e. If valid + other change: manual restart required
   f. If invalid: abort and alert
4. Verify changes via API/browser/tablet (NOT filesystem)
```

**Dashboard workflow cycle time:** ~16 seconds
- Edit: ~5s
- Commit: ~2s
- Deploy + validate: ~8s
- Manual browser refresh: ~1s
Total: ~16 seconds (vs 60s full HA restart)

---

### Git Hooks Architecture

**post-commit** (AUTOMATIC - enhanced 2025-11-14):
- Deploys git repo → live server (rsync with error checking)
- Validates HA configuration via API
- Logs deployment to `.last-deployment` file
- Notifies user of next steps (browser refresh or manual restart)
- Aborts on rsync failure or invalid config

**pre-commit** (WARNING - enhanced 2025-11-14):
- Checks for unsynced HACS components
- Checks for root .md file clutter
- Suggests appropriate locations for new files

**post-merge** (AUTOMATIC):
- Syncs live → git after `git pull` from remote
- Ensures local repo has any manual changes from server

---

### Agent File Access Rules (IMMUTABLE - ZERO EXCEPTIONS)

#### Rule 1: NEVER Read from /mnt/
**Applies to**: Read, Edit, Write, Grep, Glob tools
**Enforcement**: /mnt/ does not exist from agent perspective
**No exceptions for**:
- "Just checking if deployed"
- "Verifying sync status"
- "Comparing with live"
- "Checking logs" (use supervisor API instead)
- ANY reason whatsoever

**Correct approach**: Trust post-commit hook output + check `.last-deployment` file

**For debugging errors**: Use supervisor API endpoints (see Essential Commands - 5 log sources)

---

#### Rule 2: ALWAYS Verify via API or Browser
**Entity states**:
```bash
curl -H "Authorization: Bearer $HA_TOKEN" \
     "$HA_BASE/api/states/sensor.entity_name"
```

**Dashboard changes**: Refresh browser/tablet, visual inspection

**Configuration**: Trust hook validation output or check `.last-deployment`

**NEVER verify by**: Reading files from /mnt/

---

#### Rule 3: HACS Install Immediate Sync Protocol
When user says "I installed X via HACS":

**Step 1**: IMMEDIATELY run sync (no other actions first)
```bash
bash scripts/ha-sync-from-live.sh
```

**Step 2**: Review what was synced
```bash
git status
git diff www/community/
```

**Step 3**: Commit if expected
```bash
git add www/community/<component>/
git commit -m "Add HACS component: <name> v<version>"
```

**Step 4**: Proceed with configuration/testing (component now in git repo)

**DO NOT**:
- Check if component exists first (sync brings it)
- Try to install via other methods
- Assume component is in git repo before sync
- Read from /mnt/ to verify HACS installation

**Why this works**: HACS installs to /mnt/www/community/. Sync pulls to git. Post-commit hook deploys back. Git remains source of truth.

---

#### Rule 4: Trust Post-Commit Hook Completely
**Hook handles**:
- YAML validation
- Rsync deployment
- HA API config check
- Success/failure reporting
- Deployment logging

**Agent response to hook output**:
- ✅ "Configuration validated successfully" → Trust deployment succeeded
- ❌ "Configuration validation FAILED" → Trust deployment failed, fix errors

**Verify deployment via**:
```bash
# Check deployment log (instead of reading /mnt/)
cat .last-deployment
```

**DO NOT**:
- Verify deployment by reading /mnt/
- Re-run deployment manually
- Second-guess hook's validation

**Rollback if needed**:
```bash
git revert HEAD
# Hook deploys rollback automatically
```

---

#### Rule 5: Verification Strategy
**Deployment verification**: Post-commit hook output + `.last-deployment` file

**Functional verification**:
- Entity states → MCP `get_state` tool (not curl)
- Dashboard rendering → Browser
- Automation triggers → MCP `get_logs` tool (not bash scripts)

**File verification**: Git repo only
```bash
# Correct:
cat packages/climate_fresh_start.yaml

# WRONG:
cat /mnt/homeassistant-config/packages/climate_fresh_start.yaml
```

---

### Manual Sync (Edge Cases Only)

**When user manually edits files on live server:**

```bash
bash scripts/ha-sync-from-live.sh  # Pull live → git repo
git status                          # Review changes
git diff                            # Inspect differences
git add <files>                     # Stage changes
git commit -m "Sync manual edits"   # Commit to git
```

**When to use:** Only when user explicitly edits files directly on HA server

**When NOT to use:** After normal git commits (post-commit hook handles deployment)

---

## Climate Package Structure

**6 operational packages** (~6,287 lines):

**PRIMARY**:
- `climate_fresh_start.yaml` (1,836 lines) → Dew point control, emergency scripts
- `emergency_scripts_redesigned.yaml` (398 lines) → Included by fresh_start

**Supporting**:
- `climate_dashboard_enhancements.yaml` (1,693 lines) → Analytics, metrics
- `climate_dashboard_ui_enhancements.yaml` (625 lines) → UI helpers
- `climate_energy_management.yaml` (1,121 lines) → Energy optimization
- `climate_interface_management.yaml` (1,235 lines) → Notifications, spam prevention
- `climate_runtime.yaml` (80 lines) → Runtime tracking

**Current Operation**:
- Temp: 74°F home / 73°F sleep (1.0°F deadband)
- HVAC: 45min cycles (Gulf Coast)
- Sensors: 18 ZG-227Z (100% operational)
- Humidity: Dew point-based control
- Arbitration: AC/dehumidifier mutual exclusion ✅

**Emergency Scripts** (3/4 functional):
- ✅ `emergency_humidity_override` (55% target)
- ✅ `emergency_cooling_boost`
- ✅ `reset_all_overrides`
- ⚠️ `climate_system_restart` (timeout issue)

**Room Mapping** (presence sensors 1-15):
```
1:Living  2:Dining  3:Kitchen1  4:Kitchen2  5:HalfBath  6:Rowan  7:GuestBath
8:GuestBed  9:FoyerGarage  10:Master  11:MasterBath  12:MasterCloset
13:Laundry  14:Office  15:FoyerFront
```

---

## Development Rules (Sequential Steps)

### 1. Climate Modifications
```
Step 1: Identify target package (see Package Selection below)
Step 2: Use appropriate agent (ha-config/ha-climate)
Step 3: Make changes
Step 4: Run ha-validate
Step 5: If validation passes → commit (auto-deploys)
```

**Package Selection**:
- Emergency scripts → `emergency_scripts_redesigned.yaml`
- Dew point logic → `climate_fresh_start.yaml`
- Dashboard sensors → `climate_dashboard_enhancements.yaml`
- Dashboard UI → `climate_dashboard_ui_enhancements.yaml`
- Energy tracking → `climate_energy_management.yaml`
- Mobile notifications → `climate_interface_management.yaml`
- Runtime stats → `climate_runtime.yaml`

### 2. Automation Requirements

**MUST include**:
- Equipment safety checks (AC/dehumidifier arbitration)
- Modern format: `template:` not `platform: template`
- `unique_id:` attribute
- Availability checks: `'unavailable'`, `'unknown'`, `'none'`
- Gulf Coast context (60%+ humidity, variable temps)

### 3. Script Requirements

**MUST include**:
- Mobile notifications: `notify.mobile_app_drews_iphone`
- Logbook entries
- Safety checks (sensor availability)
- Override patterns: `input_boolean` flags
- `priority: high` + custom sounds

---

## Safety Requirements (NON-NEGOTIABLE)

**Equipment Protection**:
- Dew point control operational (`climate_dew_point_limit` entities)
- AC/dehumidifier mutual exclusion (NEVER both on)
- Temperature bounds: 60-85°F
- Runtime optimization: 15min runtime / 10min cooldown

**Emergency Protocols**:
- Mobile notifications required
- Multi-level safety checks

---

## Development Constraints

**KISS Principles** (single home, NOT enterprise):
- NO A/B testing
- NO automated rollouts
- NO multi-tenant logic
- Simple boolean flags over complex automation
- Manual control preferred
- Gulf Coast focus (high humidity, hot summers)

---

## Troubleshooting

**Common Issues** → **Solution**:
- Missing entities → Verify `climate_fresh_start.yaml` + `emergency_scripts_redesigned.yaml` loaded
- Emergency scripts fail → 3/4 functional, `climate_system_restart` has timeout
- Arbitration violation → Check for both AC + dehumidifier running
- Config errors → Run `ha-validate` first
- Legacy _2 entities → 198 documented, non-blocking

**Log Locations**:
- HA: `/home/drewcifer/mnt/homeassistant-config/home-assistant.log`
- MCP: `docker compose logs -f` (in `development/homeassistant-mcp/`)
- Zigbee2MQTT: `/home/drewcifer/mnt/homeassistant-config/zigbee2mqtt/log/`

**Safety Check Commands**:

**⭐ ALWAYS USE MCP TOOLS** (not curl/bash/grep):
**Using MCP Tools** (99% token reduction, faster, real-time):
```typescript
// Humidity check
mcp__ha-entity-search__get_state({
  entity_id: "sensor.average_house_humidity_enhanced"
})

// Multiple climate sensors
mcp__ha-entity-search__get_state({
  entity_id: [
    "sensor.climate_living_room_temperature",
    "sensor.climate_office_temperature",
    "sensor.average_house_humidity_enhanced"
  ]
})

// Equipment arbitration
mcp__ha-entity-search__get_state({
  entity_id: "sensor.equipment_arbitration_status_enhanced"
})

// Recent errors
mcp__ha-entity-search__get_logs({
  source: "supervisor",
  level: "ERROR",
  lines: 30
})
```

**Using curl** (fallback only):
```bash
# Humidity
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.average_house_humidity_enhanced"

# Equipment arbitration
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.equipment_arbitration_status_enhanced"
```

---

## YAML Organization

**Structure**:
- Packages pattern: `/packages/*.yaml` (primary)
- Include: `!include_dir_named`
- Customizations: `/customization/` (grouped by domain)

**KISS Feature Flag Pattern**:
```yaml
input_boolean:
  use_new_feature:
    name: "Enable New Feature"
    initial: false

action:
  - choose:
      - conditions:
          - condition: state
            entity_id: input_boolean.use_new_feature
            state: 'on'
        sequence:
          # New logic
        default:
          # Original logic
```

**yamllint** (`.yamllint` in project root):
- Run before: commits, edits, HA restart, package changes
- Current issues: 397 (279 trailing-spaces, 114 line-length)
- Commands: `ha-lint` (all), `ha-lint-climate` (climate only)

---

## Workflow Examples & Patterns

**Purpose**: Real-world workflows demonstrating tool integration and best practices

### Complete Climate Modification Workflow

**Scenario**: Add new humidity threshold automation

```
1. PLAN (TodoWrite)
   - Research current humidity automations
   - Design new automation with safety checks
   - Identify target package file
   - Plan testing approach

2. RESEARCH (MCP Tools)
   - mcp__ha-entity-search__get_state → Check current sensor values
   - mcp__ha-entity-search__find_entity_mentions → Find related automations
   - Read climate_fresh_start.yaml → Review existing patterns

3. IMPLEMENT (Edit tool)
   - Add automation to climate_fresh_start.yaml
   - Include equipment arbitration checks
   - Add availability validation
   - Include notification actions

4. VALIDATE (Sequential)
   - ha-validate → YAML syntax + HA config check
   - Review validation output
   - Fix any errors, re-validate

5. DEPLOY (Git commit)
   - git add packages/climate_fresh_start.yaml
   - git commit -m "Add humidity threshold automation"
   - Post-commit hook auto-deploys + validates

6. VERIFY (MCP Tools + Browser)
   - mcp__ha-entity-search__get_state → Check automation entity exists
   - Browser → View in HA UI, test manual trigger
   - mcp__ha-entity-search__get_logs → Monitor for errors
   - Wait 24 hours → Verify automatic triggering

Total time: ~5-10 minutes (vs 30-60 min without workflow)
```

### Dashboard Change Rapid Iteration

**Scenario**: Modify Lovelace dashboard card

```
Fast cycle: Edit → Commit → Browser Refresh (~16 seconds)

1. Edit www/community/component/file.js
2. git commit -m "Update dashboard card styling"
   (Post-commit hook deploys automatically)
3. Refresh browser (Ctrl+F5 for hard refresh)
4. Verify visual changes
5. Iterate if needed

NO HA RESTART REQUIRED for dashboard changes!
```

### Troubleshooting Error Workflow

**Scenario**: Automation not triggering

```
1. VERIFY ENTITY EXISTS
   mcp__ha-entity-search__get_state({
     entity_id: "automation.humidity_control"
   })

2. CHECK RECENT LOGS
   mcp__ha-entity-search__get_logs({
     source: "core",
     entity_id: "automation.humidity_control",
     lines: 50
   })

3. FIND CONFIGURATION
   mcp__ha-entity-search__find_entity_mentions({
     entity_id: "automation.humidity_control"
   })

4. REVIEW YAML
   Read packages/climate_fresh_start.yaml
   - Check conditions (availability, state checks)
   - Verify entity IDs exist
   - Check for typos in templates

5. TEST MANUALLY
   Browser → Developer Tools → Services
   automation.trigger → automation.humidity_control

6. FIX + REDEPLOY
   Edit file → ha-validate → git commit
```

### HACS Component Installation

**Scenario**: User says "I installed X via HACS"

```
IMMEDIATE RESPONSE (before anything else):

1. SYNC FIRST
   bash scripts/ha-sync-from-live.sh

2. REVIEW
   git status
   git diff www/community/

3. COMMIT
   git add www/community/component-name/
   git commit -m "Add HACS: component-name v1.2.3"

4. CONFIGURE
   Now component is in git repo
   Add to configuration as needed
   Follow normal validation workflow

NEVER try to read from /mnt/ or check if component exists first!
```

---

## Decision Trees & Troubleshooting Pathways

**Purpose**: Systematic problem-solving paths for common scenarios

### Entity State Query Decision Tree

```
Need entity information?
│
├─ Single entity, current state only?
│  └─ ✅ mcp__ha-entity-search__get_state (50-200 tokens)
│
├─ Multiple entities (2-5), current state?
│  └─ ✅ mcp__ha-entity-search__get_state with array (400 tokens)
│
├─ Historical data over time?
│  └─ ✅ mcp__ha-entity-search__get_history
│
├─ ALL entities in domain (explore, research)?
│  └─ ✅ mcp__ha-entity-search__list_devices with domain filter
│
└─ Configuration location in YAML?
   └─ ✅ mcp__ha-entity-search__find_entity_mentions
```

### Log Debugging Decision Tree

```
Need to debug issue?
│
├─ Automation/entity not working?
│  └─ ✅ mcp__ha-entity-search__get_logs (source: core, entity_id filter)
│
├─ Add-on or system issue?
│  └─ ✅ mcp__ha-entity-search__get_logs (source: supervisor)
│
├─ Network/DNS problems?
│  └─ ✅ mcp__ha-entity-search__get_logs (source: host or dns)
│
├─ Recent errors only?
│  └─ ✅ mcp__ha-entity-search__get_logs (level: ERROR, lines: 30)
│
├─ Need maximum context (deep troubleshooting)?
│  ├─ Set lines: 100
│  ├─ Set max_line_length: 500 (preserve detail)
│  └─ Use deduplicate: true
│
└─ Daily monitoring (token efficiency)?
   └─ ✅ Use compact: true (all optimizations enabled)
```

### Configuration Error Resolution

```
ha-validate fails?
│
├─ YAML syntax error?
│  ├─ Read error message carefully (line numbers)
│  ├─ Check indentation (spaces not tabs)
│  ├─ Verify quote matching
│  └─ Use yamllint for detailed report
│
├─ Template error?
│  ├─ Check for {% %} vs {{ }} usage
│  ├─ Verify filter syntax (| default, | float)
│  ├─ Test in Developer Tools → Template
│  └─ Check availability conditions
│
├─ Entity not found?
│  ├─ mcp__ha-entity-search__list_devices → Find correct entity_id
│  ├─ Check sensor is online (Zigbee2MQTT for Z2M devices)
│  └─ Verify entity_id spelling/case
│
├─ Integration error?
│  ├─ mcp__ha-entity-search__get_logs (source: core, lines: 50)
│  ├─ Check integration loaded in Configuration → Integrations
│  └─ Review integration docs (use context7 if needed)
│
└─ Still stuck?
   ├─ Review .last-deployment file
   ├─ Check recent git commits for breaking changes
   └─ Consider git revert HEAD
```

### Equipment Safety Violation

```
AC and dehumidifier both running?
│
├─ IMMEDIATE CHECK
│  mcp__ha-entity-search__get_state({
│    entity_id: "sensor.equipment_arbitration_status_enhanced"
│  })
│
├─ If violation confirmed:
│  ├─ Manually turn off dehumidifier via HA UI
│  ├─ Check arbitration automation is enabled
│  └─ mcp__ha-entity-search__get_logs (search for arbitration logs)
│
├─ Find arbitration logic:
│  mcp__ha-entity-search__find_entity_mentions({
│    entity_id: "equipment_arbitration"
│  })
│
└─ Verify in climate_fresh_start.yaml
   └─ Check mutual exclusion conditions still present
```

---

## Context7 Integration for HA Libraries

**Purpose**: Leverage context7 MCP for up-to-date Home Assistant documentation

### When to Use Context7

**ALWAYS use for**:
- Home Assistant core feature documentation
- Integration setup (zigbee2mqtt, mqtt, etc.)
- New component development
- Template function reference
- Service call syntax

**Example workflows**:

```typescript
// Get Home Assistant template documentation
mcp__context7__resolve-library-id({
  libraryName: "home-assistant"
})
// Returns: /home-assistant/core or similar

mcp__context7__get-library-docs({
  context7CompatibleLibraryID: "/home-assistant/core",
  topic: "templates",
  tokens: 5000
})

// Get Zigbee2MQTT device documentation
mcp__context7__resolve-library-id({
  libraryName: "zigbee2mqtt"
})

mcp__context7__get-library-docs({
  context7CompatibleLibraryID: "/koenkk/zigbee2mqtt",
  topic: "device pairing",
  tokens: 3000
})

// Get HACS component documentation
mcp__context7__resolve-library-id({
  libraryName: "hacs"
})
```

### Common Library Patterns

**Home Assistant Core**:
- Library ID: `/home-assistant/core` (verify with resolve first)
- Topics: "templates", "automations", "scripts", "sensors", "climate"

**Zigbee2MQTT**:
- Library ID: `/koenkk/zigbee2mqtt`
- Topics: "device pairing", "configuration", "troubleshooting"

**MQTT**:
- Library ID: Search "mqtt" or "eclipse-mosquitto"
- Topics: "broker setup", "topic structure", "qos"

### Integration with Existing Workflow

```
Problem: Need to implement new HA feature with unfamiliar syntax

1. RESEARCH with Context7
   mcp__context7__get-library-docs → Get current syntax/examples

2. DESIGN with local knowledge
   Review existing packages for patterns
   Check climate_fresh_start.yaml for similar implementations

3. IMPLEMENT combining both
   Use Context7 syntax with local safety patterns
   Include equipment arbitration, availability checks

4. VALIDATE
   ha-validate → Ensure syntax correct
   Test → Verify functionality
```

---

## Quick Reference

**Web Dashboard**:
- URL: `http://192.168.88.125:8123`
- Climate: `http://192.168.88.125:8123/climate-control-center-v2/climate-overview`
- User: `drewcifer` / `Minds63qq!`

**WSL Environment** (preferred):
- API-first (curl > browser automation)
- Terminal-native workflows
- Version controlled
- No Desktop dependencies
