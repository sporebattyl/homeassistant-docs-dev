# Zigbee Device Naming Convention

**Version:** 1.0
**Last Updated:** 2025-10-06
**Status:** Proposed for Implementation

## Executive Summary

This document establishes a unified naming convention for all Zigbee devices in the Home Assistant system. The primary goal is to align device naming with the established 15-room sensor network, enabling consistent automations and reducing maintenance overhead.

## Core Problem Identified

**Current Issue:** Motion sensors and other Zigbee devices use inconsistent naming that doesn't align with the established temperature/humidity sensor room numbering (temphumidsensor1-15). This causes automation failures and maintenance complexity.

**Example Mismatch:**
- `temphumidsensor4` = Kitchen
- `presencesensor3` (in planned automation) = Kitchen (under cabinet)
- **Result:** Room 4 and sensor 3 both refer to Kitchen - confusing and error-prone

## Naming Convention Rules

### TIER 1: Established Devices (Grandfathered - DO NOT RENAME)

**Temperature/Humidity Sensors (15 devices):**
- Pattern: `temphumidsensor[1-15]`
- Status: **KEEP AS-IS** - Integrated into 13 climate packages, working professionally
- Risk: Too high to rename (would break climate system)

**Rationale:** These sensors are the foundation of your climate control system. Renaming would require updates to:
- 13 climate packages
- Climate Control Center v2 dashboard
- Multiple template sensors
- Automation triggers and conditions
- Historical data references

### TIER 2: Room-Aligned Devices (NEW STANDARD)

**Pattern:** `room_XX_[type]_[descriptor]`

**Components:**
- `room_XX`: Two-digit room number (01-15) matching temphumidsensor room assignments
- `[type]`: Device type (motion, blind, light, plug, switch, fan)
- `[descriptor]`: Optional descriptor for multiple devices in same room

**Room Number Mapping (Master Reference):**
```
01 = Living Room
02 = Dining Room
03 = Outside Back Porch
04 = Kitchen
05 = Half Bathroom
06 = Rowan's Room
07 = Guest Bathroom
08 = Guest Bedroom
09 = Foyer Garage Entryway
10 = Master Bedroom
11 = Master Bathroom
12 = Master Closet
13 = Laundry Room
14 = Office
15 = Foyer Front Door Entryway
```

**Examples:**
- `room_01_motion` - Living Room motion sensor
- `room_04_light_cabinet` - Kitchen under-cabinet lighting
- `room_04_light_overhead` - Kitchen overhead light (if exists)
- `room_10_blind` - Master Bedroom blind
- `room_14_plug_lamp` - Office desk lamp smart plug

### TIER 3: Non-Room Devices (Special Locations)

**Pattern:** `[location]_[type]_[descriptor]`

**For devices not tied to the 15-room system:**
- Outdoor sensors
- Garage equipment
- Whole-house devices
- Pet feeders
- Console/entertainment devices

**Examples:**
- `outdoor_back_porch_temp` - Outside temperature sensor (if separate from temphumidsensor3)
- `garage_fan_drum` - Garage drum fan
- `console_light_1` - Entertainment console light 1
- `console_light_2` - Entertainment console light 2
- `pet_feeder_dog` - Dog automatic feeder
- `pet_feeder_cat` - Cat automatic feeder

## Current Device Inventory Analysis

### Devices Requiring Rename

**Motion Sensors (3 currently installed):**

| Current Name | Current Location | Recommended New Name | Room # |
|--------------|------------------|---------------------|--------|
| Living Room Motion ZG204ZM | Living Room | room_01_motion | 01 |
| Office Motion ZG204ZM | Office | room_14_motion | 14 |
| Bedroom Motion ZG204ZM | Master Bedroom | room_10_motion | 10 |

**Blinds (3 devices - need room assignment):**

| Current Name | Assumed Location | Recommended New Name | Room # |
|--------------|------------------|---------------------|--------|
| Blinds 1 | (TBD - provide actual room) | room_XX_blind | XX |
| Blinds 2 | (TBD - provide actual room) | room_XX_blind | XX |
| Blinds 3 | (TBD - provide actual room) | room_XX_blind | XX |

**ACTION REQUIRED:** Identify which rooms have Blinds 1, 2, and 3 to complete this mapping.

**Smart Plugs (2 devices):**

| Current Name | Location | Recommended New Name | Room # |
|--------------|----------|---------------------|--------|
| Smart Outlet Office Lamp | Office | room_14_plug_lamp | 14 |
| Smart Plug Console Lights | Living Room/Entertainment | console_plug_lights | N/A |

**Lights:**

| Current Name | Location | Recommended New Name | Room # |
|--------------|----------|---------------------|--------|
| Under Cabinet Lighting | Kitchen | room_04_light_cabinet | 04 |
| Console Light 1 | Living Room/Entertainment | console_light_1 | N/A |
| Console Light 2 | Living Room/Entertainment | console_light_2 | N/A |

**Other Devices:**

| Current Name | Location | Recommended New Name | Notes |
|--------------|----------|---------------------|-------|
| Dog Feeder | N/A | pet_feeder_dog | Keep as-is (already clear) |
| Cat Feeder | N/A | pet_feeder_cat | Keep as-is (already clear) |
| Garage Drum Fan | Garage | garage_fan_drum | Keep as-is (already clear) |

**Unconfigured Devices (2):**

| IEEE Address | Status | Action |
|--------------|--------|--------|
| 0x001788010bc24258 | Not configured | Identify device, assign name per convention |
| 0x000d6f000e25c8ea | Not configured | Identify device, assign name per convention |

## Future Motion Sensor Expansion (12 additional sensors needed)

When you add the remaining 12 motion sensors to complete the 15-room network, use this mapping:

| Room # | Room Name | Device Name | Currently Installed? |
|--------|-----------|-------------|----------------------|
| 01 | Living Room | room_01_motion | ✅ YES |
| 02 | Dining Room | room_02_motion | ❌ No |
| 04 | Kitchen | room_04_motion | ❌ No |
| 05 | Half Bathroom | room_05_motion | ❌ No |
| 06 | Rowan's Room | room_06_motion | ❌ No |
| 07 | Guest Bathroom | room_07_motion | ❌ No |
| 08 | Guest Bedroom | room_08_motion | ❌ No |
| 09 | Foyer Garage Entryway | room_09_motion | ❌ No |
| 10 | Master Bedroom | room_10_motion | ✅ YES |
| 11 | Master Bathroom | room_11_motion | ❌ No |
| 12 | Master Closet | room_12_motion | ❌ No |
| 13 | Laundry Room | room_13_motion | ❌ No |
| 14 | Office | room_14_motion | ✅ YES |
| 15 | Foyer Front Door Entryway | room_15_motion | ❌ No |

**Note:** Room 03 (Outside Back Porch) intentionally excluded - motion sensor not practical outdoors.

## Migration Strategy

### Phase 1: Validation & Planning (Low Risk)

**Steps:**
1. ✅ Document current device inventory (completed above)
2. Identify blind locations (user input required)
3. Identify unconfigured device purposes
4. Review all automations using current device names
5. Create comprehensive find/replace map

**Automation Files to Review:**
- `/automations/follow_me_lighting.yaml` (commented out, references presencesensor1-15)
- `/automations/room_fans.yaml`
- `/packages/climate_dashboard_enhancements.yaml`
- `/templates/motion_dashboard_aliases.yaml`

### Phase 2: Rename Execution (Controlled Risk)

**Pre-Rename Checklist:**
- [ ] Full system backup via HA interface
- [ ] Git commit of current state: `git add . && git commit -m "Pre-Zigbee rename backup"`
- [ ] Document all automations using devices to be renamed
- [ ] Prepare rollback plan (Zigbee2MQTT config backup)

**Rename Process:**
1. Stop Home Assistant (prevent entity state loss during rename)
2. Edit `/zigbee2mqtt/configuration.yaml`
3. Update `friendly_name` for each device per mapping table
4. Restart Zigbee2MQTT addon (applies new names)
5. Wait 2 minutes for entity discovery
6. Start Home Assistant
7. Verify new entity IDs appear in Developer Tools > States

**Example Zigbee2MQTT Config Edit:**
```yaml
# BEFORE
'0x00158d00063e259b':
  friendly_name: Living Room Motion ZG204ZM

# AFTER
'0x00158d00063e259b':
  friendly_name: room_01_motion
```

### Phase 3: Automation Updates

**For each automation referencing renamed devices:**
1. Open automation file
2. Find old entity ID (e.g., `binary_sensor.living_room_motion_zg204zm_occupancy`)
3. Replace with new entity ID (e.g., `binary_sensor.room_01_motion_occupancy`)
4. Save file
5. Check config: `hass --config /home/drewcifer/mnt/homeassistant-config --check-config`
6. Reload automations or restart HA

**Known Automation Impacts:**
- `follow_me_lighting.yaml` - Currently commented out, update mapping before re-enabling
- `room_fans.yaml` - Check for motion sensor references
- Climate packages - Likely no impact (use temp sensors, not motion)

### Phase 4: Validation & Testing

**Post-Rename Verification:**
1. Check Developer Tools > States for new entity IDs
2. Verify all renamed devices show correct state (on/off, temperature, etc.)
3. Test one automation per device type (motion trigger, light control, blind operation)
4. Monitor logs for entity_id not found errors
5. Verify dashboards display correctly

**Test Sequence:**
```bash
# Check motion sensor states
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/binary_sensor.room_01_motion_occupancy"
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/binary_sensor.room_14_motion_occupancy"
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/binary_sensor.room_10_motion_occupancy"

# Trigger motion and verify state change
# Walk in front of Living Room sensor, check state updates
```

### Phase 5: Commit & Document

**Final Steps:**
1. Git commit all changes: `~/homeassistant-config/tools/ha-github-sync.sh "Implement Zigbee naming convention - align motion sensors with room numbering"`
2. Update this document with actual blind locations
3. Document any edge cases discovered
4. Create quick reference card for future device additions

## Gotchas & Edge Cases

### Entity History Loss
**Issue:** Renaming in Zigbee2MQTT creates NEW entity IDs. Old entity history is not automatically transferred.

**Workaround:** Use entity customization to create aliases if historical continuity is critical:
```yaml
# In customize.yaml
binary_sensor.room_01_motion_occupancy:
  # Historical reference only - new name is canonical
  note: "Previously: binary_sensor.living_room_motion_zg204zm_occupancy"
```

### Automation Trigger Timing
**Issue:** Entity renames during HA restart may cause brief unavailability.

**Solution:** Perform renames during low-usage period (e.g., 2am). Motion-based automations will resume once entities appear.

### Template Sensor References
**Issue:** Template sensors using old entity IDs will fail until updated.

**Solution:** Search all template files for old entity IDs:
```bash
grep -r "living_room_motion" /home/drewcifer/homeassistant-config/templates/
grep -r "office_motion" /home/drewcifer/homeassistant-config/templates/
grep -r "bedroom_motion" /home/drewcifer/homeassistant-config/templates/
```

### Zigbee2MQTT Frontend
**Issue:** Zigbee2MQTT web UI (port 8099) caches old device names.

**Solution:** Hard refresh browser (Ctrl+Shift+R) after rename, or restart Zigbee2MQTT addon.

### Multi-Attribute Entities
**Issue:** ZG-204ZM sensors create multiple entities per device:
- `binary_sensor.room_XX_motion_occupancy` (main motion trigger)
- `sensor.room_XX_motion_illuminance` (light level)
- `sensor.room_XX_motion_presence` (advanced presence detection)

**Solution:** All sub-entities automatically inherit the friendly_name prefix. Verify all expected entities appear after rename.

## Scalability & Future-Proofing

### Adding Room 16+
If you expand beyond 15 rooms (e.g., finished basement, addition):

**Pattern:** Continue room_XX numbering with zero-padding:
- Room 16: `room_16_motion`, `room_16_temp`, `room_16_humidity`
- Room 17: `room_17_motion`, etc.

**Note:** You may need to add new temperature sensors (room_16_temp) if expanding beyond the current 15-sensor network.

### Multiple Devices Per Room
**Use descriptors to differentiate:**
- `room_04_light_cabinet` (under-cabinet)
- `room_04_light_overhead` (ceiling fixture)
- `room_04_light_accent` (strip lighting)

**Sorting:** Alphabetical sorting within room naturally groups devices:
```
room_04_light_accent
room_04_light_cabinet
room_04_light_overhead
room_04_motion
room_04_plug_coffeemaker
```

### Device Type Abbreviations
**For very long device names, use standard abbreviations:**
- motion (or mot)
- temperature (or temp)
- humidity (or hum)
- illuminance (or lux)
- blind (or shade)
- light (or lit)
- plug (or sw for switch)

**Recommendation:** Start with full names. Only abbreviate if entity IDs exceed 50 characters (rare with this pattern).

## Automation Pattern Examples

### Room-Based Motion Follow-Me Lighting
```yaml
automation:
  - id: motion_follow_me_room_01
    alias: "Motion: Living Room Follow-Me"
    trigger:
      - platform: state
        entity_id: binary_sensor.room_01_motion_occupancy
        to: 'on'
    condition:
      - condition: numeric_state
        entity_id: sensor.room_01_motion_illuminance
        below: 50
    action:
      - service: light.turn_on
        target:
          entity_id: light.living_room_recessed
        data:
          brightness_pct: 70
```

### Room Number Template Helper
```yaml
# Extract room number from entity ID for dynamic lookups
template:
  - sensor:
      - name: "Motion Triggered Room"
        state: >
          {% set motion_entity = trigger.entity_id %}
          {% if 'room_' in motion_entity %}
            {{ motion_entity.split('_')[1] | int }}
          {% else %}
            unknown
          {% endif %}
```

### Cross-Reference Temperature & Motion
```yaml
# Correlate motion and temperature in same room
automation:
  - id: motion_temp_correlation_example
    alias: "Example: Motion + Temp Correlation"
    trigger:
      - platform: state
        entity_id: binary_sensor.room_10_motion_occupancy
        to: 'on'
    action:
      - service: notify.mobile_app
        data:
          message: >
            Motion detected in Master Bedroom.
            Current temp: {{ states('sensor.temphumidsensor10_temperature') }}°F
```

## Quick Reference Card

### Device Name Format
```
[location]_[type]_[descriptor]

Room devices:    room_XX_[type]_[descriptor]
Special devices: [location]_[type]_[descriptor]
```

### Common Device Types
- motion, temp, humidity, illuminance
- light, blind, plug, switch, fan
- feeder, sensor, camera

### Room Number Lookup
```
1=Living, 2=Dining, 3=OutsideBackPorch, 4=Kitchen, 5=HalfBath
6=Rowan, 7=GuestBath, 8=GuestBed, 9=FoyerGarage, 10=MasterBed
11=MasterBath, 12=MasterCloset, 13=Laundry, 14=Office, 15=FoyerFront
```

### Example Names
```
room_01_motion          Living Room motion sensor
room_04_light_cabinet   Kitchen under-cabinet lighting
room_10_blind           Master Bedroom window blind
room_14_plug_lamp       Office desk lamp smart plug
garage_fan_drum         Garage drum fan
pet_feeder_dog          Dog automatic feeder
```

## Approval & Implementation

**Status:** PROPOSED - Awaiting user approval

**Required User Input:**
1. Confirm blind locations (Blinds 1, 2, 3 room assignments)
2. Identify unconfigured devices (IEEE 0x001788010bc24258, 0x000d6f000e25c8ea)
3. Review and approve naming convention
4. Authorize Phase 1 (validation) to begin

**Estimated Implementation Time:**
- Phase 1 (Validation): 30 minutes
- Phase 2 (Rename): 15 minutes
- Phase 3 (Automation Updates): 1-2 hours (depends on automation count)
- Phase 4 (Testing): 1 hour
- Phase 5 (Documentation): 15 minutes

**Total:** ~3-4 hours for complete migration

---

**Next Steps:**
1. Review this document for accuracy and completeness
2. Provide blind location information
3. Approve convention or request modifications
4. Schedule implementation window (low-usage period recommended)
