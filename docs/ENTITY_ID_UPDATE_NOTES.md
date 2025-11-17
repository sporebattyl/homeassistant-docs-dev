# Entity ID Update Notes - Codex Naming Convention

**Date**: 2025-10-06
**Status**: Automated updates completed, legacy references documented

## Automated Updates Applied

Successfully updated entity IDs in 3 packages:
- `climate_dashboard_enhancements.yaml`
- `climate_foundation_control.yaml`
- `climate_safety_master.yaml`

### Entity ID Mapping

**Presence Sensors (15):**
- Old: `binary_sensor.presencesensor[1-15]_presence`
- New: `binary_sensor.presence_[location]_presence`

**Temperature Sensors (15):**
- Old: `sensor.temphumidsensor[1-15]_temperature`
- New: `sensor.climate_[location]_temperature`

**Humidity Sensors (15):**
- Old: `sensor.temphumidsensor[1-15]_humidity`
- New: `sensor.climate_[location]_humidity`

## Legacy References NOT Updated

### Unique IDs (Intentionally Left Unchanged)
Unique IDs are internal identifiers and do not need to match entity IDs:
- `unique_id: temphumidsensor1_humidity_rounded` (lines 955-1018 in climate_dashboard_enhancements.yaml)
- `unique_id: presencesensor[N]_motion_enhanced` (lines 1219-1296 in climate_dashboard_enhancements.yaml)

### Broken Motion State References (To Be Fixed by Climate Rescue Plan)
The following references are **deprecated/broken** per Climate Rescue Plan:
- `sensor.presencesensor[N]_motion_state` - These entities don't exist
- `binary_sensor.presencesensor[N]_motion` - These entities don't exist

**Location**: climate_dashboard_enhancements.yaml lines 1059-1179

**Resolution**: The Climate Rescue Plan (Day 1-2: Emergency Repairs) creates new presence-based sensors to replace these broken motion_state references. These legacy references will be removed/updated when implementing the rescue plan.

**Quote from Rescue Plan**:
> "Purpose: Fix follow-me to use actual presence sensors instead of broken motion_state"

## Verification

### Old Entity IDs Remaining
- **Temperature/Humidity**: 0 references to `temphumidsensor[N]_temperature|humidity` in entity_id fields ✓
- **Presence**: 0 references to `presencesensor[N]_presence` in entity_id fields ✓
- **Motion State**: 98 references to broken `motion_state` entities (documented above, will be fixed by rescue plan)

### Backup Location
Pre-update backups: `/home/drewcifer/homeassistant-config/backups/packages_entity_rename_20251006_230614/`

## Next Steps

1. ✅ Verify configuration syntax is valid
2. ✅ Sync updated packages to HA mount
3. ✅ Commit to GitHub
4. ⏳ Implement Climate Rescue Plan Day 1-2 to fix motion_state references
5. ⏳ Test follow-me functionality with new presence-based sensors
