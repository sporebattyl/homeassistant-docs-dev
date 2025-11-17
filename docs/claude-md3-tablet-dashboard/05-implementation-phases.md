# Implementation Phases - MD3 Tablet Dashboard

**Last Updated**: 2025-11-11 (REVISED - Installation Status Verified)
**Status**: Ready to Begin with Week 1 Material Symbols Installation

---

## Overview

This document provides the week-by-week implementation roadmap for the MD3 Tablet Dashboard project. Most HACS components are installed, but Material Symbols (CRITICAL) must be installed in Week 1 before proceeding with dashboard configuration.

---

## Timeline

**Estimated Duration**: 4 weeks (Nov 11 - Dec 9, 2025)
**Rationale**: Configuration, testing, and refinement require full 4-week timeline despite some components pre-installed

**Verified Installation Status** (2025-11-11):
- ✅ Material You Theme (installed in `/themes/material_you/`)
- ❌ Material Symbols (**MUST INSTALL WEEK 1** - CRITICAL)
- ✅ Lovelace Material Components (installed)
- ✅ Paper Buttons Row (installed)
- ❌ Scene Presets (install Week 3)

---

## Phase 1: Foundation & Overview Page

**Duration**: Week 1 (Nov 11-17, 2025)
**Priority**: 🔴 Critical
**Deliverable**: Functional Overview page with weather, climate summary, emergency controls

### Tasks

#### Task 1.1: Install Material Symbols (CRITICAL)
**Estimated Time**: 30 minutes

**Pre-Task Validation** (run BEFORE starting):
```bash
# If HACS components were just installed, sync from live server first
# (see CLAUDE.md Rule 3: HACS Install Immediate Sync Protocol)
bash scripts/ha-sync-from-live.sh

# NOTE: All file checks below assume git repo working directory
# (/home/drewcifer/homeassistant-config/)
# NEVER check /mnt/homeassistant-config/ (see CLAUDE.md Rule 1)

# Verify Material You theme exists
ls -la themes/material_you/ 2>/dev/null || echo "❌ Material You theme not found - install via HACS first"

# Verify HACS components installed
ls -la www/community/lovelace-card-mod/ 2>/dev/null || echo "❌ card-mod not installed"
ls -la www/community/mushroom/ 2>/dev/null || echo "❌ Mushroom not installed"
ls -la www/community/decluttering-card/ 2>/dev/null || echo "❌ Decluttering Card not installed"
ls -la www/community/material-symbols/ 2>/dev/null || echo "❌ Material Symbols not installed"

# If any missing → STOP, install via HACS first
```

**Fail-Fast**: If prerequisites missing, STOP and document what's needed. DO NOT proceed with implementation.

**Steps**:
1. HACS > Frontend > Custom repositories
2. Add: `https://github.com/basbruss/material-symbols`
3. Category: Lovelace
4. Download and install
5. Add resource to configuration

**Incremental Testing** (after each step):
- Step 2: Verify theme file exists: `ls -la themes/material_you/`
- Step 3: Count HACS components: `ls www/community/ | wc -l` (should be ≥5)
- Step 6: Verify entities exist in HA before proceeding

**Post-Task Validation**:
```bash
# Validate configuration
ha-validate  # ✅ Must pass before commit

# Git commit (use template from Task 1.2)
git add <files>
git commit -m "Task 1.1: [description]

CHANGES:
- [bullet list]

VALIDATION:
- ha-validate passed
- Theme appears in dropdown
- [other tests]

FILES MODIFIED:
- [list files]

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Verify deployment (post-commit hook auto-deploys)
cat .last-deployment  # Check deployment log
# DO NOT read /mnt/ files to verify (see CLAUDE.md Rule 1)

# Test theme accessibility (verify via browser, not filesystem)
# 1. Restart HA (if needed - hook logs will indicate)
# 2. Go to User Profile → Theme dropdown
# 3. Verify Material You theme appears
# 4. Select theme
# 5. Verify colors apply
```

**Rollback**: If validation fails, see Task 1.2 rollback procedure

**Files Modified**:
- HACS installation (via UI)
- `ui-lovelace-tablet-md3.yaml` (will add resource in Task 1.2)

#### Task 1.2: Create Dashboard Base Structure
**Estimated Time**: 2 hours

**⚠️ CRITICAL**: Dashboard must be registered in configuration.yaml or Home Assistant won't recognize it

**Steps**:
1. Create new dashboard file: `ui-lovelace-tablet-md3.yaml` in config root directory

2. **Register dashboard in `configuration.yaml`** (⚠️ REQUIRED):
```yaml
lovelace:
  mode: storage  # Keep existing dashboards in storage mode
  dashboards:
    tablet-md3:  # This becomes the URL path: /tablet-md3/0
      mode: yaml
      title: "MD3 Tablet Dashboard"
      filename: ui-lovelace-tablet-md3.yaml
      show_in_sidebar: false  # Hide from sidebar (tablet-only)
      icon: mdi:tablet-dashboard
```

3. Configure lovelace resources at TOP of `ui-lovelace-tablet-md3.yaml` (⚠️ ORDER MATTERS):
```yaml
resources:
  # 1. Material You Theme (MUST BE FIRST)
  - url: /hacsfiles/themes/material-you-theme/material-you-theme.js
    type: module
  # 2. Material Symbols (MUST BE SECOND - other components depend on it)
  - url: /hacsfiles/material-symbols/material-symbols.js
    type: module
  # 3. Lovelace Material Components
  - url: /hacsfiles/lovelace-material-components/lovelace-material-components.js
    type: module
  # 4. Other components
  - url: /hacsfiles/paper-buttons-row/paper-buttons-row.js
    type: module
```

4. Set up navbar with 10 view tabs
5. Define global decluttering templates

**Validation**:
- Dashboard accessible at `http://192.168.88.125:8123/tablet-md3/0`
- Dashboard loads without errors in browser console
- Navbar displays 10 tabs (Home, Living, Master, Rowan, Office, Guest, Security, Calendar, System, Scenes)
- Material Symbols icons render correctly (`m3o:` prefix works)
- Resources load in correct order (check browser console)

**Files Modified**:
- `configuration.yaml` (⚠️ ADD lovelace dashboards registration - required)
- `ui-lovelace-tablet-md3.yaml` (new file)

**Post-Task Validation**:
```bash
ha-validate  # ✅ Run validation before restart
# Then restart Home Assistant to load dashboard
```

**Git Commit** (after ALL validation passes):

```bash
# Ensure validation passed
ha-validate  # ✅ Must show "Configuration valid"

# Stage files modified in this task
git add dashboards/ui-lovelace-tablet-md3.yaml
git add configuration.yaml

# Commit with descriptive message
git commit -m "Task 1.2: Create MD3 dashboard base structure

CHANGES:
- Register tablet-md3 dashboard in configuration.yaml
- Create ui-lovelace-tablet-md3.yaml with navbar
- Configure lovelace resources (Material Symbols, Material You, etc.)
- Add decluttering templates section (4 templates defined)

VALIDATION:
- ha-validate passed
- Dashboard accessible at /tablet-md3/0
- Navbar displays 10 tabs
- Material Symbols icons render
- No browser console errors

FILES MODIFIED:
- configuration.yaml (lovelace dashboards registration)
- dashboards/ui-lovelace-tablet-md3.yaml (new file, 150 lines)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Post-commit hook automatically:
# 1. Deploys git repo → /mnt/homeassistant-config/
# 2. Validates HA config via API
# 3. Logs deployment to .last-deployment
# 4. Outputs "Configuration validated successfully" or error

# Check post-commit hook output for deployment status
# If "Configuration validated successfully" → ✅ Deployed
# If "FAILED" → ❌ Fix issues, amend commit, re-deploy
```

**Rollback Procedure** (if deployment fails):
```bash
# Revert last commit
git revert HEAD

# Post-commit hook auto-deploys rollback
# Check .last-deployment for confirmation

# Fix issues in working directory
# Re-attempt task implementation
# Commit again when fixed
```

**Template Note**: This commit format should be used for ALL tasks:
- Descriptive first line: "Task X.Y: [Brief description]"
- CHANGES section: Bullet list of what was modified
- VALIDATION section: What was tested and passed
- FILES MODIFIED section: List files and approximate line counts
- Standard footer: Claude Code attribution

#### Task 1.3: Configure Material You Theme
**Estimated Time**: 2 hours

**Pre-Task Validation**:
```bash
# Verify Material You theme file exists
ls -la themes/material_you/*.yaml || echo "❌ Material You theme not found"

# Verify we can read the theme
grep -c "primary-color" themes/material_you/*.yaml || echo "❌ Theme file unreadable"

# If missing → STOP, complete Task 1.1 first
```

**Fail-Fast**: DO NOT proceed if Material You theme doesn't exist

**Steps**:
1. Locate Material You theme file: `themes/material_you/*.yaml`
2. Copy ENTIRE Material You theme YAML content
3. Create new file: `themes/md3_climate_material_you.yaml`
4. Paste copied content into new file
5. Modify climate-specific variables (climate-success-color, climate-warning-color, climate-error-color)
6. Modify transparency settings (card-background-color: 0.85 opacity)
7. Reference theme in `configuration.yaml` if not auto-detected
8. Restart Home Assistant
9. Select theme in user profile
10. Test color picker functionality

**IMPORTANT**: Do NOT use `extends:` or `base:` keywords - Home Assistant themes do not support inheritance. You must copy and modify.

**Incremental Testing**:
- Step 4: Count lines in new file: `wc -l themes/md3_climate_material_you.yaml` (should be >500)
- Step 5: Verify climate color variables exist: `grep climate-success-color themes/md3_climate_material_you.yaml`
- Step 6: Verify transparency: `grep "card-background-color.*0.85" themes/md3_climate_material_you.yaml`

**Post-Task Validation**:
```bash
ha-validate  # ✅ Must pass

# Git commit
git add themes/md3_climate_material_you.yaml
git commit -m "Task 1.3: Configure Material You Theme

CHANGES:
- Create md3_climate_material_you.yaml
- Add climate-specific color variables
- Set 85% card transparency
- Configure Material You color picker

VALIDATION:
- ha-validate passed
- Theme selectable in UI
- Transparency visible
- Color picker functional

FILES MODIFIED:
- themes/md3_climate_material_you.yaml (new file, ~600 lines)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Verify deployment (post-commit hook auto-deploys)
cat .last-deployment  # Check deployment log
# DO NOT read /mnt/ files to verify (see CLAUDE.md Rule 1)

# Test theme in UI (verify via browser, not filesystem)
# 1. Restart HA (if needed - hook logs will indicate)
# 2. User Profile → Theme → Select "MD3 Climate Material You"
# 3. Verify transparency (cards show wallpaper behind)
# 4. Verify climate colors (check Overview page sensors)
# 5. Test color picker (change primary color, verify updates)
```

**Files Modified**:
- `themes/md3_climate_material_you.yaml` (new file, copied from material_you)
- `configuration.yaml` (add theme if needed)

#### Task 1.4: Create Decluttering Templates
**Estimated Time**: 2 hours

**Pre-Task Validation**:
```bash
# NOTE: All file checks assume git repo working directory
# (/home/drewcifer/homeassistant-config/)
# NEVER check /mnt/homeassistant-config/ (see CLAUDE.md Rule 1)

# Verify dashboard base exists
grep -q "tablet-md3" configuration.yaml || echo "❌ Dashboard not registered - complete Task 1.2 first"

# Verify dashboard file exists
ls -la dashboards/ui-lovelace-tablet-md3.yaml || echo "❌ Dashboard file not found"

# If missing → STOP, complete Task 1.2 first
```

**Fail-Fast**: DO NOT proceed if dashboard base doesn't exist

**Templates to Create**:
1. `room_summary` - Room climate card (temp + humidity + dew point)
2. `emergency_button` - Emergency script button (reuse existing template)
3. `climate_gauge` - Circular gauge for climate entities
4. `status_chip` - Status chip template for header

**Incremental Testing**:
- After each template: Add template → Refresh browser → Verify renders without errors
- Check browser console (F12) for any JavaScript errors

**Post-Task Validation**:
```bash
ha-validate  # ✅ Must pass

# Git commit
git add dashboards/ui-lovelace-tablet-md3.yaml
git commit -m "Task 1.4: Create Decluttering Templates

CHANGES:
- Add room_summary template (climate card)
- Add emergency_button template
- Add climate_gauge template (circular gauge)
- Add status_chip template (header chips)

VALIDATION:
- ha-validate passed
- All 4 templates defined
- Templates render correctly with test entities
- No browser console errors

FILES MODIFIED:
- dashboards/ui-lovelace-tablet-md3.yaml (~100 lines added)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Verify deployment
cat .last-deployment  # Check deployment log
# DO NOT read /mnt/ files to verify (see CLAUDE.md Rule 1)

# Test templates in browser
# 1. Refresh dashboard page
# 2. Check browser console (F12) for errors
# 3. Verify templates render with sample entities
```

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (decluttering_templates section)

#### Task 1.5: ~~Verify WAQI Entity IDs~~ **✅ COMPLETE - Manual REST Sensors**
**Status**: ✅ **WORKING** (implemented 2025-11-14 via manual REST sensors)

**Solution**: Bypassed broken HA integration (#133919) with `packages/waqi_manual_sensors.yaml`
- **Entity Count**: 9 sensors (Station #179: Seabrook Friendship Park, Houston, TX)
- **Primary Entity**: `sensor.waqi_seabrook_aqi` (currently 21, Good)
- **Dashboard Impact**: Air quality widgets NOW AVAILABLE for Overview and Calendar pages

**Implementation**: Direct API access via REST sensor (30min scan interval, under API limits)

**Files Modified**:
- None (documentation only, prepares for next task)

#### Task 1.6: Create Template Sensors (NEW - CRITICAL)
**Estimated Time**: 2 hours

**Purpose**: Create required template sensors before building room pages that depend on them

**⚠️ VERIFIED 2025-11-13** - Motion sensor entity IDs confirmed from live system:
- ✅ `binary_sensor.living_room_motion` - Living room (EXISTS)
- ✅ `binary_sensor.bedroom_motion` - Master bedroom (NOT master_bedroom_motion)
- ✅ `binary_sensor.presencesensor1_motion` - Office (NOT office_motion)
- ❌ `binary_sensor.dining_room_motion` - **DOES NOT EXIST**
- ❌ `binary_sensor.kitchen_motion` - **DOES NOT EXIST**
- ❌ `binary_sensor.master_bathroom_motion` - **DOES NOT EXIST**

**Template sensors below use ACTUAL entity IDs** (no verification needed)

**Sensors to Create** (in `configuration.yaml` or `templates/dashboard_helpers.yaml`):

1. **Occupancy Sensors** (3 sensors - ⚠️ CORRECTED with actual entity IDs):
```yaml
template:
  - sensor:
      - name: "Living Area Occupancy"
        unique_id: living_area_occupancy
        state: >
          {{ is_state('binary_sensor.living_room_motion', 'on') }}
        # NOTE: Only living room sensor exists (dining/kitchen motion sensors don't exist)
        icon: mdi:account-check

      - name: "Master Suite Occupancy"
        unique_id: master_suite_occupancy
        state: >
          {{ is_state('binary_sensor.bedroom_motion', 'on') }}
        # NOTE: Only bedroom sensor exists (bathroom motion sensor doesn't exist)
        # CORRECTED: bedroom_motion (NOT master_bedroom_motion)
        icon: mdi:account-check

      - name: "Office Occupancy"
        unique_id: office_occupancy
        state: "{{ is_state('binary_sensor.presencesensor1_motion', 'on') }}"
        # CORRECTED: presencesensor1_motion (NOT office_motion)
        icon: mdi:account-check
```

2. **Door/Window Count Sensors** (2 sensors):
```yaml
      - name: "Doors Open Count"
        unique_id: doors_open_count
        state: >
          {{ states.binary_sensor
             | selectattr('attributes.device_class', 'eq', 'door')
             | selectattr('state', 'eq', 'on')
             | list | count }}
        unit_of_measurement: "doors"
        icon: mdi:door-open

      - name: "Windows Open Count"
        unique_id: windows_open_count
        state: >
          {{ states.binary_sensor
             | selectattr('attributes.device_class', 'eq', 'window')
             | selectattr('state', 'eq', 'on')
             | list | count }}
        unit_of_measurement: "windows"
        icon: mdi:window-open
```

3. **Comfort Score Sensors** (2 sensors - ⚠️ CORRECTED formula with min/max clamping):
```yaml
      - name: "Living Area Comfort Score"
        unique_id: living_area_comfort_score
        state: >
          {% set temp = states('sensor.climate_living_temperature') | float(73) %}
          {% set humidity = states('sensor.climate_living_humidity') | float(50) %}
          {% set temp_deviation = (temp - 73) | abs * 5 %}
          {% set humidity_deviation = (humidity - 50) | abs * 2 %}
          {% set raw_score = 100 - temp_deviation - humidity_deviation %}
          {{ [0, [raw_score, 100] | min] | max | round(0) }}
        # CORRECTED: Added min/max clamping to keep score in 0-100 range
        unit_of_measurement: "score"
        icon: mdi:emoticon-happy-outline

      - name: "Master Comfort Score"
        unique_id: master_comfort_score
        state: >
          {% set temp = states('sensor.climate_master_temperature') | float(73) %}
          {% set humidity = states('sensor.climate_master_humidity') | float(50) %}
          {% set temp_deviation = (temp - 73) | abs * 5 %}
          {% set humidity_deviation = (humidity - 50) | abs * 2 %}
          {% set raw_score = 100 - temp_deviation - humidity_deviation %}
          {{ [0, [raw_score, 100] | min] | max | round(0) }}
        # CORRECTED: Added min/max clamping to keep score in 0-100 range
        unit_of_measurement: "score"
        icon: mdi:emoticon-happy-outline
```

**Steps**:
1. Create/edit configuration file for templates
2. Add all 7 template sensors
3. Validate YAML syntax: `ha-validate`
4. Restart Home Assistant
5. Check Developer Tools → States for all 7 new sensors
6. Verify sensors reporting correct values

**Validation**:
- All 7 sensors appear in Developer Tools → States
- Occupancy sensors toggle based on motion
- Door/window counts match actual open doors/windows
- Comfort scores calculate correctly (0-100 range)

**Files Modified**:
- `configuration.yaml` (or `templates/dashboard_helpers.yaml` if using packages)

#### Task 1.7: Build Overview Page - Weather Section
**Estimated Time**: 40 minutes (✅ WAQI available for Phase 3 integration)

**Components**:
- Clock Weather Card (`weather.forecast_home`)
- ✅ **WAQI Air Quality chips AVAILABLE** (Manual REST sensors: `sensor.waqi_seabrook_aqi`)

**Validation**:
- Weather widget displays current conditions + 5-day forecast
- Animated weather icons working
- Card styling matches MD3 theme
- ✅ WAQI air quality chips can be added in Phase 3 (entities verified working)

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (overview view)

**Post-Task Validation**:
```bash
ha-validate  # ✅ Run validation after YAML changes
```

#### Task 1.8: Build Overview Page - Climate Summary
**Estimated Time**: 2 hours

**Components**:
- Thermostat control (`climate.thermostat`)
- Average temperature/humidity sensors
- Equipment arbitration status
- Dehumidifier control

**Validation**:
- Thermostat card allows temperature adjustment
- Average sensors display whole-home climate
- Equipment status chip shows AC/dehumidifier state
- Color-coding works (green=comfortable, amber=borderline, red=alert)

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (overview view)

**Post-Task Validation**:
```bash
ha-validate  # ✅ Run validation after YAML changes
```

#### Task 1.9: Build Overview Page - Emergency Controls
**Estimated Time**: 1.5 hours (⚠️ REDUCED - removed broken script)

**⚠️ VERIFIED 2025-11-13** - Using ACTUAL script entity IDs

**Components**:
- **3 emergency script buttons** (NOT 4 - system restart removed):
  - `script.emergency_humidity_override` ✅
  - `script.emergency_cooling_boost` ✅
  - `script.emergency_rollback_all_flags` ✅ (NOT reset_all_overrides)
- Button templates with MD3 styling
- Paper Buttons Row layout

**❌ REMOVED**: `script.climate_system_restart` (doesn't exist, has known timeout issue)

**Validation**:
- All 3 buttons display in horizontal row (equally spaced at 400px each)
- Button tap triggers correct script with VERIFIED entity IDs
- Confirmation dialog appears (if configured)
- Button state changes reflect script execution
- Mobile notification sent on script activation

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (overview view)

**Post-Task Validation**:
```bash
ha-validate  # ✅ Run validation after YAML changes
```

#### Task 1.10: Build Overview Page - Status Chips & Room Navigation
**Estimated Time**: 2 hours

**Components**:
- Status chips (alarm, doors, garage, person)
- Room quick access buttons (6 rooms)
- Recent activity expander card

**Validation**:
- Status chips update in real-time
- Room navigation buttons work (navigate to respective views)
- Recent activity expands/collapses correctly

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (overview view)

### Phase 1 Milestones

**End of Week 1**:
- [ ] Dashboard base structure created
- [ ] Material You Theme configured and active
- [ ] Decluttering templates defined
- [ ] Overview page 100% functional
- [ ] All emergency controls tested
- [ ] Navigation to room pages works (even though rooms pages empty)

---

## Phase 2: Climate Room Pages

**Duration**: Week 2 (Nov 17-23, 2025)
**Priority**: 🔴 Critical
**Deliverable**: All 5 climate room pages operational with 18-sensor network

### Tasks

#### Task 2.1: Create Room Page Template Structure
**Estimated Time**: 2 hours

**Pre-Task Validation**:
```bash
# NOTE: All file checks assume git repo working directory
# (/home/drewcifer/homeassistant-config/)
# NEVER check /mnt/homeassistant-config/ (see CLAUDE.md Rule 1)

# Verify dashboard base exists
grep -q "tablet-md3" configuration.yaml || echo "❌ Dashboard not registered"
ls -la dashboards/ui-lovelace-tablet-md3.yaml || echo "❌ Dashboard file not found"

# Verify decluttering templates exist
grep -q "decluttering_templates" dashboards/ui-lovelace-tablet-md3.yaml || echo "❌ Templates not defined"

# If missing → STOP, complete previous tasks first
```

**Fail-Fast**: DO NOT proceed if prerequisites missing

**Steps**:
1. Define standard room page layout (3-column grid)
2. Create view: living (Living Area)
3. Create view: master (Master Suite)
4. Create view: rowan (Rowan's Room)
5. Create view: office (Office)
6. Create view: guest (Guest Bedroom)

**Incremental Testing**:
- After creating each view: Refresh browser → Verify navbar shows new tab
- Click tab → Verify view loads (even if empty)
- Check browser console for errors

**Post-Task Validation**:
```bash
ha-validate  # ✅ Must pass

# Git commit
git add dashboards/ui-lovelace-tablet-md3.yaml
git commit -m "Task 2.1: Create Room Page Template Structure

CHANGES:
- Define 3-column grid layout for room pages
- Create 5 room views (living, master, rowan, office, guest)
- Add placeholder content to each view

VALIDATION:
- ha-validate passed
- All 5 views exist in YAML
- Navbar displays all room tabs
- Navigation to each room works
- No browser console errors

FILES MODIFIED:
- dashboards/ui-lovelace-tablet-md3.yaml (~150 lines added)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Verify deployment
cat .last-deployment
# DO NOT read /mnt/ files (see CLAUDE.md Rule 1)

# Test in browser
# 1. Refresh dashboard
# 2. Click each room tab (living, master, rowan, office, guest)
# 3. Verify each view loads
```

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (5 new views)

#### Task 2.2: Build Living Area Page
**Estimated Time**: 3 hours

**Pre-Task Validation**:
```bash
# NOTE: All file checks assume git repo working directory
# NEVER check /mnt/homeassistant-config/ (see CLAUDE.md Rule 1)

# Verify room views exist
grep -q "path: living" dashboards/ui-lovelace-tablet-md3.yaml || echo "❌ Living view not found"

# Verify climate sensors exist (18-sensor network)
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.climate_living_temperature" | grep -q "state" || echo "❌ Living room climate sensor missing"
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.climate_dining_temperature" | grep -q "state" || echo "❌ Dining room climate sensor missing"

# If entities missing → STOP, fix climate package first
```

**Fail-Fast**: DO NOT build dashboard if required entities don't exist

**Components**:
- Room header (title, occupancy chip)
- Climate gauges (4 sensors: living, dining, kitchen1, kitchen2)
- ApexCharts graph (4-sensor temperature trends)
- Dew point display
- Lighting controls (3 light entities)
- Fan control
- Blinds control
- Media players (TV, kitchen speaker)

**Incremental Testing** (test each section as you build):
- Climate gauges: Add gauges → Refresh → Verify temperatures display
- ApexCharts: Add graph → Refresh → Verify 4 sensors plot correctly
- Lighting: Add controls → Test on/off → Test brightness slider
- Check browser console after each section

**Mid-Task Checkpoints**:
```bash
# After each major section
ha-validate
# Refresh browser → Check for errors
# If errors → FIX before continuing
```

**Post-Task Validation**:
```bash
ha-validate  # ✅ Must pass

# Git commit
git add dashboards/ui-lovelace-tablet-md3.yaml
git commit -m "Task 2.2: Build Living Area Page

CHANGES:
- Add room header with occupancy chip
- Add 4 climate gauges (living, dining, kitchen1, kitchen2)
- Add ApexCharts 4-sensor temperature trend graph
- Add dew point display
- Add lighting controls (3 entities)
- Add fan control + blinds + media players

VALIDATION:
- ha-validate passed
- All 4 climate sensors display correctly
- ApexCharts shows comfort zone shading
- Light controls functional
- Fan speed control works
- No browser console errors

FILES MODIFIED:
- dashboards/ui-lovelace-tablet-md3.yaml (~200 lines added)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Verify deployment
cat .last-deployment

# Test in browser
# 1. Navigate to Living Area page
# 2. Verify all 4 sensors display temperatures
# 3. Test emergency button (tap → notification received)
# 4. Test light controls (on/off + brightness)
# 5. Check browser console (no errors)
```

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (living view)

#### Task 2.3: Build Master Suite Page
**Estimated Time**: 2 hours

**Pre-Task Validation**:
```bash
# Verify master view exists
grep -q "path: master" dashboards/ui-lovelace-tablet-md3.yaml || echo "❌ Master view not found"

# Verify master bedroom climate sensors exist
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.climate_master_temperature" | grep -q "state" || echo "❌ Master bedroom sensor missing"

# If entities missing → STOP
```

**Fail-Fast**: DO NOT proceed if prerequisites missing

**Components**:
- Room header (title, occupancy)
- Climate gauges (3 sensors: bedroom, bathroom, closet)
- ApexCharts graph (3-sensor trends)
- Dew point display
- Lighting controls (4 light entities: bedroom, bathroom, closet)
- Blinds control
- Thermostat secondary control (bedroom-specific setpoints)
- Media player (master TV)

**Incremental Testing**:
- Climate gauges: Add → Refresh → Verify 3 sensors display
- Lighting: Test each area (bedroom, bathroom, closet)
- Check browser console

**Post-Task Validation**:
```bash
ha-validate  # ✅ Must pass

# Git commit
git add dashboards/ui-lovelace-tablet-md3.yaml
git commit -m "Task 2.3: Build Master Suite Page

CHANGES:
- Add master suite header with occupancy
- Add 3 climate gauges (bedroom, bathroom, closet)
- Add ApexCharts 3-sensor trend graph
- Add lighting controls for 3 areas
- Add thermostat secondary control
- Add blinds + media player

VALIDATION:
- ha-validate passed
- All 3 climate sensors operational
- Lighting controls functional for all areas
- Thermostat shows bedroom temp prominently
- No browser console errors

FILES MODIFIED:
- dashboards/ui-lovelace-tablet-md3.yaml (~150 lines added)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Verify deployment
cat .last-deployment

# Test in browser
# 1. Navigate to Master Suite page
# 2. Verify all 3 sensors display
# 3. Test lighting controls for each area
```

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (master view)

#### Task 2.4: Build Rowan's Room Page
**Estimated Time**: 1 hour

**Pre-Task Validation**:
```bash
# Verify rowan view exists
grep -q "path: rowan" dashboards/ui-lovelace-tablet-md3.yaml || echo "❌ Rowan view not found"

# Verify Rowan's room climate sensor exists
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.climate_rowan_temperature" | grep -q "state" || echo "❌ Rowan's room sensor missing"

# If entities missing → STOP
```

**Fail-Fast**: DO NOT proceed if prerequisites missing

**Components**:
- Room header (title, occupancy)
- Climate gauges (1 sensor: Rowan's room)
- Mini-graph-card (single sensor trend)
- Dew point display
- Lighting control (1 light entity)

**Incremental Testing**:
- Climate gauge: Add → Refresh → Verify temperature displays
- Lighting: Test on/off control
- Check page load time (<1 second)

**Post-Task Validation**:
```bash
ha-validate  # ✅ Must pass

# Git commit
git add dashboards/ui-lovelace-tablet-md3.yaml
git commit -m "Task 2.4: Build Rowan's Room Page

CHANGES:
- Add Rowan's room header with occupancy
- Add climate gauge (single sensor)
- Add mini-graph-card for temperature trend
- Add dew point display
- Add lighting control

VALIDATION:
- ha-validate passed
- Climate sensor displays correctly
- Lighting control functional
- Page loads quickly (<1 second)
- No browser console errors

FILES MODIFIED:
- dashboards/ui-lovelace-tablet-md3.yaml (~80 lines added)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Verify deployment
cat .last-deployment

# Test in browser
# 1. Navigate to Rowan's Room page
# 2. Verify sensor displays
# 3. Test lighting control
```

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (rowan view)

#### Task 2.5: Build Office Page
**Estimated Time**: 2 hours

**Pre-Task Validation**:
```bash
# Verify office view exists
grep -q "path: office" dashboards/ui-lovelace-tablet-md3.yaml || echo "❌ Office view not found"

# Verify office climate sensor exists
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.climate_office_temperature" | grep -q "state" || echo "❌ Office sensor missing"

# If entities missing → STOP
```

**Fail-Fast**: DO NOT proceed if prerequisites missing

**Components**:
- Room header (title, occupancy)
- Climate gauges (1 sensor: office)
- Mini-graph-card (single sensor trend)
- Dew point display
- Lighting control (1 light entity)
- Fan control (office fan)
- Blinds control
- Media player (office media)

**Incremental Testing**:
- Climate gauge: Add → Refresh → Verify temperature displays
- Fan: Test speed control (low/medium/high)
- Media player: Test controls when powered on
- Check browser console

**Post-Task Validation**:
```bash
ha-validate  # ✅ Must pass

# Git commit
git add dashboards/ui-lovelace-tablet-md3.yaml
git commit -m "Task 2.5: Build Office Page

CHANGES:
- Add office header with occupancy
- Add climate gauge (office sensor)
- Add mini-graph-card for temperature trend
- Add dew point display
- Add lighting + fan + blinds controls
- Add media player

VALIDATION:
- ha-validate passed
- Climate sensor operational
- Fan speed control works
- Media player controls functional
- No browser console errors

FILES MODIFIED:
- dashboards/ui-lovelace-tablet-md3.yaml (~120 lines added)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Verify deployment
cat .last-deployment

# Test in browser
# 1. Navigate to Office page
# 2. Verify sensor displays
# 3. Test fan speed control
# 4. Test media player controls
```

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (office view)

#### Task 2.6: Build Guest Bedroom Page
**Estimated Time**: 1.5 hours

**Components**:
- Room header (title)
- Climate gauges (2 sensors: guest bed, guest bath)
- Mini-graph-card (2-sensor trends)
- Dew point display
- Lighting controls (2 light entities)

**Validation**:
- Both climate sensors display
- Lighting controls functional

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (guest view)

#### Task 2.7: Implement 18-Sensor Network Visualizations
**Estimated Time**: 2 hours

**Components**:
- ApexCharts configurations for all room pages
- Comfort zone shading (71-75°F green band)
- 4-hour time span with 5-minute aggregation
- Color-coded sensor lines

**Validation**:
- All ApexCharts cards render without errors
- 4-hour historical data displays
- Comfort zone shading visible
- Graph performance acceptable (<2s load time)

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (all room views)

### Phase 2 Milestones

**End of Week 2**:
- [ ] All 5 climate room pages complete
- [ ] 18-sensor network displaying on respective room pages
- [ ] Lighting, fan, blinds, media controls functional
- [ ] Dew point displays on all room pages
- [ ] ApexCharts performance optimized

---

## Phase 3: Secondary Views (Security, Calendar, Scenes)

**Duration**: Week 3 (Nov 24-30, 2025)
**Priority**: 🟡 High
**Deliverable**: Cameras & Security, Calendar & Planning, Scenes views functional

### Tasks

#### Task 3.1: Build Cameras & Security Page - Alarm Integration
**Estimated Time**: 2 hours

**Pre-Task Validation**:
```bash
# NOTE: All file checks assume git repo working directory
# NEVER check /mnt/homeassistant-config/ (see CLAUDE.md Rule 1)

# Verify security view exists
grep -q "path: security" dashboards/ui-lovelace-tablet-md3.yaml || echo "❌ Security view not found"

# Verify alarm entity exists
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/alarm_control_panel.home_alarm" | grep -q "state" || echo "❌ Alarm entity missing"

# If entities missing → STOP, check Envisalink integration
```

**Fail-Fast**: DO NOT proceed if alarm entity doesn't exist

**Components**:
- Mushroom Alarm Control Panel Card (Envisalink)
- Alarm zone status display (6 zones)
- Arm Home / Arm Away / Disarm buttons

**Incremental Testing**:
- Alarm card: Add → Refresh → Verify alarm state displays
- Arm Home: Test button → Verify state changes to "armed_home"
- Zone status: Check zone sensors update in real-time
- Check browser console

**Post-Task Validation**:
```bash
ha-validate  # ✅ Must pass

# Git commit
git add dashboards/ui-lovelace-tablet-md3.yaml
git commit -m "Task 3.1: Build Cameras & Security - Alarm Integration

CHANGES:
- Add Mushroom Alarm Control Panel (Envisalink)
- Add alarm zone status display (6 zones)
- Add Arm Home/Away/Disarm buttons

VALIDATION:
- ha-validate passed
- Alarm card connects to home_alarm entity
- Arm/disarm functions work
- Zone status updates in real-time
- Color-coding correct (green/red/orange)
- No browser console errors

FILES MODIFIED:
- dashboards/ui-lovelace-tablet-md3.yaml (~80 lines added)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Verify deployment
cat .last-deployment

# Test in browser
# 1. Navigate to Security page
# 2. Test Arm Home button (enter code)
# 3. Verify zone statuses update
# 4. Test Disarm button
```

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (security view)

#### Task 3.2: Build Cameras & Security Page - Camera Grid
**Estimated Time**: 2 hours

**Pre-Task Validation**:
```bash
# Verify camera entities exist
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/camera.side_yard_fluent" | grep -q "state" || echo "❌ Side yard camera missing"
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/camera.driveway_fluent_lens_0" | grep -q "state" || echo "❌ Driveway camera missing"

# Count total cameras (should be 9)
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states" | grep -c '"entity_id":"camera\.' || echo "0 cameras found"

# If cameras missing → STOP, check camera integrations (Reolink + Thingino)
```

**Fail-Fast**: DO NOT proceed if camera entities don't exist

**Components**:
- Grid layout with 9 camera feeds (3×3 grid, all visible)
- LLM Vision Card for AI event descriptions (optional)

**Camera Entities** (9 total):
```yaml
# Reolink Cameras (5)
- camera.side_yard_fluent
- camera.driveway_fluent_lens_0
- camera.driveway_fluent_lens_1
- camera.front_yard_fluent
- camera.rowan_room_fluent

# Thingino Cameras (4)
- camera.wyzethingino1_profile_0
- camera.wyzethingino2_profile_0
- camera.wyzethingino3_profile_0
- camera.wyzethingino4_profile_0
```

**Camera Loading Strategy**:
- **Always-loaded**: All 9 cameras with default refresh (10-30s)
- **Memory**: 72MB (0.88% of 8GB RAM) - trivial load
- **Network**: 0.9 MB/s (7% of Wi-Fi bandwidth) - no concerns
- **No conditional loading needed**: Hardware easily handles 9 cameras

**Incremental Testing**:
- Add first row (3 cameras) → Refresh → Verify all 3 display
- Add second row (3 cameras) → Refresh → Verify grid layout correct
- Add third row (3 cameras) → Verify 3×3 grid complete
- Check memory usage and page load time
- Check browser console

**Post-Task Validation**:
```bash
ha-validate  # ✅ Must pass

# Git commit
git add dashboards/ui-lovelace-tablet-md3.yaml
git commit -m "Task 3.2: Build Cameras & Security - Camera Grid

CHANGES:
- Add 3×3 camera grid (9 cameras total)
- Configure 5 Reolink cameras
- Configure 4 Thingino cameras
- Add LLM Vision Card for AI event descriptions

VALIDATION:
- ha-validate passed
- All 9 cameras display without errors
- Camera feeds refresh automatically
- No lag when navigating to Security view
- LLM Vision generates descriptions
- Memory usage acceptable (72MB)
- No browser console errors

FILES MODIFIED:
- dashboards/ui-lovelace-tablet-md3.yaml (~150 lines added)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Verify deployment
cat .last-deployment

# Test in browser
# 1. Navigate to Security page
# 2. Verify all 9 cameras display
# 3. Check camera feeds refresh
# 4. Monitor memory usage (should be ~72MB)
# 5. Test LLM Vision event descriptions
```

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (security view)

#### Task 3.3: Build Cameras & Security Page - Sensor Timeline
**Estimated Time**: 2 hours

**Pre-Task Validation**:
```bash
# Verify door/window sensors exist
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states" | grep -c 'device_class":"door"' || echo "0 door sensors found"
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states" | grep -c 'device_class":"motion"' || echo "0 motion sensors found"

# Verify auto-entities card installed
ls -la www/community/lovelace-auto-entities/ 2>/dev/null || echo "❌ Auto-entities card not installed"

# If entities or card missing → STOP
```

**Fail-Fast**: DO NOT proceed if sensors or auto-entities card missing

**Components**:
- Auto-entities door sensor list (14 doors)
- Auto-entities motion sensor activity (last 10 events)
- Timestamp display for all events

**Incremental Testing**:
- Auto-entities door list: Add → Refresh → Verify door sensors display
- Motion timeline: Add → Refresh → Verify last 10 events display
- Test sensor state changes (open door → verify updates)
- Check browser console

**Post-Task Validation**:
```bash
ha-validate  # ✅ Must pass

# Git commit
git add dashboards/ui-lovelace-tablet-md3.yaml
git commit -m "Task 3.3: Build Cameras & Security - Sensor Timeline

CHANGES:
- Add auto-entities door sensor list (14 doors)
- Add auto-entities motion sensor timeline (last 10 events)
- Add timestamp display for all events
- Configure real-time sensor updates

VALIDATION:
- ha-validate passed
- Door sensors display current state (Open/Closed)
- Motion activity timeline updates
- Last 10 events sorted by most recent
- State changes update in real-time
- No browser console errors

FILES MODIFIED:
- dashboards/ui-lovelace-tablet-md3.yaml (~100 lines added)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Verify deployment
cat .last-deployment

# Test in browser
# 1. Navigate to Security page
# 2. Verify door sensor list displays
# 3. Open a door → Verify state updates
# 4. Check motion timeline (last 10 events)
```

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (security view)

#### Task 3.4: Build Calendar & Planning Page
**Estimated Time**: 3 hours

**Components**:
- Week Planner Card (7-day view, 6 calendars)
- Calendar Card Pro (month view)
- Weather forecast integration
- ✅ **WAQI air quality AVAILABLE** (Manual REST sensors ready for integration)

**Validation**:
- Week Planner displays all 6 calendar entities
- Calendar Card Pro shows current + next month
- Events color-coded by calendar
- Weather forecast displays above Week Planner
- ✅ WAQI air quality chips can be added (`sensor.waqi_seabrook_aqi`, `sensor.waqi_seabrook_pm2_5`)

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (calendar view)

#### Task 3.5: Build Scenes Page - Scene Presets
**Estimated Time**: 2 hours

**Components**:
- Scene Presets card (Hue-style grid)
- 5+ lighting scenes (movie time, dinner mode, bedtime, good morning, away mode)
- Scene category filters (All, Living Area, Master, Whole Home)

**Validation**:
- Scene Presets card displays scene thumbnails
- Tap to activate scene works
- Scenes execute correctly (lights adjust to preset)
- Active lights display below scene grid

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (scenes view)
- `scenes.yaml` or equivalent (create 5+ scenes)

#### Task 3.6: Create Lighting Scenes (Zigbee2MQTT/Z-Wave)
**Estimated Time**: 2 hours

**Scenes to Create**:
1. Movie Time - Living area dim with accent lighting
2. Dinner Mode - Dining room warm lighting
3. Bedtime - All lights off except night lights
4. Good Morning - Gradual wake-up lighting (if automation supported)
5. Away Mode - Security lighting pattern

**Validation**:
- All 5 scenes created as HA scene entities
- Scenes activate Zigbee2MQTT/Z-Wave lights correctly
- Scene Presets card detects new scenes

**Files Modified**:
- `scenes.yaml` (new file or append to existing)

### Phase 3 Milestones

**End of Week 3**:
- [ ] Cameras & Security page complete with Envisalink integration
- [ ] 9 cameras displaying in 3×3 grid
- [ ] Calendar & Planning page with Week Planner (WAQI available via manual REST sensors)
- [ ] Scenes page functional with 5+ lighting scenes
- [ ] All secondary views accessible via navbar

---

## Phase 4: System View & Refinement

**Duration**: Week 4 (Dec 1-8, 2025)
**Priority**: 🟢 Medium
**Deliverable**: System monitoring view, tablet kiosk mode, performance optimization, documentation

### Tasks

#### Task 4.1: Build System View - Garage Controls
**Estimated Time**: 1 hour

**Pre-Task Validation**:
```bash
# NOTE: All file checks assume git repo working directory
# NEVER check /mnt/homeassistant-config/ (see CLAUDE.md Rule 1)

# Verify system view exists
grep -q "path: system" dashboards/ui-lovelace-tablet-md3.yaml || echo "❌ System view not found"

# Verify garage entities exist
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/cover.garage_door_1" | grep -q "state" || echo "❌ Garage door 1 missing"
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.climate_foyergarage_temperature" | grep -q "state" || echo "❌ Garage climate sensor missing"

# If entities missing → STOP, check garage integrations
```

**Fail-Fast**: DO NOT proceed if garage entities don't exist

**Components**:
- 2 garage door cover cards
- Garage camera feed
- Garage climate sensors (foyer garage temp/humidity)

**Incremental Testing**:
- Garage door cards: Add → Test open/close → Verify state changes
- Camera feed: Add → Refresh → Verify garage interior displays
- Climate sensors: Add → Verify temperature/humidity display
- Check browser console

**Post-Task Validation**:
```bash
ha-validate  # ✅ Must pass

# Git commit
git add dashboards/ui-lovelace-tablet-md3.yaml
git commit -m "Task 4.1: Build System View - Garage Controls

CHANGES:
- Add 2 garage door cover cards
- Add garage camera feed
- Add garage climate sensors (foyer garage temp/humidity)

VALIDATION:
- ha-validate passed
- Garage door controls open/close both doors
- Camera feed displays garage interior
- Climate sensors update correctly
- No browser console errors

FILES MODIFIED:
- dashboards/ui-lovelace-tablet-md3.yaml (~80 lines added)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Verify deployment
cat .last-deployment

# Test in browser
# 1. Navigate to System page
# 2. Test garage door open button (CAUTION: actual door will open!)
# 3. Verify camera feed displays
# 4. Verify climate sensors display
```

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (system view)

#### Task 4.2: Build System View - Utility Climate
**Estimated Time**: 1 hour

**Pre-Task Validation**:
```bash
# Verify utility room climate sensors exist
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.climate_laundry_temperature" | grep -q "state" || echo "❌ Laundry sensor missing"
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.climate_halfbath_temperature" | grep -q "state" || echo "❌ Half bath sensor missing"
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.climate_foyerfront_temperature" | grep -q "state" || echo "❌ Foyer front sensor missing"

# If entities missing → STOP, check 18-sensor network
```

**Fail-Fast**: DO NOT proceed if utility sensors don't exist

**Components**:
- Laundry room sensors
- Half bathroom sensors
- Foyer (front) sensors
- HVAC return/supply sensors

**Incremental Testing**:
- Laundry sensors: Add → Refresh → Verify display
- Half bath sensors: Add → Refresh → Verify display
- Foyer sensors: Add → Refresh → Verify display
- HVAC return/supply: Verify delta calculation correct
- Check browser console

**Post-Task Validation**:
```bash
ha-validate  # ✅ Must pass

# Git commit
git add dashboards/ui-lovelace-tablet-md3.yaml
git commit -m "Task 4.2: Build System View - Utility Climate

CHANGES:
- Add laundry room sensors
- Add half bathroom sensors
- Add foyer (front) sensors
- Add HVAC return/supply sensors with delta

VALIDATION:
- ha-validate passed
- All utility room sensors display correctly
- HVAC system sensors show return vs supply delta
- Temperature/humidity readings accurate
- No browser console errors

FILES MODIFIED:
- dashboards/ui-lovelace-tablet-md3.yaml (~100 lines added)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Verify deployment
cat .last-deployment

# Test in browser
# 1. Navigate to System page
# 2. Verify all utility room sensors display
# 3. Check HVAC delta calculation
```

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (system view)

#### Task 4.3: Build System View - Performance Monitoring
**Estimated Time**: 2 hours

**Pre-Task Validation**:
```bash
# Verify System Monitor sensors exist
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.processor_use" | grep -q "state" || echo "❌ CPU sensor missing"
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.memory_use_percent" | grep -q "state" || echo "❌ Memory sensor missing"
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.disk_use_percent" | grep -q "state" || echo "❌ Disk sensor missing"

# Verify System Monitor integration enabled
grep -q "system_monitor" configuration.yaml || grep -q "system_monitor" packages/*.yaml || echo "❌ System Monitor not configured"

# If sensors missing → STOP, enable System Monitor integration
```

**Fail-Fast**: DO NOT proceed if System Monitor sensors don't exist

**Components**:
- CPU, Memory, Disk usage gauges
- Database size monitor
- Network speed (speedtest download/upload)
- Home Assistant uptime
- Entity count, automation count

**Incremental Testing**:
- CPU/Memory/Disk gauges: Add → Refresh → Verify metrics display
- Database size: Verify calculation correct
- Network speed: Trigger speedtest → Verify results display
- Uptime: Verify format correct (days/hours/minutes)
- Check browser console
- Monitor page load time and responsiveness

**Post-Task Validation**:
```bash
ha-validate  # ✅ Must pass

# Git commit
git add dashboards/ui-lovelace-tablet-md3.yaml
git commit -m "Task 4.3: Build System View - Performance Monitoring

CHANGES:
- Add CPU/Memory/Disk usage gauges
- Add database size monitor
- Add network speed (speedtest download/upload)
- Add Home Assistant uptime display
- Add entity count and automation count

VALIDATION:
- ha-validate passed
- All performance metrics display correctly
- Gauges update in real-time
- Performance acceptable on tablet
- Page loads <2 seconds
- No browser console errors

FILES MODIFIED:
- dashboards/ui-lovelace-tablet-md3.yaml (~150 lines added)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Verify deployment
cat .last-deployment

# Test in browser
# 1. Navigate to System page
# 2. Verify all performance gauges display
# 3. Trigger speedtest (if available)
# 4. Monitor page responsiveness on tablet
# 5. Check page load time (<2 seconds)
```

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (system view)

#### Task 4.4: Build System View - Notifications Center
**Estimated Time**: 2 hours

**Components**:
- Expander card with last 24h climate alerts
- System health warnings
- ✅ **Weather warnings from WAQI AVAILABLE** (AQI threshold automations possible with manual REST sensors)

**Validation**:
- Recent alerts display with timestamps
- Expander collapses/expands smoothly

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (system view)

#### Task 4.5: Configure Tablet Kiosk Mode
**Estimated Time**: 2 hours

**Steps**:
1. Configure Kiosk Mode HACS component
2. Hide sidebar, header for tablet user
3. Set dashboard as default on tablet
4. Configure auto-refresh settings
5. Set screensaver timeout (prevent burn-in)

**Validation**:
- Dashboard loads in kiosk mode (no sidebar/header)
- Tablet auto-loads dashboard on boot
- Screensaver activates after 10 minutes idle

**Files Modified**:
- Kiosk Mode configuration (user-specific settings)

#### Task 4.6: Performance Optimization
**Estimated Time**: 3 hours

**Optimization Tasks**:
1. Conditional camera loading (only load when view active)
2. ApexCharts lazy loading (defer data fetch until view entry)
3. Auto-entities filters optimized (limit results)
4. Media player conditional visibility (only show if powered on)
5. Reduce update frequency for low-priority sensors

**Validation**:
- Overview page loads in <2 seconds
- Camera view loads in <3 seconds (9 cameras)
- No lag when navigating between views
- Tablet remains responsive after 24 hours uptime

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (all views with optimizations)

#### Task 4.7: Mobile Responsive Testing
**Estimated Time**: 2 hours

**Testing Scenarios**:
1. Tablet portrait mode (if user rotates tablet)
2. Phone view (fallback gracefully)
3. Desktop browser (full resolution)

**Validation**:
- All views readable in different orientations
- No horizontal scrolling required
- Touch targets ≥48×48px (accessibility)

**Files Modified**:
- `ui-lovelace-tablet-md3.yaml` (responsive CSS if needed)

#### Task 4.8: Documentation Handoff
**Estimated Time**: 2 hours

**Documentation Tasks**:
1. Update `00-project-overview.md` with final status
2. Create session handoff document (temp/sessions/)
3. Document any deviations from plan
4. Create user guide for family members (optional)

**Files Created**:
- `temp/sessions/md3-tablet-dashboard-handoff-2025-12-08.md`

### Phase 4 Milestones

**End of Week 4**:
- [ ] System view complete with all monitoring features
- [ ] Kiosk mode configured for wall-mounted tablet
- [ ] Performance optimized (<2s page loads)
- [ ] Documentation complete
- [ ] Project ready for production use

---

## Risk Mitigation Checkpoints

### Weekly Reviews

**End of Each Week**:
1. Test all completed views on actual tablet (not just desktop browser)
2. Verify performance metrics (page load times)
3. Check for errors in HA logs related to dashboard
4. Get user feedback on usability
5. Adjust following week's tasks based on blockers

### Rollback Plan

**If Critical Issues Arise**:
1. Keep `gulf-coast-climate-optimized.yaml` as fallback dashboard
2. Document issue in session notes
3. Revert to working state
4. Investigate issue in isolation
5. Re-attempt implementation with fixes

---

## Success Criteria Validation

### Phase 1 Success
- ✅ Overview page loads in <2 seconds
- ✅ Emergency controls accessible within 2 taps
- ✅ Material You color picker functional

### Phase 2 Success
- ✅ All 5 climate room pages operational
- ✅ 18/18 climate sensors displaying
- ✅ ApexCharts graphs render in <2 seconds

### Phase 3 Success
- ✅ Envisalink alarm controllable via Mushroom card
- ✅ 11 cameras displaying without errors
- ✅ Week Planner showing all 6 calendars
- ✅ 5+ lighting scenes functional

### Phase 4 Success
- ✅ Tablet kiosk mode configured
- ✅ All views perform well on tablet hardware
- ✅ Family prefers MD3 dashboard over previous

---

## Implementation Log (Living Document)

**2025-11-10**: All HACS components installed (Material You Theme, Material Symbols, Lovelace Material Components, Paper Buttons Row, Scene Presets)

### Week 1 Log (Nov 11-17)
- [ ] Date: ___ - Dashboard base created
- [ ] Date: ___ - Material You Theme configured
- [ ] Date: ___ - Decluttering templates created
- [ ] Date: ___ - Overview page complete

### Week 2 Log (Nov 17-23)
- [ ] Date: ___ - Living Area page complete
- [ ] Date: ___ - Master Suite page complete
- [ ] Date: ___ - Rowan's Room page complete
- [ ] Date: ___ - Office page complete
- [ ] Date: ___ - Guest Bedroom page complete

### Week 3 Log (Nov 24-30)
- [ ] Date: ___ - Cameras & Security page complete
- [ ] Date: ___ - Calendar & Planning page complete
- [ ] Date: ___ - Scenes page complete

### Week 4 Log (Dec 1-8)
- [ ] Date: ___ - System view complete
- [ ] Date: ___ - Kiosk mode configured
- [ ] Date: ___ - Performance optimized
- [ ] Date: ___ - Project handoff complete

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2025-11-10 | Initial implementation phases documentation | Claude |
| 1.1 | 2025-11-10 | Updated to reflect all HACS components already installed | Claude |

---

## Related Documents

- `00-project-overview.md` - Project scope and goals
- `01-component-requirements.md` - Component installation status (all complete)
- `03-view-architecture.md` - Detailed view layouts
- `04-customization-strategy.md` - Styling and templates
- `06-tablet-configuration.md` - Kiosk mode and performance tuning

---

**Next Steps**: Begin Phase 1, Task 1.1 - Create dashboard base structure (`ui-lovelace-tablet-md3.yaml`)
