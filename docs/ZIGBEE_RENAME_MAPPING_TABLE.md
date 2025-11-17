# Zigbee Device Rename Mapping Table

**Quick Reference for Entity ID Changes**

## Motion Sensors (ZG-204ZM)

### Living Room Motion (Room 01)

| Entity Type | Old Entity ID | New Entity ID |
|-------------|---------------|---------------|
| Occupancy (Motion) | `binary_sensor.living_room_motion_zg204zm_occupancy` | `binary_sensor.room_01_motion_occupancy` |
| Illuminance (Lux) | `sensor.living_room_motion_zg204zm_illuminance` | `sensor.room_01_motion_illuminance` |
| Illuminance (Lux) | `sensor.living_room_motion_zg204zm_illuminance_lux` | `sensor.room_01_motion_illuminance_lux` |
| Presence | `binary_sensor.living_room_motion_zg204zm_presence` | `binary_sensor.room_01_motion_presence` |
| Link Quality | `sensor.living_room_motion_zg204zm_linkquality` | `sensor.room_01_motion_linkquality` |

**Zigbee2MQTT Config Change:**
```yaml
'0x00158d00063e259b':
  friendly_name: room_01_motion  # Was: Living Room Motion ZG204ZM
```

### Office Motion (Room 14)

| Entity Type | Old Entity ID | New Entity ID |
|-------------|---------------|---------------|
| Occupancy (Motion) | `binary_sensor.office_motion_zg204zm_occupancy` | `binary_sensor.room_14_motion_occupancy` |
| Illuminance (Lux) | `sensor.office_motion_zg204zm_illuminance` | `sensor.room_14_motion_illuminance` |
| Illuminance (Lux) | `sensor.office_motion_zg204zm_illuminance_lux` | `sensor.room_14_motion_illuminance_lux` |
| Presence | `binary_sensor.office_motion_zg204zm_presence` | `binary_sensor.room_14_motion_presence` |
| Link Quality | `sensor.office_motion_zg204zm_linkquality` | `sensor.room_14_motion_linkquality` |

**Zigbee2MQTT Config Change:**
```yaml
'0x00158d0005475020':
  friendly_name: room_14_motion  # Was: Office Motion ZG204ZM
```

### Master Bedroom Motion (Room 10)

| Entity Type | Old Entity ID | New Entity ID |
|-------------|---------------|---------------|
| Occupancy (Motion) | `binary_sensor.bedroom_motion_zg204zm_occupancy` | `binary_sensor.room_10_motion_occupancy` |
| Illuminance (Lux) | `sensor.bedroom_motion_zg204zm_illuminance` | `sensor.room_10_motion_illuminance` |
| Illuminance (Lux) | `sensor.bedroom_motion_zg204zm_illuminance_lux` | `sensor.room_10_motion_illuminance_lux` |
| Presence | `binary_sensor.bedroom_motion_zg204zm_presence` | `binary_sensor.room_10_motion_presence` |
| Link Quality | `sensor.bedroom_motion_zg204zm_linkquality` | `sensor.room_10_motion_linkquality` |

**Zigbee2MQTT Config Change:**
```yaml
'0x00158d0006401133':
  friendly_name: room_10_motion  # Was: Bedroom Motion ZG204ZM
```

## Blinds (Location TBD - Pending User Input)

### Blinds 1

| Entity Type | Old Entity ID | New Entity ID |
|-------------|---------------|---------------|
| Cover | `cover.blinds_1` | `cover.room_XX_blind` |
| Position | `sensor.blinds_1_position` | `sensor.room_XX_blind_position` |
| Link Quality | `sensor.blinds_1_linkquality` | `sensor.room_XX_blind_linkquality` |

**Zigbee2MQTT Config Change:**
```yaml
'0xb4e3f9fffe3c3fef':
  friendly_name: room_XX_blind  # Was: Blinds 1 (XX = room number)
```

### Blinds 2

| Entity Type | Old Entity ID | New Entity ID |
|-------------|---------------|---------------|
| Cover | `cover.blinds_2` | `cover.room_XX_blind` |
| Position | `sensor.blinds_2_position` | `sensor.room_XX_blind_position` |
| Link Quality | `sensor.blinds_2_linkquality` | `sensor.room_XX_blind_linkquality` |

**Zigbee2MQTT Config Change:**
```yaml
'0xcc86ecfffefe42e4':
  friendly_name: room_XX_blind  # Was: Blinds 2 (XX = room number)
```

### Blinds 3

| Entity Type | Old Entity ID | New Entity ID |
|-------------|---------------|---------------|
| Cover | `cover.blinds_3` | `cover.room_XX_blind` |
| Position | `sensor.blinds_3_position` | `sensor.room_XX_blind_position` |
| Link Quality | `sensor.blinds_3_linkquality` | `sensor.room_XX_blind_linkquality` |

**Zigbee2MQTT Config Change:**
```yaml
'0xcc86ecfffefe360a':
  friendly_name: room_XX_blind  # Was: Blinds 3 (XX = room number)
```

## Smart Plugs

### Office Desk Lamp Plug (Room 14)

| Entity Type | Old Entity ID | New Entity ID |
|-------------|---------------|---------------|
| Switch | `switch.smart_outlet_office_lamp` | `switch.room_14_plug_lamp` |
| Power | `sensor.smart_outlet_office_lamp_power` | `sensor.room_14_plug_lamp_power` |
| Energy | `sensor.smart_outlet_office_lamp_energy` | `sensor.room_14_plug_lamp_energy` |
| Link Quality | `sensor.smart_outlet_office_lamp_linkquality` | `sensor.room_14_plug_lamp_linkquality` |

**Zigbee2MQTT Config Change:**
```yaml
'0x000d6f000ca4299c':
  friendly_name: room_14_plug_lamp  # Was: Smart Outlet Office Lamp
```

### Console Lights Plug (Living Room Area)

| Entity Type | Old Entity ID | New Entity ID |
|-------------|---------------|---------------|
| Switch | `switch.smart_plug_console_lights` | `switch.console_plug_lights` |
| Power | `sensor.smart_plug_console_lights_power` | `sensor.console_plug_lights_power` |
| Energy | `sensor.smart_plug_console_lights_energy` | `sensor.console_plug_lights_energy` |
| Link Quality | `sensor.smart_plug_console_lights_linkquality` | `sensor.console_plug_lights_linkquality` |

**Zigbee2MQTT Config Change:**
```yaml
'0x000d6f000b4f8d74':
  friendly_name: console_plug_lights  # Was: Smart Plug Console Lights
```

## Lights

### Kitchen Under-Cabinet Lighting (Room 04)

| Entity Type | Old Entity ID | New Entity ID |
|-------------|---------------|---------------|
| Light | `light.under_cabinet_lighting` | `light.room_04_light_cabinet` |
| Brightness | `sensor.under_cabinet_lighting_brightness` | `sensor.room_04_light_cabinet_brightness` |
| Link Quality | `sensor.under_cabinet_lighting_linkquality` | `sensor.room_04_light_cabinet_linkquality` |

**Zigbee2MQTT Config Change:**
```yaml
'0xa4c138d6a4329383':
  friendly_name: room_04_light_cabinet  # Was: Under Cabinet Lighting
```

### Console Light 1 (KEEP AS-IS)

| Entity Type | Entity ID | Status |
|-------------|-----------|--------|
| Light | `light.console_light_1` | No change - already clear |

**Zigbee2MQTT Config Change:**
```yaml
'0x0017880102726027':
  friendly_name: console_light_1  # No change
```

### Console Light 2 (KEEP AS-IS)

| Entity Type | Entity ID | Status |
|-------------|-----------|--------|
| Light | `light.console_light_2` | No change - already clear |

**Zigbee2MQTT Config Change:**
```yaml
'0x0017880102726055':
  friendly_name: console_light_2  # No change
```

## Pet Feeders (KEEP AS-IS)

### Dog Feeder

| Entity Type | Entity ID | Status |
|-------------|-----------|--------|
| Switch/Sensor | `switch.dog_feeder` / `sensor.dog_feeder_*` | No change - already clear |

**Zigbee2MQTT Config Change:**
```yaml
'0x54ef4410007c5f3f':
  friendly_name: dog_feeder  # No change
```

### Cat Feeder

| Entity Type | Entity ID | Status |
|-------------|-----------|--------|
| Switch/Sensor | `switch.cat_feeder` / `sensor.cat_feeder_*` | No change - already clear |

**Zigbee2MQTT Config Change:**
```yaml
'0x54ef4410007c5b16':
  friendly_name: cat_feeder  # No change
```

## Garage Equipment (KEEP AS-IS)

### Garage Drum Fan

| Entity Type | Entity ID | Status |
|-------------|-----------|--------|
| Fan/Switch | `fan.garage_drum_fan` / `switch.garage_drum_fan` | No change - already clear |

**Zigbee2MQTT Config Change:**
```yaml
'0x000d6f000b2d8e70':
  friendly_name: garage_drum_fan  # No change
```

## Unconfigured Devices (Pending Identification)

### Device 1

| IEEE Address | Current Name | Recommended Action |
|--------------|--------------|-------------------|
| `0x001788010bc24258` | (IEEE address) | Identify device, then name per convention |

### Device 2

| IEEE Address | Current Name | Recommended Action |
|--------------|--------------|-------------------|
| `0x000d6f000e25c8ea` | (IEEE address) | Identify device, then name per convention |

## Find/Replace Commands for Automation Updates

Use these commands to update automation files after rename:

```bash
# Motion Sensors
find /home/drewcifer/homeassistant-config -type f -name "*.yaml" -exec sed -i 's/binary_sensor\.living_room_motion_zg204zm_occupancy/binary_sensor.room_01_motion_occupancy/g' {} +
find /home/drewcifer/homeassistant-config -type f -name "*.yaml" -exec sed -i 's/binary_sensor\.office_motion_zg204zm_occupancy/binary_sensor.room_14_motion_occupancy/g' {} +
find /home/drewcifer/homeassistant-config -type f -name "*.yaml" -exec sed -i 's/binary_sensor\.bedroom_motion_zg204zm_occupancy/binary_sensor.room_10_motion_occupancy/g' {} +

# Illuminance sensors
find /home/drewcifer/homeassistant-config -type f -name "*.yaml" -exec sed -i 's/sensor\.living_room_motion_zg204zm_illuminance/sensor.room_01_motion_illuminance/g' {} +
find /home/drewcifer/homeassistant-config -type f -name "*.yaml" -exec sed -i 's/sensor\.office_motion_zg204zm_illuminance/sensor.room_14_motion_illuminance/g' {} +
find /home/drewcifer/homeassistant-config -type f -name "*.yaml" -exec sed -i 's/sensor\.bedroom_motion_zg204zm_illuminance/sensor.room_10_motion_illuminance/g' {} +

# Smart Plugs
find /home/drewcifer/homeassistant-config -type f -name "*.yaml" -exec sed -i 's/switch\.smart_outlet_office_lamp/switch.room_14_plug_lamp/g' {} +
find /home/drewcifer/homeassistant-config -type f -name "*.yaml" -exec sed -i 's/switch\.smart_plug_console_lights/switch.console_plug_lights/g' {} +

# Lights
find /home/drewcifer/homeassistant-config -type f -name "*.yaml" -exec sed -i 's/light\.under_cabinet_lighting/light.room_04_light_cabinet/g' {} +
```

**IMPORTANT:** Test these commands on a backup first! Review changes with `git diff` before committing.

## Verification Commands

After rename, use these commands to verify new entities exist:

```bash
# Motion sensors
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/binary_sensor.room_01_motion_occupancy" | jq .
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/binary_sensor.room_14_motion_occupancy" | jq .
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/binary_sensor.room_10_motion_occupancy" | jq .

# Illuminance
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.room_01_motion_illuminance" | jq .
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.room_14_motion_illuminance" | jq .
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/sensor.room_10_motion_illuminance" | jq .

# Plugs and lights
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/switch.room_14_plug_lamp" | jq .
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/switch.console_plug_lights" | jq .
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/light.room_04_light_cabinet" | jq .

# List all new room_XX entities
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states" | jq '.[] | select(.entity_id | startswith("binary_sensor.room_") or startswith("sensor.room_") or startswith("switch.room_") or startswith("light.room_") or startswith("cover.room_")) | .entity_id'
```

## Summary Statistics

| Device Category | Devices to Rename | Entities Affected (Est.) | Keep As-Is |
|----------------|-------------------|-------------------------|------------|
| Motion Sensors | 3 | ~15 entities | 0 |
| Blinds | 3 | ~9 entities | 0 |
| Smart Plugs | 2 | ~8 entities | 0 |
| Lights | 1 | ~3 entities | 2 |
| Pet Feeders | 0 | 0 | 2 |
| Garage Equipment | 0 | 0 | 1 |
| Unconfigured | 2 | TBD | 0 |
| **TOTAL** | **11 devices** | **~35 entities** | **5 devices** |

**Temperature/Humidity Sensors:** 15 devices (temphumidsensor1-15) - **NO CHANGE** per convention

---

**Last Updated:** 2025-10-06
**Status:** Ready for Implementation (pending blind location data)
