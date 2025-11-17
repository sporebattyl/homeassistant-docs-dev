# EXTREME CRITIQUE: MD3 Tablet Dashboard Plan
**Status**: CRITICAL REVIEW - DO NOT START IMPLEMENTATION
**Date**: 2025-11-13
**Reviewer**: Claude Sonnet 4.5 (Deep Analysis)

---

## VERDICT

**Plan Quality**: 8/10 (Comprehensive, well-documented)
**One-Shot Readiness**: 4/10 (Multiple blocking gaps)

**Recommendation**: **EXECUTE PHASE 0 VERIFICATION BEFORE ANY IMPLEMENTATION**

---

## Executive Summary

The 7-document planning suite (6,800+ lines) is exceptionally thorough for UNDERSTANDING the project, but insufficient for EXECUTING it without iteration loops. The plan contains **40+ critical gaps** that will extend the planned 4-week timeline to 6-8 weeks.

**Root Cause**: The plan mixed PLANNING tasks (research, verification, decisions) into IMPLEMENTATION tasks (building, configuring, deploying).

**Solution**: Add Phase 0 verification layer to answer all "assumed", "verify", and "test" items BEFORE Week 1 begins.

---

## SHOWSTOPPERS (Must Fix Before ANY Implementation)

### 1. ~~WAQI Integration Status Contradiction~~ ✅ **RESOLVED** (2025-11-14)

**Original Problem**:
- Integration installed and configured but creates ZERO entities

**Root Cause** (verified 2025-11-14):
- Known HA integration bug (#88433, #94447, #133919)
- TypeError in config flow prevents entity creation
- API works perfectly (AQI=3), but integration creates 0 entities

**Resolution**:
- ✅ **WAQI IMPLEMENTED** - Manual REST sensors via `packages/waqi_manual_sensors.yaml`
- ✅ **9 Working Entities** - AQI, category, PM2.5, PM10, O3, NO2, temp, humidity, attribution
- ✅ Task 1.7 (Overview Weather) - WAQI chips NOW AVAILABLE for Phase 3 implementation
- ✅ Task 3.4 (Calendar Page) - WAQI widgets NOW AVAILABLE for Phase 3 implementation
- ✅ All planning docs updated to reflect working sensors (2025-11-14)
- ✅ Dashboard implementation can proceed WITH air quality features

---

### 2. Material You Theme Structure Unknown ⛔

**Problem**:
- Plan assumes copying ~50 YAML variables from Material You theme file
- `01-component-requirements.md` warns: "Material You Theme is a THEME (loaded from themes/ directory), NOT a frontend resource"
- Unknown if Material You has copyable YAML or is JavaScript-only

**Impact**:
- Task 1.3 "Configure Material You Theme" (2 hours) becomes open-ended research task
- Could block entire Week 1 if theme doesn't work as expected

**Fix**:
```bash
# Check Material You theme actual structure NOW
ls -la /home/drewcifer/mnt/homeassistant-config/themes/material_you/
cat /home/drewcifer/mnt/homeassistant-config/themes/material_you/*.yaml 2>/dev/null || echo "No YAML files found"
```

**Alternatives if no YAML**:
- Use existing `md3_enhanced_climate.yaml` theme (already MD3-compliant)
- Skip Material You color picker feature
- Use theme variables directly without copying

---

### 3. Tablet Hardware Not Verified ⛔

**Problem**:
- Assumed resolution: 1920×1080
- Assumed OS: Android 12+
- Entire grid layout designed for 465px columns (1920px / 4)

**Impact**:
- If tablet is 1920×1200, 2560×1440, or other resolution: layouts break
- If tablet OS differs: Android settings in kiosk mode config might not exist

**Fix**:
```javascript
// Access tablet, open browser, run in console:
console.log('Resolution:', window.screen.width, 'x', window.screen.height);
console.log('Device Pixel Ratio:', window.devicePixelRatio);
console.log('User Agent:', navigator.userAgent);
```

---

### 4. Incomplete Entity Verification ⛔

**Verified** (excellent work):
- ✅ 18 climate sensors (temperature + humidity)
- ✅ 3 emergency scripts (actual entity IDs: `emergency_humidity_override`, `emergency_cooling_boost`, `emergency_rollback_all_flags`)
- ✅ Motion sensors (corrected: `bedroom_motion` NOT `master_bedroom_motion`)

**NOT Verified** (critical gaps):
- ❌ **36 light entities** - only examples shown (`light.living_room_lights`, `light.master_bedroom_downlights`)
  - Might be `light.living_room` not `light.living_room_lights`
  - Week 2 room pages will fail if entity IDs wrong

- ❌ **12 media players** - only 4 named (`media_player.living_room_tv`, etc.)
  - "(8 additional media players)" - need actual entity IDs

- ❌ **6 calendars** - only 3 named (`calendar.family`, `calendar.cassandrew`, `calendar.week_numbers`)
  - "(3 additional calendars)" - Task 3.4 (Calendar view) needs all 6

- ❌ **Dew point sensors** - assumed to exist, likely DON'T
  - Every room page references `sensor.climate_<room>_dew_point`
  - Dew point is CALCULATED, not measured
  - Need 18 template sensors (missing from Task 1.6)

**Fix**:
```bash
# List ALL entity IDs by domain
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states" 2>/dev/null | \
  jq -r '.[] | select(.entity_id | startswith("light.")) | .entity_id' | sort

curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states" 2>/dev/null | \
  jq -r '.[] | select(.entity_id | startswith("media_player.")) | .entity_id' | sort

curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states" 2>/dev/null | \
  jq -r '.[] | select(.entity_id | startswith("calendar.")) | .entity_id' | sort

# Check if dew point sensors exist
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states" 2>/dev/null | \
  jq -r '.[] | select(.entity_id | contains("dew_point")) | .entity_id' | sort
```

---

### 5. Dew Point Template Sensors Missing ⛔

**Problem**:
- All room views reference dew point sensors (e.g., `sensor.climate_living_dew_point`)
- Task 1.6 creates 7 template sensors (occupancy, comfort scores) but NOT dew point
- Need ~18 dew point sensors (one per climate sensor location)

**Impact**:
- Week 2 room pages will have broken entity references
- Dew point displays won't work

**Fix** (add to Task 1.6):
```yaml
template:
  - sensor:
      # Dew Point Calculations (add all 18)
      - name: "Living Room Dew Point"
        unique_id: climate_living_dew_point
        unit_of_measurement: "°F"
        device_class: temperature
        state: >
          {% set t = states('sensor.climate_living_temperature') | float %}
          {% set rh = states('sensor.climate_living_humidity') | float %}
          {% if t != 0 and rh != 0 %}
            {% set a = 17.27 %}
            {% set b = 237.7 %}
            {% set t_c = (t - 32) * 5/9 %}
            {% set gamma = (a * t_c) / (b + t_c) + log(rh/100) %}
            {% set dp_c = (b * gamma) / (a - gamma) %}
            {{ (dp_c * 9/5 + 32) | round(1) }}
          {% else %}
            unavailable
          {% endif %}

      # Repeat for all 18 rooms: master, dining, kitchen1, kitchen2, rowan,
      # office, guestbed, guestbath, laundry, halfbath, foyerfront, foyergarage,
      # masterbath, mastercloset, hvac_return, hvac_supply, outdoor
```

---

## HIGH-RISK GAPS (Will Cause Delays)

### 6. Material Symbols Installation Unverified

**Problem**:
- Repository URL: `https://github.com/basbruss/material-symbols`
- No verification this URL is correct/current
- 50+ `m3o:` icon references throughout plan
- No fallback icon mapping table (m3o: → mdi:)

**Impact**:
- Task 1.1 might fail if repository doesn't exist
- All views use Material Symbols icons
- Manual conversion needed if Material Symbols fails

**Fix**:
```bash
# Test repository exists NOW
curl -s https://github.com/basbruss/material-symbols | grep -q "basbruss" && \
  echo "✅ Repository exists" || echo "❌ Repository not found"
```

Create fallback icon map:
```markdown
| Material Symbol | MDI Fallback | Usage |
|-----------------|--------------|-------|
| m3o:home | mdi:home | Overview/navbar |
| m3o:thermometer | mdi:thermometer | Temperature |
| m3o:water_percent | mdi:water-percent | Humidity |
| m3o:water_drop | mdi:water | Dew point |
| m3o:ac_unit | mdi:air-conditioner | AC controls |
| ... (complete for all icons used) |
```

---

### 7. Scene Presets Compatibility Uncertain

**Problem**:
- Scene Presets designed for Hue Bridge
- Unknown if works with Zigbee2MQTT/Z-Wave
- `01-component-requirements.md` says "verify compatibility"
- No alternative specified if it fails

**Impact**:
- Task 3.5 (Build Scenes View) could fail entirely
- Week 3 deliverable at risk

**Fix**:
Test Scene Presets OR specify button-card alternative NOW:
```yaml
# Alternative if Scene Presets fails: custom:button-card grid
- type: grid
  columns: 4
  cards:
    - type: custom:button-card
      entity: scene.movie_time
      name: Movie Time
      icon: mdi:movie
      tap_action:
        action: call-service
        service: scene.turn_on
        service_data:
          entity_id: scene.movie_time
    # Repeat for all scenes
```

---

### 8. Decluttering + Card-Mod Syntax Untested

**Problem**:
- `04-customization-strategy.md` uses `config.entity | state` inside card-mod within decluttering template
- This is 3-layer nesting: decluttering → mushroom-entity-card → card-mod
- No confirmation this pattern actually works

**Impact**:
- Room summary template might not work
- All room pages use this template (Week 2)

**Fix** - Test this minimal example NOW:
```yaml
decluttering_templates:
  test_template:
    card:
      type: custom:mushroom-entity-card
      entity: "[[entity]]"
      card_mod:
        style: |
          :host {
            {% set temp = config.entity | state | float %}
            --card-mod-icon-color: {% if temp > 75 %}red{% else %}green{% endif %};
          }

# Test usage
- type: custom:decluttering-card
  template: test_template
  variables:
    - entity: sensor.climate_living_temperature
```

---

### 9. Dashboard Registration Buried in Implementation

**Problem**:
- Critical `configuration.yaml` modification hidden in Task 1.2 details (line 64-74)
- Easy to miss during implementation
- Dashboard won't load if registration skipped

**Fix** - Create PRE-FLIGHT CHECKLIST:
```markdown
## PRE-FLIGHT CHECKLIST (Before Week 1 Task 1.1)

**Configuration.yaml Modifications Required**:
- [ ] Add lovelace dashboards registration
- [ ] Verify current lovelace mode (storage/yaml)
- [ ] Backup configuration.yaml before modifications

**HACS Installations Required**:
- [ ] Material Symbols (CRITICAL - Task 1.1)

**Entity Verification Required**:
- [ ] All light entity IDs documented
- [ ] All media player entity IDs documented
- [ ] All calendar entity IDs documented
- [ ] Dew point template sensors created

**Hardware Verification Required**:
- [ ] Tablet resolution confirmed
- [ ] Tablet OS/browser verified
- [ ] Baseline performance measured
```

---

### 10. No Incremental Testing Strategy

**Problem**:
- Tasks structured as: "Build 2 hours of configuration, then test"
- Example: Task 1.2 creates dashboard file + registration + navbar + templates THEN tests
- If registration fails, wasted time on navbar/templates

**Impact**:
- Late failure detection
- Difficult to isolate bugs
- Not one-shot friendly

**Fix** - Fail-fast approach:
```markdown
Task 1.2 REVISED:
1. Create minimal dashboard file (title only) - 5 min
2. Register in configuration.yaml - 5 min
3. Restart HA - 2 min
4. TEST: Access /tablet-md3/0 in browser ✓
5. If pass: Add first empty view - 5 min
6. TEST: View loads ✓
7. If pass: Add navbar configuration - 10 min
8. TEST: Navbar displays ✓
9. If pass: Add decluttering templates - 20 min
10. TEST: Template renders ✓

Total: Same 2 hours, but 5 validation checkpoints instead of 1
```

---

## PROCESS CRITICAL ISSUES

### 11. Git Workflow Ignored

**Problem**:
- CLAUDE.md specifies: "post-commit hook deploys local → live (AUTOMATIC)"
- Implementation plan has ZERO commit instructions
- 10+ file modification tasks with no git integration

**Impact**:
- No rollback points if implementation breaks
- No auto-deployment to live system
- No change history for debugging

**Fix** - Add commit strategy to EVERY task:
```markdown
Task 1.2 Post-Validation:
✅ ha-validate passes
✅ Dashboard loads in browser
✅ Navbar displays

**Git Commit**:
```bash
git add ui-lovelace-tablet-md3.yaml configuration.yaml
git commit -m "Add MD3 dashboard registration and navbar

- Register tablet-md3 dashboard in configuration.yaml
- Create ui-lovelace-tablet-md3.yaml base structure
- Configure 10-view navbar
- Add decluttering templates (room_summary, emergency_button)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"
```

Post-commit hook will auto-deploy to live system.
```

---

### 12. No Migration/Cutover Plan

**Problem**:
- Family actively uses `gulf-coast-climate-optimized.yaml` in production
- Plan treats this as greenfield project
- No cutover procedure, fallback access, or monitoring plan

**Impact**:
- Production disruption risk
- No rollback if family rejects new dashboard
- No A/B comparison strategy

**Fix** - Add cutover procedure:
```markdown
## Week 4 Addition: Production Cutover

**Pre-Cutover** (Friday evening):
1. Validate new dashboard 100% functional on desktop browser
2. Test on secondary tablet/phone
3. Backup current tablet configuration
4. Document rollback procedure

**Cutover** (Saturday morning - low usage time):
1. Update tablet bookmark: `/tablet-md3/0`
2. Keep old dashboard accessible: `/lovelace/climate` (bookmark)
3. Notify family: "Testing new dashboard, old one still available"

**Post-Cutover Monitoring** (24 hours):
1. Observe family usage patterns
2. Collect feedback (informal survey)
3. Monitor for errors in HA logs
4. Check tablet performance (RAM usage, page load times)

**Go/No-Go Decision** (Sunday evening):
- ✅ GO: Family prefers new dashboard → decommission old one after 1 week
- ❌ NO-GO: Issues found → revert tablet to old dashboard, document blockers
```

---

### 13. No User Acceptance Testing Plan

**Problem**:
- Success metric: "Family prefers MD3 dashboard as primary control interface"
- No UAT plan: who tests, when, what scenarios, acceptance criteria?
- Implementation plan ends with documentation, not user testing

**Impact**:
- Unknown if dashboard meets user needs
- No structured feedback collection
- Could complete implementation but fail user acceptance

**Fix** - Add UAT tasks:
```markdown
## Week 4 Addition: User Acceptance Testing

**UAT Schedule**: After each phase completion

**Phase 1 UAT** (End of Week 1):
- Tester: Drew
- Scenarios:
  1. Check whole-home temperature/humidity (Overview page)
  2. Activate emergency humidity override
  3. Navigate to Office room page
- Success: All scenarios complete in <10 seconds

**Phase 2 UAT** (End of Week 2):
- Testers: Drew + Cassie
- Scenarios:
  1. Adjust bedroom lights from Master page
  2. Check kitchen temperature
  3. View 4-hour climate trend graph
- Success: 90% task success rate, no confusion

**Phase 3 UAT** (End of Week 3):
- Testers: Whole family
- Scenarios:
  1. Check front door camera
  2. Arm alarm via dashboard
  3. Activate "bedtime" scene
  4. Check tomorrow's calendar events
- Success: All family members can complete tasks independently

**Final UAT** (End of Week 4):
- Test: Use ONLY new dashboard for 48 hours (no old dashboard access)
- Survey: 5-point scale on usability, speed, aesthetics
- Acceptance: 4+ average rating across all users
```

---

### 14. Time Estimates Too Optimistic

**Problem**:
- Example: Task 1.3 "Configure Material You Theme" - 2 hours
  - Includes: Finding file, copying ~50 variables, modifying, testing
  - Realistic: 3-4 hours with debugging
- No buffer for unexpected issues

**Impact**:
- 4-week plan becomes 5-6 weeks
- Rushed implementation to meet deadlines
- Quality compromises

**Fix** - Multiply all estimates by 1.5-2x:
```markdown
Original: Task 2.2 Build Living Area Page - 3 hours
Revised: Task 2.2 Build Living Area Page - 4.5-6 hours

Rationale:
- 13+ card configurations (header, 4 climate, charts, 3 lights, fan, blinds, 2 media)
- ApexCharts alone: 30-60 min to configure + debug
- Jinja2 template errors: 15-30 min to fix each
- Card-mod styling tweaks: 10-20 min per card
- Total realistic: 5 hours, not 3
```

---

## REQUIRED PHASE 0: PRE-IMPLEMENTATION VERIFICATION

**Add this BEFORE Week 1 starts**

**Duration**: 1-2 days
**Purpose**: Answer ALL assumptions, verify ALL components, test ALL patterns

### Phase 0 Checklist

#### Hardware Verification
- [ ] Boot WF2185T tablet, document:
  - Actual resolution (window.screen.width × height)
  - Operating system version (Settings → About)
  - Browser type/version (navigator.userAgent)
  - Available storage space
- [ ] Test dashboard rendering on tablet browser
- [ ] Measure baseline performance:
  - Current dashboard load time
  - RAM usage on tablet
  - Camera feed performance (9 cameras)

#### Entity Verification
- [ ] List ALL 36 light entity IDs (exact names, not examples)
- [ ] List ALL 12 media player entity IDs (all 12, not 4+8)
- [ ] List ALL 6 calendar entity IDs (all 6, not 3+3)
- [ ] Verify/create ALL 18 dew point template sensors
- [ ] Test emergency script notifications:
  ```bash
  # Test each script sends mobile notification
  curl -X POST "$HA_BASE/api/services/script/emergency_humidity_override" \
    -H "Authorization: Bearer $HA_TOKEN"
  # Verify Drew's iPhone receives notification
  ```

#### Component Verification
- [ ] Locate Material You theme actual file structure:
  ```bash
  find /home/drewcifer/mnt/homeassistant-config/themes/material_you/ -name "*.yaml" -o -name "*.js"
  ```
- [ ] Test Material Symbols installation:
  ```bash
  curl -s https://github.com/basbruss/material-symbols | grep -q "This repository"
  ```
- [ ] Test Scene Presets OR specify button-card alternative
- [ ] Test card-mod + decluttering interaction (minimal example)
- [ ] Test lovelace dashboard registration (create test dashboard)

#### Integration Verification
- [x] Confirm WAQI status: ✅ **COMPLETE - 9 working entities**
  ```bash
  # Verified 2025-11-14: 9 WAQI entities via manual REST sensors
  # sensor.waqi_seabrook_aqi (21, Good)
  # sensor.waqi_seabrook_aqi_category
  # sensor.waqi_seabrook_pm2_5, pm10, ozone, no2, temperature, humidity, attribution
  ```
  - ✅ WAQI working via `packages/waqi_manual_sensors.yaml`
  - ✅ All entity IDs documented in planning docs
- [ ] Verify current lovelace mode:
  ```bash
  grep -A5 "^lovelace:" configuration.yaml
  ```
- [ ] Create complete icon fallback map (m3o: → mdi:)

#### Pattern Testing
- [ ] Test decluttering + card-mod + mushroom (minimal card)
- [ ] Test ApexCharts with 5min update_interval
- [ ] Test auto-entities with head:count limit
- [ ] Test conditional card visibility with media_player states

**GATE: ALL Phase 0 items MUST PASS before proceeding to Week 1**

---

## SPECIFIC DOCUMENT FIXES REQUIRED

### 02-entity-mapping.md
- [ ] Line 340-353: Remove WAQI or add actual entity IDs
- [ ] Lines 245-273: Complete all 36 light entity IDs (not examples)
- [ ] Lines 293-300: Complete all 12 media player entity IDs
- [ ] Lines 353-365: Complete all 6 calendar entity IDs
- [ ] Lines 125-130: Add all 18 dew point entity IDs (or mark as "TO CREATE")

### 03-view-architecture.md
- [ ] Line 237: Fix "2x3 grid" → "3×3 grid (9 cameras)"
- [ ] Lines 139, 444-452: Remove WAQI references if integration not installed
- [ ] Line 172-174: Clarify button sizing (fixed 400px vs flex)
- [ ] Add default_view to dashboard registration example

### 04-customization-strategy.md
- [ ] Lines 629-665: Harmonize blue color usage (3 different blues currently)
- [ ] Lines 463-495: Add "TESTED" confirmation to decluttering template
- [ ] Lines 374-409: Remove WAQI integration if not installed

### 05-implementation-phases.md
- [ ] Task 1.1: Add repository verification step
- [ ] Task 1.2: Add incremental testing checkpoints
- [ ] Task 1.3: Add Material You theme structure verification
- [ ] Task 1.6: Add 18 dew point template sensor definitions
- [ ] Task 1.7: Remove WAQI or verify entity IDs
- [ ] ALL tasks: Add "Git Commit" step after validation
- [ ] Task 3.4: Remove WAQI or verify entity IDs
- [ ] Task 3.5: Specify Scene Presets alternative
- [ ] Task 4.8: Add UAT tasks
- [ ] Add cutover procedure
- [ ] Multiply all time estimates by 1.5x

### 06-tablet-configuration.md
- [ ] Line 77-112: Choose ONE kiosk mode method (recommend Method 1)
- [ ] Lines 296-318: Move ApexCharts optimization to view architecture
- [ ] Lines 677-686: Add baseline measurement requirement

### 00-project-overview.md
- [ ] Line 180: Verify WAQI integration status
- [ ] Add Phase 0 to timeline
- [ ] Update risk assessment with critique findings

### 01-component-requirements.md
- [ ] Line 396-421: Clarify Material You theme JS vs YAML structure
- [ ] Add icon fallback mapping table

---

## WHAT THE PLAN DOES WELL

**Excellent aspects (preserve these)**:
- ✅ Climate sensor verification (18/18 with actual entity IDs)
- ✅ Emergency script verification (3/3 with corrections)
- ✅ Motion sensor corrections (bedroom_motion not master_bedroom_motion)
- ✅ Comprehensive wireframes with pixel-perfect layouts
- ✅ Detailed ApexCharts optimization strategy
- ✅ Realistic risk assessment and contingency planning
- ✅ KISS principles applied throughout
- ✅ Equipment safety preserved (AC/dehumidifier arbitration)
- ✅ Gulf Coast climate focus maintained

---

## FINAL RECOMMENDATION

**DO NOT START WEEK 1 WITH CURRENT PLAN**

**Execute this sequence**:

1. **PHASE 0** (1-2 days)
   - Complete all verification tasks above
   - Document ALL entity IDs (no more "X additional")
   - Test ALL critical patterns (decluttering+card-mod, Scene Presets, etc.)
   - Measure baseline performance

2. **UPDATE PLANNING DOCS** (4-6 hours)
   - Remove ALL "assumed"/"verify"/"test" items
   - Replace with verified facts
   - Add incremental testing checkpoints
   - Add git commit instructions
   - Add UAT plan
   - Add cutover procedure

3. **WEEK 1** (with 100% confidence)
   - All entity IDs verified
   - All components tested
   - All patterns validated
   - No research tasks disguised as implementation

**Current readiness**: 80% planned, 20% assumed
**One-shot readiness**: 100% planned, 0% assumed

You're 80% there. The remaining 20% gaps will cost 2-4 weeks of iteration if not fixed first.

---

## TRACKING THIS CRITIQUE

**Living Document Status**: ✅ Created
**Next Steps**:
1. Review Phase 0 checklist
2. Execute verification tasks
3. Update planning documents with verified data
4. Re-assess one-shot readiness
5. Proceed to Week 1 only when Phase 0 complete

**Questions? Blockers?** Update this document with findings from Phase 0 execution.
