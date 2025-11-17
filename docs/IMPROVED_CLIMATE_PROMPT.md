# Improved Climate Automation Review Prompt

**Date:** 2025-10-12
**Entity Snapshot:** `docs/climate-entities.json` (3,822 entities, 1,062 climate-related)
**HA Version:** 2025.9.1
**System:** Single home power user, League City TX (Gulf Coast climate)

---

## System Context

Please review the Home Assistant climate automations in this repository. The system architecture is:

### Configuration Entry Points
- **Main config:** `configuration.yaml` - Uses `!include_dir_named packages` for modular organization
- **Active climate packages:** `packages/climate_*.yaml` (13 operational packages)
- **Prior experiments:** Review `packages/*.disabled` for lessons learned from previous approaches
- **Helper definitions:** `customization/input_*.yaml` for reusable input helpers
- **Automation files:** `automations/*.yaml` for standalone automations

### Physical System
- **Home:** 2,386 sq ft, League City TX (Gulf Coast - high humidity climate)
- **HVAC:** Lennox ML14XC1 air conditioner (3-ton)
- **Dehumidifier:** Aprilaire E130 whole-home dehumidifier
- **Temperature sensors:** 15x ZG-227Z Zigbee temp/humidity sensors (`temphumidsensor1-15`)
- **Thermostat:** Z-Wave thermostat with remote sensor support

### Current State (from snapshot)
- **Total entities:** 3,822
- **Climate entities:** 1,062
- **15-sensor network:** Fully operational with persistence infrastructure
- **Current operation:** 74°F home / 73°F sleep setpoints, 1.0°F deadband
- **Energy savings:** $548/year progress vs baseline

### Key Climate Features
1. **15-Sensor Motion Follow-Me Cooling:** Tracks occupancy across zones, adjusts cooling priority
2. **Equipment Arbitration:** Mutual exclusion prevents AC/dehumidifier conflicts
3. **Runtime Optimization:** 45min HVAC cycles for adequate Gulf Coast moisture removal
4. **Safety Protocols:** 60% humidity ceiling (absolute max for mold prevention)
5. **Performance Monitoring:** Real-time HVAC efficiency and equipment health tracking

### Pain Points & Known Issues
- **Entity cleanup needed:** 2,088 unavailable entities from disabled integrations/experiments
- **Complexity growth:** 13 climate packages may have overlapping logic
- **Sensor persistence:** ZG-227Z sensors report sporadically (energy-efficient), need LKG values
- **Dashboard sync:** Climate Control Center v2 (`/climate-control-center-v2`) is sole source (storage disabled)

---

## Review Goals

Design an efficient, robust climate automation system for this single power user. The implementation may include advanced logic, but keep configuration structure simple (KISS principles), favoring:
- Clear state machines and well-named helpers
- Modular packages with single responsibilities
- Robust error handling and fallback logic
- Minimal manual intervention required

---

## Deliverables Requested

### 1. Audit of Existing Climate Automations
- Review all `packages/climate_*.yaml` files for:
  - Pain points and failure modes
  - Missing safeguards (especially humidity ceiling enforcement)
  - Redundant logic across packages
  - Opportunities for consolidation
- Identify obsolete entities and definitions that can be removed

### 2. Proposed Architecture
- High-level flow diagram (conceptual, not visual)
- Module/automation breakdown with clear responsibilities
- Package organization structure
- Helper entity naming conventions

### 3. Specific YAML/Package Changes
- File-by-file changes with line references (`file:line`)
- Use `!secret` for sensitive values where appropriate
- Preserve existing customizations (entity names, icons, etc.)
- Include migration path if breaking changes required

### 4. Testing/Checklist Steps
**Note:** These commands cannot run in GitHub/Codex environment, but should be included for human execution:
```bash
# Configuration validation (run after applying changes)
hass --config /home/drewcifer/mnt/homeassistant-config --script check_config

# Restart Home Assistant
curl -X POST -H "Authorization: Bearer <token>" \
  http://192.168.88.125:8123/api/services/homeassistant/restart

# Check logs for errors
tail -f /home/drewcifer/mnt/homeassistant-config/home-assistant.log
```

- List specific automations to exercise (trigger conditions)
- Expected sensor behavior patterns
- Dashboard verification steps

---

## Critical Constraints

### Non-Negotiable Safety Requirements
- **60% humidity ceiling:** Absolute maximum for Gulf Coast mold prevention
- **Equipment arbitration:** Mutual exclusion prevents simultaneous AC/dehumidifier operation
- **Runtime optimization:** Minimum 15min runtime / 10min cooldown for proper moisture removal
- **Emergency protocols:** Multi-level safety with mobile notifications

### Development Constraints
- **NO enterprise patterns:** Avoid A/B testing, automated rollouts, multi-tenant logic
- **Manual control preferred:** User makes informed decisions about changes
- **Simple feature flags:** Boolean on/off switches over complex automation
- **KISS compliance:** Appropriate complexity for single home power user
- **Gulf Coast focus:** High humidity, hot summers require specific safety protocols

### Existing Patterns to Preserve
- **Package-based organization:** Primary method for complex domain logic
- **Include directives:** `!include_dir_named` for packages
- **Entity customizations:** Grouped by domain in `customization/`
- **KISS feature flag pattern:**
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

---

## Supporting Documentation

- **Entity snapshot:** See `docs/climate-entities.json` (captured 2025-10-12)
- **System overview:** See `docs/README.md`
- **Package structure:** All climate logic in `packages/climate_*.yaml`
- **15-sensor mapping:** See `.claude/CLAUDE.md` for room assignments

---

## Focus Areas

Prioritize:
1. **Reliability:** No single point of failure, graceful degradation
2. **Maintainability:** Clear structure, good comments, modular design
3. **Minimal manual intervention:** Self-healing, automatic recovery
4. **Gulf Coast optimization:** Humidity control is primary concern
5. **Energy efficiency:** Maintain $548/year savings trajectory

---

## Example Usage

**Audit Request:**
> "Review `packages/climate_safety_master.yaml` and identify any missing safety checks for the 60% humidity ceiling enforcement. Cross-reference with entity snapshot to ensure all 15 sensors are properly integrated."

**Architecture Proposal:**
> "Propose a consolidated equipment arbitration system that replaces the current per-package logic with a centralized state machine in `packages/climate_hvac_coordination.yaml`."

**Specific Implementation:**
> "Modify `packages/climate_foundation_control.yaml:145-167` to add fallback logic when `sensor.average_house_humidity_enhanced` is unavailable. Use last-known-good values from `input_number.zg227z_humidity*_lkg` helpers."

---

**End of Prompt**
