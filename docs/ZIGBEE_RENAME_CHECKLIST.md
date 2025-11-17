# Zigbee Device Rename Implementation Checklist

**Project:** Align Zigbee device naming with established room numbering system
**Created:** 2025-10-06
**Status:** Ready for User Approval

## Pre-Implementation Requirements

### Information Needed from User

- [ ] **Blind Locations** - Which rooms have Blinds 1, 2, and 3?
  - Blinds 1: Room # _____
  - Blinds 2: Room # _____
  - Blinds 3: Room # _____

- [ ] **Unconfigured Device Identification**
  - Device `0x001788010bc24258`: What is this? _________________
  - Device `0x000d6f000e25c8ea`: What is this? _________________

- [ ] **Implementation Window** - When can you tolerate brief HA downtime?
  - Preferred date/time: _____________________
  - Backup date/time: _____________________

### Convention Approval

- [ ] Review `/docs/ZIGBEE_NAMING_CONVENTION.md`
- [ ] Approve naming pattern: `room_XX_[type]_[descriptor]`
- [ ] Approve keeping `temphumidsensor1-15` as-is (no rename)
- [ ] Confirm room number mapping is correct

## Phase 1: Pre-Migration Validation

### Backup & Safety

- [ ] Create full Home Assistant backup via UI (Settings > System > Backups)
- [ ] Git commit current state:
  ```bash
  cd /home/drewcifer/homeassistant-config
  git add .
  git commit -m "Pre-Zigbee rename backup - $(date +%Y%m%d)"
  ~/homeassistant-config/tools/ha-github-sync.sh "Pre-Zigbee rename backup"
  ```
- [ ] Backup Zigbee2MQTT configuration:
  ```bash
  cp zigbee2mqtt/configuration.yaml zigbee2mqtt/configuration.yaml.backup.$(date +%Y%m%d)
  ```

### Automation Impact Assessment

- [ ] List all automations using motion sensors:
  ```bash
  grep -r "living_room_motion\|office_motion\|bedroom_motion" /home/drewcifer/homeassistant-config/automations/
  ```
- [ ] List all automations using blinds:
  ```bash
  grep -r "blinds_1\|blinds_2\|blinds_3" /home/drewcifer/homeassistant-config/automations/
  ```
- [ ] List all automations using smart plugs/lights:
  ```bash
  grep -r "smart_outlet\|smart_plug\|console_light\|under_cabinet" /home/drewcifer/homeassistant-config/automations/
  ```
- [ ] Document findings in `/docs/automation_impact_assessment.txt`

### Template Sensor Assessment

- [ ] Check template files for device references:
  ```bash
  grep -r "living_room_motion\|office_motion\|bedroom_motion" /home/drewcifer/homeassistant-config/templates/
  ```
- [ ] Document findings in `/docs/template_impact_assessment.txt`

### Dashboard Assessment

- [ ] Check dashboards for device references:
  ```bash
  grep -r "living_room_motion\|office_motion\|bedroom_motion" /home/drewcifer/homeassistant-config/ui-lovelace*.yaml
  ```
- [ ] Document findings in `/docs/dashboard_impact_assessment.txt`

## Phase 2: Rename Execution

### Prepare Rename Configuration

- [ ] Create new Zigbee2MQTT config with renamed devices:
  ```bash
  cd /home/drewcifer/homeassistant-config
  # Edit zigbee2mqtt/configuration.yaml with new friendly_name values
  ```

- [ ] **Motion Sensors (3 devices):**
  - [ ] `Living Room Motion ZG204ZM` → `room_01_motion`
  - [ ] `Office Motion ZG204ZM` → `room_14_motion`
  - [ ] `Bedroom Motion ZG204ZM` → `room_10_motion`

- [ ] **Blinds (3 devices - after room confirmation):**
  - [ ] `Blinds 1` → `room_XX_blind`
  - [ ] `Blinds 2` → `room_XX_blind`
  - [ ] `Blinds 3` → `room_XX_blind`

- [ ] **Smart Plugs (2 devices):**
  - [ ] `Smart Outlet Office Lamp` → `room_14_plug_lamp`
  - [ ] `Smart Plug Console Lights` → `console_plug_lights`

- [ ] **Lights (3 devices):**
  - [ ] `Under Cabinet Lighting` → `room_04_light_cabinet`
  - [ ] `Console Light 1` → `console_light_1` (keep as-is)
  - [ ] `Console Light 2` → `console_light_2` (keep as-is)

- [ ] **Other Devices (keep as-is):**
  - [ ] `Dog Feeder` - no change
  - [ ] `Cat Feeder` - no change
  - [ ] `Garage Drum Fan` - no change

### Execute Rename

- [ ] Verify current HA status is healthy
- [ ] Stop Home Assistant:
  ```bash
  curl -X POST -H "Authorization: Bearer $HA_TOKEN" -H "Content-Type: application/json" http://192.168.88.125:8123/api/services/homeassistant/stop
  ```
- [ ] Edit `zigbee2mqtt/configuration.yaml` with new friendly names
- [ ] Restart Zigbee2MQTT addon via Supervisor UI
- [ ] Wait 2 minutes for Zigbee2MQTT to stabilize
- [ ] Start Home Assistant:
  ```bash
  # HA will auto-start, or manually start via Supervisor UI
  ```
- [ ] Wait 3 minutes for HA to fully start

### Verify New Entities

- [ ] Check Developer Tools > States for new entity IDs:
  - [ ] `binary_sensor.room_01_motion_occupancy`
  - [ ] `binary_sensor.room_14_motion_occupancy`
  - [ ] `binary_sensor.room_10_motion_occupancy`
  - [ ] `sensor.room_01_motion_illuminance`
  - [ ] `sensor.room_14_motion_illuminance`
  - [ ] `sensor.room_10_motion_illuminance`
  - [ ] `cover.room_XX_blind` (for each blind)
  - [ ] `switch.room_14_plug_lamp`
  - [ ] `switch.console_plug_lights`
  - [ ] `light.room_04_light_cabinet`

- [ ] Verify old entities are marked "unavailable" (expected)

## Phase 3: Automation Updates

### Motion Sensor Automation Updates

- [ ] Update `/automations/follow_me_lighting.yaml`:
  - [ ] Replace `binary_sensor.presencesensor1` with `binary_sensor.room_01_motion_occupancy`
  - [ ] Update mapping dictionary with new entity IDs
  - [ ] Uncomment automation if ready to activate

- [ ] Update `/automations/room_fans.yaml` (if references motion sensors)

- [ ] Update any climate package references (if any)

### Blind Automation Updates

- [ ] Search for blind references:
  ```bash
  grep -r "blinds_1\|blinds_2\|blinds_3" /home/drewcifer/homeassistant-config/
  ```
- [ ] Update all found references to new `room_XX_blind` format

### Light/Plug Automation Updates

- [ ] Update under-cabinet lighting references to `light.room_04_light_cabinet`
- [ ] Update office lamp references to `switch.room_14_plug_lamp`

### Configuration Check

- [ ] Run config check after all updates:
  ```bash
  hass --config /home/drewcifer/mnt/homeassistant-config --check-config
  ```
- [ ] Fix any errors reported
- [ ] Re-run until clean

## Phase 4: Testing & Validation

### Motion Sensor Testing

- [ ] Trigger motion in Living Room, verify automation response:
  ```bash
  curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/binary_sensor.room_01_motion_occupancy"
  ```
- [ ] Trigger motion in Office, verify automation response
- [ ] Trigger motion in Master Bedroom, verify automation response
- [ ] Check illuminance sensors are updating
- [ ] Verify presence detection (if used)

### Blind Testing

- [ ] Open/close each blind via UI
- [ ] Verify position feedback works
- [ ] Test any blind automation triggers

### Light/Plug Testing

- [ ] Toggle under-cabinet lighting via UI
- [ ] Toggle office lamp plug via UI
- [ ] Toggle console lights plug via UI
- [ ] Verify state updates correctly

### Log Monitoring

- [ ] Monitor HA logs for errors:
  ```bash
  tail -f /home/drewcifer/mnt/homeassistant-config/home-assistant.log | grep -i error
  ```
- [ ] Check for "entity_id not found" errors
- [ ] Check for template rendering errors
- [ ] Fix any issues found

### Dashboard Verification

- [ ] Open Climate Control Center v2
- [ ] Verify all cards display correctly
- [ ] Check for missing entity warnings
- [ ] Open other dashboards, verify no broken entity references

## Phase 5: Documentation & Commit

### Update Documentation

- [ ] Update `/docs/ZIGBEE_NAMING_CONVENTION.md` with actual blind locations
- [ ] Document any discovered edge cases
- [ ] Update CLAUDE.md presence sensor room mapping if needed

### Git Commit

- [ ] Review all changed files:
  ```bash
  cd /home/drewcifer/homeassistant-config
  git status
  git diff zigbee2mqtt/configuration.yaml
  git diff automations/
  ```
- [ ] Commit changes:
  ```bash
  git add .
  git commit -m "Implement Zigbee naming convention - align devices with room numbering

  - Rename 3 motion sensors to room_XX_motion format
  - Rename blinds, plugs, lights to match convention
  - Update automations to use new entity IDs
  - Verified all devices operational post-rename"
  ```
- [ ] Sync to GitHub:
  ```bash
  ~/homeassistant-config/tools/ha-github-sync.sh "Implement Zigbee naming convention"
  ```

### Create Quick Reference

- [ ] Create `/docs/zigbee_device_quick_reference.txt` with room-to-device mapping
- [ ] Print or save for easy access during future device additions

## Rollback Plan (If Issues Occur)

### Emergency Rollback Steps

1. **Stop Home Assistant**
   ```bash
   curl -X POST -H "Authorization: Bearer $HA_TOKEN" -H "Content-Type: application/json" http://192.168.88.125:8123/api/services/homeassistant/stop
   ```

2. **Restore Zigbee2MQTT Config**
   ```bash
   cd /home/drewcifer/homeassistant-config
   cp zigbee2mqtt/configuration.yaml.backup.YYYYMMDD zigbee2mqtt/configuration.yaml
   ```

3. **Restart Zigbee2MQTT** (via Supervisor UI)

4. **Restore Automation Files** (if updated)
   ```bash
   git checkout HEAD -- automations/
   ```

5. **Start Home Assistant**

6. **Verify Old Entity IDs Return**
   - Check Developer Tools > States
   - Verify automations work with old names

7. **Document Rollback Reason**
   - What went wrong?
   - What needs to be fixed before retry?

## Success Criteria

Migration is considered successful when:

- [ ] All 3 motion sensors respond with new entity IDs
- [ ] All blinds operate correctly with new names
- [ ] All lights and plugs respond with new entity IDs
- [ ] No "entity_id not found" errors in logs
- [ ] At least one automation per device type tested successfully
- [ ] Dashboards display correctly (no broken entity references)
- [ ] All changes committed to GitHub
- [ ] Documentation updated with findings

## Post-Implementation Notes

**Lessons Learned:**
- (Document any surprises or gotchas discovered)

**Future Improvements:**
- (Note any opportunities for optimization)

**Next Steps:**
- Add remaining 12 motion sensors using room_XX_motion pattern
- Consider renaming other device types if pattern proves successful

---

**Implementation Date:** _________________
**Completed By:** _________________
**Total Time:** _________________
**Issues Encountered:** _________________
**Resolution:** _________________
