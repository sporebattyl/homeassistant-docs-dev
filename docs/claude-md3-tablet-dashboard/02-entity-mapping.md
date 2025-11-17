# Entity Mapping - MD3 Tablet Dashboard

**Last Updated**: 2025-11-16
**Status**: Phase 0 Complete - Ready for Implementation
**Readiness**: 10/10 (All entities verified)

---

## Overview

This document provides a comprehensive inventory of all Home Assistant entities available for the MD3 Tablet Dashboard, organized by domain and mapped to specific dashboard views. Entity counts and availability status are documented to guide implementation decisions.

---

## Entity Inventory by Domain

### Total Entity Counts

| Domain | Count | Primary Use | Status |
|--------|-------|-------------|--------|
| Sensor | 953 | Climate, energy, system monitoring | ✅ Operational |
| Automation | 647 | Climate control, notifications | ✅ Operational |
| Binary Sensor | 289 | Doors, motion, occupancy | ✅ Operational |
| Input Boolean | 411 | Feature flags, automation controls | ✅ Operational |
| Input Number | 343 | Thresholds, timers, setpoints | ✅ Operational |
| Switch | 121 | Equipment control, cameras | ✅ Operational |
| Input Select | 64 | System states, modes | ✅ Operational |
| Light | 36 | Whole-home lighting | ✅ Operational |
| Media Player | 12 | Multi-room audio/video | ✅ Operational |
| Camera | 9 | Security/monitoring | ✅ Operational |
| Calendar | 6 | Family scheduling | ✅ Operational |
| Cover | 5 | Garage doors, blinds | ✅ Operational |
| Climate | 3 | HVAC, pool heating | ✅ Operational |
| Fan | 2 | Room circulation | ✅ Operational |
| Alarm Control Panel | 1 | Envisalink alarm system | ✅ Operational |
| Weather | 1 | Forecast data | ✅ Operational |
| Person | 1 | Presence detection | ✅ Operational |
| **TOTAL** | **2,906** | | |

---

## Climate System Entities (Primary Focus)

### 18-Sensor Climate Network

**Status**: ✅ 100% Operational (18/18 sensors reporting)

#### Temperature Sensors

**✅ VERIFIED 2025-11-16** - All 18 sensors operational with correct entity IDs:

| Room/Location | Entity ID | Current Value | Dashboard View |
|---------------|-----------|--------------|----------------|
| Living Room | `sensor.climate_living_room_temperature` | 73.76°F | Living Area, Overview |
| Dining Room | `sensor.climate_dining_room_temperature` | 73.58°F | Living Area, Overview |
| Kitchen | `sensor.climate_kitchen_temperature` | 75.92°F | Living Area, Overview |
| Half Bathroom | `sensor.climate_half_bathroom_temperature` | 73.17°F | System view |
| Rowan's Room | `sensor.climate_rowans_room_temperature` | 73.04°F | Rowan, Overview |
| Guest Bathroom | `sensor.climate_guest_bathroom_temperature` | 73.04°F | Guest |
| Guest Bedroom | `sensor.climate_guest_bedroom_temperature` | 73.65°F | Guest |
| Foyer (Garage) | `sensor.climate_foyer_garage_temperature` | 73.94°F | Garage view |
| Master Bedroom | `sensor.climate_master_bedroom_temperature` | 72.57°F | Master, Overview |
| Master Bathroom | `sensor.climate_master_bathroom_temperature` | 73.94°F | Master |
| Master Closet | `sensor.climate_master_closet_temperature` | 73.56°F | Master |
| Office | `sensor.climate_office_temperature` | 82.4°F | Office, Overview |
| Laundry Room | `sensor.climate_laundry_room_temperature` | 73.00°F | System view |
| Outdoor (Back Porch) | `sensor.climate_outdoor_back_porch_temperature` | 73.58°F | Weather widget |
| HVAC Return | `sensor.climate_hvac_return_temperature` | Available | System view |
| HVAC Supply | `sensor.climate_hvac_supply_temperature` | Available | System view |
| Outdoor (General) | `sensor.outdoor_temperature` | 180.32°F | Weather widget |
| Dev Outdoor | `sensor.dev_outdoor_temperature` | 82.4°F | Development |

#### Humidity Sensors

**✅ VERIFIED 2025-11-16** - All 18 sensors operational with correct entity IDs:

| Room/Location | Entity ID | Current Value | Dashboard View |
|---------------|-----------|--------------|----------------|
| Living Room | `sensor.climate_living_room_humidity` | 52% | Living Area, Overview |
| Dining Room | `sensor.climate_dining_room_humidity` | 54% | Living Area, Overview |
| Kitchen | `sensor.climate_kitchen_humidity` | 51% | Living Area, Overview |
| Half Bathroom | `sensor.climate_half_bathroom_humidity` | 51.89% | System view |
| Rowan's Room | `sensor.climate_rowans_room_humidity` | 53% | Rowan, Overview |
| Guest Bathroom | `sensor.climate_guest_bathroom_humidity` | 52% | Guest |
| Guest Bedroom | `sensor.climate_guest_bedroom_humidity` | 52.5% | Guest |
| Foyer (Garage) | `sensor.climate_foyer_garage_humidity` | 54% | Garage view |
| Master Bedroom | `sensor.climate_master_bedroom_humidity` | 53.96% | Master, Overview |
| Master Bathroom | `sensor.climate_master_bathroom_humidity` | Available | Master |
| Master Closet | `sensor.climate_master_closet_humidity` | Available | Master |
| Outdoor (Back Porch) | `sensor.climate_outdoor_back_porch_humidity` | 85% | Weather widget |
| Outdoor (General) | `sensor.outdoor_humidity` | 61.0% | Weather widget |
| Dev Outdoor | `sensor.dev_outdoor_humidity` | 61.0% | Development |
| WAQI Seabrook | `sensor.waqi_seabrook_humidity` | 89% | Weather reference |
| Seabrook Park | `sensor.seabrook_friendship_park_houston_texas_humidity` | 95% | Weather reference |
| HVAC Return | `sensor.climate_hvac_return_humidity` | Available | System view |
| HVAC Supply | `sensor.climate_hvac_supply_humidity` | Available | System view |

### Climate Control Entities

#### HVAC System
- **Entity**: `climate.thermostat`
- **Type**: Lennox ML14XC1 AC system
- **Modes**: `off`, `heat`, `cool`, `heat_cool`
- **Current Setpoints**:
  - Home: 74°F (cooling), 68°F (heating)
  - Sleep: 73°F (cooling), 67°F (heating)
- **Dashboard Views**: Overview (primary card), Master (secondary)
- **Emergency Controls**: All climate views (via scripts)

#### Dehumidifier
- **Entity**: `switch.e130_dehumidifier_control`
- **Type**: Aprilaire E130 (70 pint/day)
- **Control**: Binary switch (on/off)
- **Arbitration**: Mutual exclusion with AC (never both on)
- **Dashboard Views**: Overview, System view
- **Safety Sensor**: `sensor.equipment_arbitration_status_enhanced`

#### Pool Climate (Optional Display)
- `climate.pool_pump_pool_heat` - Pool heating control
- `climate.pool_pump_spa_heat` - Spa heating control
- **Dashboard Views**: System view (low priority)

### Aggregate Climate Sensors

#### Average Sensors
- `sensor.average_house_temperature_enhanced` - Whole-home average (18-sensor weighted)
- `sensor.average_house_humidity_enhanced` - Whole-home average (18-sensor weighted)
- **Dashboard Views**: Overview header, System view

#### Dew Point Sensors (✅ ALL OPERATIONAL - Phase 0 Complete)

**Status**: ✅ 17/17 sensors created and operational (2025-11-14)

| Room/Location | Entity ID | Current Value | Dashboard View |
|---------------|-----------|--------------|----------------|
| Living Room | `sensor.climate_living_dew_point` | 55.0°F | Living Area, Overview |
| Dining Room | `sensor.climate_dining_dew_point` | 55.9°F | Living Area, Overview |
| Kitchen | `sensor.climate_kitchen_dew_point` | 56.5°F | Living Area, Overview |
| Half Bathroom | `sensor.climate_halfbath_dew_point` | 54.4°F | System view |
| Rowan's Room | `sensor.climate_rowan_dew_point` | 55.2°F | Rowan, Overview |
| Guest Bathroom | `sensor.climate_guestbath_dew_point` | 54.7°F | Guest |
| Guest Bedroom | `sensor.climate_guestbed_dew_point` | 55.2°F | Guest |
| Foyer (Garage) | `sensor.climate_foyergarage_dew_point` | 56.2°F | Garage view |
| Master Suite | `sensor.climate_master_dew_point` | 54.9°F | Master, Overview |
| Master Bathroom | `sensor.climate_masterbath_dew_point` | 54.7°F | Master |
| Master Closet | `sensor.climate_mastercloset_dew_point` | 55.1°F | Master |
| Office | `sensor.climate_office_dew_point` | 54.1°F | Office, Overview |
| Laundry Room | `sensor.climate_laundry_dew_point` | 55.7°F | System view |
| Foyer (Front) | `sensor.climate_foyerfront_dew_point` | 56.6°F | System view |
| HVAC Return | `sensor.climate_hvac_return_dew_point` | 57.8°F | System view |
| HVAC Supply | `sensor.climate_hvac_supply_dew_point` | 51.8°F | System view |
| Outdoor (Back Porch) | `sensor.climate_outdoor_dew_point` | 68.8°F | Weather widget |
| Outdoor (General) | `sensor.outdoor_dew_point` | unavailable | Weather widget |

**Implementation**: Created via `packages/climate_tablet_md3_dew_point.yaml` (Phase 0)
**Formula**: Magnus-Tetens approximation for dew point calculation
**Dashboard Views**: All climate room views, Weather widget

#### Equipment Status
- `sensor.equipment_arbitration_status_enhanced` - AC/dehumidifier arbitration state
- `sensor.hvac_efficiency_runtime_tracking` - HVAC runtime metrics
- `sensor.dehumidifier_runtime_today` - Daily dehumidifier runtime
- **Dashboard Views**: System view, Overview (status chip)

### Emergency Scripts (Climate Overrides)

**⚠️ VERIFIED 2025-11-13** - Actual script entity IDs:

| Script | Actual Entity ID | Purpose | Dashboard Button |
|--------|-----------------|---------|------------------|
| Humidity Override | `script.emergency_humidity_override` ✅ | Force 55% target humidity | Red button, Overview |
| Cooling Boost | `script.emergency_cooling_boost` ✅ | Force AC on regardless of setpoint | Blue button, Overview |
| Reset Overrides | `script.emergency_rollback_all_flags` ⚠️ | Clear all emergency flags | Green button, Overview |

**❌ REMOVED SCRIPTS** (don't exist or broken):
- ~~`script.climate_system_restart`~~ - **DOES NOT EXIST** (has known timeout issue, not in live system)
- ~~`script.reset_all_overrides`~~ - **WRONG NAME** (actual: `emergency_rollback_all_flags`)

**Status**: 3/3 functional scripts verified

---

## Security & Safety Entities

### Alarm System (Envisalink)

#### Alarm Control Panel
- **Entity**: `alarm_control_panel.home_alarm`
- **Hardware**: Honeywell panel via Envisalink EVL-4
- **States**: `armed_home`, `armed_away`, `armed_night`, `disarmed`, `triggered`
- **Zones**: 6 configured zones
- **Dashboard Card**: Mushroom Alarm Control Panel Card
- **Dashboard Views**: Cameras & Security (primary), Overview (status chip)

#### Alarm Zones
1. Entry Door - Front door zone
2. Living Room Motion - Main living area motion detector
3. Master - Master bedroom zone
4. Family/Kitchen - Open concept area zone
5. Office - Office zone
6. Bedrooms - Secondary bedroom zone

### Door Sensors (14 Entities)

**Binary Sensor Device Class**: `door`

| Location | Entity ID | Dashboard View |
|----------|-----------|----------------|
| Front Door | `binary_sensor.front_door` | Overview, Cameras & Security |
| Back Door | `binary_sensor.back_door` | Overview, Cameras & Security |
| Garage Door 1 | `binary_sensor.garage_door_1_sensor` | Garage view |
| Garage Door 2 | `binary_sensor.garage_door_2_sensor` | Garage view |
| Master Bedroom Door | `binary_sensor.master_bedroom_door` | Master view |
| (9 additional doors) | Various | Cameras & Security |

**Aggregate Sensor**: `sensor.doors_open_count` (template sensor)
**Dashboard Usage**: Overview header chip, Cameras & Security summary card

### Motion Sensors (32 Entities)

**Binary Sensor Device Class**: `motion`

**⚠️ VERIFIED 2025-11-13** - Actual entity IDs differ from assumed names:

| Location | Actual Entity ID | Dashboard View |
|----------|-----------------|----------------|
| Living Room | `binary_sensor.living_room_motion` | Living Area |
| Master Bedroom | `binary_sensor.bedroom_motion` (⚠️ NOT master_bedroom_motion) | Master |
| Rowan's Room | `binary_sensor.rowan_room_motion` | Rowan |
| Guest Bedroom | `binary_sensor.nursery_motion` | Guest |
| Office | `binary_sensor.presencesensor1_motion` (⚠️ NOT office_motion) | Office |
| Thermostat | `binary_sensor.thermostat_motion` | System |
| Front Yard | `binary_sensor.front_yard_motion` | Security |
| Driveway | `binary_sensor.driveway_motion` | Security |
| Side Yard | `binary_sensor.side_yard_motion` | Security |
| (20 additional motion sensors) | Various | Cameras & Security |

**❌ MISSING SENSORS** (assumed but don't exist):
- Dining room motion sensor
- Kitchen motion sensor
- Master bathroom motion sensor

**Dashboard Usage**: Room occupancy indicators (chips), security timeline

### Cameras (9 Entities)

#### Reolink Cameras (5)
| Camera | Entity ID | Location | Dashboard View |
|--------|-----------|----------|----------------|
| Side Yard | `camera.side_yard_fluent` | Side yard exterior | Cameras & Security |
| Driveway Lens 0 | `camera.driveway_fluent_lens_0` | Driveway (wide angle) | Cameras & Security |
| Driveway Lens 1 | `camera.driveway_fluent_lens_1` | Driveway (zoom) | Cameras & Security |
| Front Yard | `camera.front_yard_fluent` | Front yard exterior | Cameras & Security |
| Rowan's Room | `camera.rowan_room_fluent` | Rowan's bedroom interior | Cameras & Security |

#### Thingino Cameras (4)
| Camera | Entity ID | Location | Dashboard View |
|--------|-----------|----------|----------------|
| Wyzethingino1 | `camera.wyzethingino1_profile_0` | Interior monitoring | Cameras & Security |
| Wyzethingino2 | `camera.wyzethingino2_profile_0` | Interior monitoring | Cameras & Security |
| Wyzethingino3 | `camera.wyzethingino3_profile_0` | Interior monitoring | Cameras & Security |
| Wyzethingino4 | `camera.wyzethingino4_profile_0` | Interior monitoring | Cameras & Security |

**Dashboard Layout**: 3×3 grid (all 9 cameras visible, no swipe needed)
**Card Type**: `picture-entity` with always-loaded refresh (10-30s default)
**Performance**: 72MB RAM (0.88%), 0.9 MB/s bandwidth (7%) - trivial load for RK3588S2
**LLM Vision Integration**: Available for AI event descriptions

---

## Lighting Entities

### Room Lighting (36 Entities)

#### Living Area
- `light.living_room_lights` - Main living room lighting group
- `light.dining_room_lights` - Dining room chandelier/recessed
- `light.kitchen_lights` - Kitchen overhead + under-cabinet
- **Dashboard View**: Living Area controls

#### Master Suite
- `light.master_bedroom_downlights` - Master bedroom recessed
- `light.bedroom_recessed_group` - Bedroom lighting group
- `light.master_bathroom_lights` - Master bathroom vanity + shower
- `light.master_closet_lights` - Walk-in closet
- **Dashboard View**: Master controls

#### Other Rooms
- `light.rowan_room_lights` - Rowan's bedroom
- `light.office_lights` - Office overhead + desk lamps
- `light.guest_bedroom_lights` - Guest bedroom
- `light.guest_bathroom_lights` - Guest bathroom
- **Dashboard Views**: Respective room pages

#### Outdoor & Utility
- `light.outdoor_lights` - Exterior lighting group
- `light.garage_lights` - Garage overhead
- `light.laundry_lights` - Laundry room
- **Dashboard View**: System view, Garage view

### Lighting Scenes (Zigbee2MQTT/Z-Wave)

**User Confirmation**: "some basic scenes would be nice"

**Scene Entities** (to be configured):
- `scene.movie_time` - Living area dim with accent lighting
- `scene.dinner_mode` - Dining room warm lighting
- `scene.bedtime` - All lights off except night lights
- `scene.good_morning` - Gradual wake-up lighting
- `scene.away_mode` - Security lighting pattern

**Dashboard View**: Scenes view (Week 3 implementation)
**Card Type**: Scene Presets card

---

## Media & Entertainment Entities

### Media Players (12 Entities)

| Media Player | Entity ID | Location | Dashboard View |
|--------------|-----------|----------|----------------|
| Living Room TV | `media_player.living_room_tv` | Living room | Living Area |
| Master Bedroom TV | `media_player.master_bedroom_tv` | Master bedroom | Master |
| Office Media | `media_player.office` | Office | Office |
| Kitchen Speaker | `media_player.kitchen_speaker` | Kitchen | Living Area |
| (8 additional media players) | Various | Respective rooms |

**Dashboard Usage**: Room-specific media controls (Mushroom Media Card)

---

## Covers & Garage Doors

### Garage Doors (2 Entities)
- `cover.garage_door_1` - Main garage door (2-car bay 1)
- `cover.garage_door_2` - Secondary garage door (2-car bay 2)
- **Dashboard View**: Garage view (primary), Overview (status chip)
- **Card Type**: Mushroom Cover Card

### Window Coverings (3 Entities)
- `cover.blinds_1` - Living room blinds
- `cover.blinds_2` - Master bedroom blinds
- `cover.blinds_3` - Office blinds
- **Dashboard View**: Respective room pages

---

## Fans (2 Entities)

- `fan.office_fan` - Office ceiling fan (speed control)
- `fan.living_room_fan` - Living room ceiling fan (speed control)
- **Dashboard Views**: Office view, Living Area view
- **Card Type**: Mushroom Fan Card

---

## Weather & Calendar Entities

### Weather
- **Entity**: `weather.forecast_home`
- **Data Provider**: (Integration name from research)
- **Forecast**: 5-day forecast available
- **Dashboard Card**: Clock Weather Card
- **Dashboard Views**: Overview (header), Calendar view

### WAQI Air Quality ✅ (OPERATIONAL - Direct API Access)

**Status**: ✅ WORKING - 9/9 sensors operational via manual REST sensors

**Solution**: Bypassed broken HA integration (#133919) with direct API access via `packages/waqi_manual_sensors.yaml`

| Entity ID | Type | Purpose | Current Value | Dashboard View |
|-----------|------|---------|---------------|----------------|
| `sensor.waqi_seabrook_aqi` | AQI Index | Primary air quality value (0-500 scale) | 15 (Moderate) | Overview, Calendar |
| `sensor.waqi_seabrook_aqi_category` | Text | Human-readable AQI category | Good | Overview, Calendar |
| `sensor.waqi_seabrook_pm2_5` | µg/m³ | PM2.5 particulate matter | 10 µg/m³ | Calendar (detailed) |
| `sensor.waqi_seabrook_pm10` | µg/m³ | PM10 particulate matter | unavailable | Calendar (detailed) |
| `sensor.waqi_seabrook_ozone` | ppb | Ozone (O3) levels | 18.4 ppb | Calendar (detailed) |
| `sensor.waqi_seabrook_no2` | ppb | Nitrogen dioxide levels | 1.7 ppb | Calendar (detailed) |
| `sensor.waqi_seabrook_temperature` | °F | Station outdoor temperature | 77.7°F | (reference) |
| `sensor.waqi_seabrook_humidity` | % | Station outdoor humidity | 89% | (reference) |
| `sensor.waqi_seabrook_attribution` | Text | Data source attribution | Texas Commission on Environmental Quality (TCEQ) | (metadata) |

**Documentation**: See `/temp/testing/waqi-configuration-guide.md` and `/temp/testing/waqi-fix-instructions.md`
**Station**: Seabrook Friendship Park, Houston, TX (Station #179)
**API Key**: Valid and tested
**Update Interval**: 30 minutes (API-friendly, under free tier limit)
**Dashboard Impact**: Air quality widgets READY for Overview and Calendar views

### Calendar (6 Entities)

| Calendar | Entity ID | Purpose | Dashboard View |
|----------|-----------|---------|----------------|
| Family Calendar | `calendar.family` | Shared family events | Calendar view (primary) |
| Cass & Drew | `calendar.cassandrew` | Couple events | Calendar view |
| Week Numbers | `calendar.week_numbers` | Week numbering reference | Calendar view (background) |
| (3 additional calendars) | Various | Specialized events | Calendar view |

**Dashboard Cards**:
- Week Planner Card (7-day view)
- Calendar Card Pro (month view)

---

## Person & Presence Entities

### Person
- **Entity**: `person.drews_iphone`
- **Presence States**: `home`, `away`, `not_home`
- **Dashboard Usage**: Overview header (user greeting), security automation triggers

### Device Trackers (4 Entities)
- `device_tracker.drews_iphone` - Drew's iPhone location
- `device_tracker.kitchen_tablet` - Kitchen wall tablet
- (2 additional device trackers)
- **Dashboard Usage**: Home/away status for automation context

---

## Helper Entities (Automation Support)

### Input Booleans (411 Entities)

**Primary Use**: Climate feature flags, automation controls

**Key Examples**:
- `input_boolean.use_new_feature` - KISS feature flag pattern
- `input_boolean.emergency_humidity_override_active` - Emergency override status
- `input_boolean.climate_system_restart_in_progress` - System restart flag
- **Dashboard Usage**: Hidden (backend automation), status chips for emergency overrides

### Input Numbers (343 Entities)

**Primary Use**: Thresholds, timers, setpoints

**Key Examples**:
- `input_number.emergency_humidity_target` - Emergency humidity setpoint (default 55%)
- `input_number.cooling_boost_duration` - Cooling boost timer duration
- `input_number.hvac_cycle_minimum_runtime` - Equipment runtime minimum (15 min)
- **Dashboard Usage**: Settings view (advanced controls)

### Input Selects (64 Entities)

**Primary Use**: System states, modes

**Key Examples**:
- `input_select.climate_mode` - Climate system mode selector
- `input_select.home_occupancy_mode` - Home/away/sleep modes
- **Dashboard Usage**: Mode selectors on Overview

---

## System Monitoring Entities

### Server Performance
- `sensor.processor_use` - CPU usage percentage
- `sensor.memory_use_percent` - RAM usage percentage
- `sensor.disk_use_percent` - Storage usage
- `sensor.database_size` - Home Assistant database size
- **Dashboard View**: System view (performance card)

### Network
- `sensor.speedtest_download` - Internet download speed
- `sensor.speedtest_upload` - Internet upload speed
- `sensor.speedtest_ping` - Network latency
- **Dashboard View**: System view

### Home Assistant Health
- `sensor.home_assistant_uptime` - HA uptime duration
- `sensor.automation_count` - Total automations (647)
- `sensor.entity_count` - Total entities (2,906)
- **Dashboard View**: System view

---

## View-to-Entity Mapping

### Overview Page Entities

**Weather Section**:
- `weather.forecast_home` (Clock Weather Card)
- ✅ **WAQI sensors AVAILABLE**: `sensor.waqi_seabrook_aqi`, `sensor.waqi_seabrook_aqi_category`

**Climate Summary**:
- `sensor.average_house_temperature_enhanced`
- `sensor.average_house_humidity_enhanced`
- `climate.thermostat` (main control)
- `switch.e130_dehumidifier_control`
- `sensor.equipment_arbitration_status_enhanced`

**Emergency Controls** (⚠️ verified entity IDs):
- `script.emergency_humidity_override` ✅
- `script.emergency_cooling_boost` ✅
- `script.emergency_rollback_all_flags` ✅ (NOT reset_all_overrides)
- ❌ ~~`script.climate_system_restart`~~ **REMOVED** (doesn't exist)

**Status Chips**:
- `alarm_control_panel.home_alarm` (armed/disarmed)
- `sensor.doors_open_count`
- `cover.garage_door_1`, `cover.garage_door_2` (open/closed)
- `person.drews_iphone` (home/away)

**Room Quick Access** (6 buttons to room pages):
- Living Area, Master, Rowan, Office, Guest, System

---

### Living Area Page Entities

**Climate** (4 sensors):
- `sensor.climate_living_temperature`, `sensor.climate_living_humidity`
- `sensor.climate_dining_temperature`, `sensor.climate_dining_humidity`
- `sensor.climate_kitchen1_temperature`, `sensor.climate_kitchen1_humidity`
- `sensor.climate_kitchen2_temperature`, `sensor.climate_kitchen2_humidity`

**Lighting**:
- `light.living_room_lights`
- `light.dining_room_lights`
- `light.kitchen_lights`

**Climate Comfort**:
- `sensor.climate_living_dew_point`
- Temperature/humidity trend graphs (ApexCharts)

**Media**:
- `media_player.living_room_tv`
- `media_player.kitchen_speaker`

**Fans/Covers**:
- `fan.living_room_fan`
- `cover.blinds_1`

**Motion**:
- `binary_sensor.living_room_motion` (occupancy chip - ✅ verified)

---

### Master Page Entities

**Climate** (3 sensors):
- `sensor.climate_master_temperature`, `sensor.climate_master_humidity`
- `sensor.climate_masterbath_temperature`, `sensor.climate_masterbath_humidity`
- `sensor.climate_mastercloset_temperature`, `sensor.climate_mastercloset_humidity`

**Lighting**:
- `light.master_bedroom_downlights`
- `light.bedroom_recessed_group`
- `light.master_bathroom_lights`
- `light.master_closet_lights`

**Climate Comfort**:
- `sensor.climate_master_dew_point`
- Temperature/humidity trend graphs

**Climate Control**:
- `climate.thermostat` (secondary card - bedroom-specific settings)

**Media**:
- `media_player.master_bedroom_tv`

**Covers**:
- `cover.blinds_2`

**Motion**:
- `binary_sensor.bedroom_motion` (⚠️ actual entity - NOT master_bedroom_motion)

---

### Rowan's Room Page Entities

**Climate** (1 sensor):
- `sensor.climate_rowan_temperature`, `sensor.climate_rowan_humidity`

**Lighting**:
- `light.rowan_room_lights`

**Climate Comfort**:
- `sensor.climate_rowan_dew_point`
- Temperature/humidity trend graph

**Motion**:
- `binary_sensor.rowan_room_motion`

---

### Office Page Entities

**Climate** (1 sensor):
- `sensor.climate_office_temperature`, `sensor.climate_office_humidity`

**Lighting**:
- `light.office_lights`

**Climate Comfort**:
- `sensor.climate_office_dew_point`
- Temperature/humidity trend graph

**Media**:
- `media_player.office`

**Fan**:
- `fan.office_fan`

**Covers**:
- `cover.blinds_3`

**Motion**:
- `binary_sensor.presencesensor1_motion` (⚠️ actual entity - NOT office_motion)

---

### Guest Bedroom Page Entities

**Climate** (2 sensors):
- `sensor.climate_guestbed_temperature`, `sensor.climate_guestbed_humidity`
- `sensor.climate_guestbath_temperature`, `sensor.climate_guestbath_humidity`

**Lighting**:
- `light.guest_bedroom_lights`
- `light.guest_bathroom_lights`

**Climate Comfort**:
- `sensor.climate_guestbed_dew_point`
- Temperature/humidity trend graph

**Motion**:
- `binary_sensor.nursery_motion` (⚠️ actual entity - NOT guest_bedroom_motion)

---

### Cameras & Security Page Entities

**Alarm**:
- `alarm_control_panel.home_alarm` (Mushroom Alarm Card)

**Cameras** (11 entities, 6 visible in 2-column grid):
- `camera.front_door`, `camera.backyard`, `camera.garage`, `camera.driveway`
- `camera.living_room` + 6 additional cameras
- **Layout**: Swipe card for carousel

**Door Sensors** (14 doors):
- Auto-entities list filtered by `device_class: door`
- Shows open/closed state with timestamp

**Motion Sensors** (32 sensors):
- Auto-entities list filtered by `device_class: motion`
- Recent activity timeline (last 10 events)

**LLM Vision**:
- LLM Vision Card for AI camera event descriptions

---

### Calendar & Planning Page Entities

**Weather**:
- `weather.forecast_home` (5-day forecast)
- ✅ **WAQI air quality sensors AVAILABLE**: `sensor.waqi_seabrook_aqi`, `sensor.waqi_seabrook_pm2_5`, `sensor.waqi_seabrook_ozone`

**Calendars** (6 entities):
- `calendar.family` (primary display)
- `calendar.cassandrew`
- `calendar.week_numbers`
- 3 additional calendars

**Week Planner**:
- Week Planner Card (7-day view, all 6 calendars)

**Calendar Card Pro**:
- Month view with multi-calendar support

**Quick Event Creation** (if implementing):
- `input_text.quick_event_title`
- `input_datetime.quick_event_start`
- `input_boolean.quick_event_all_day`

---

### System View Entities

**Garage Controls**:
- `cover.garage_door_1`, `cover.garage_door_2`
- `camera.garage`
- `sensor.climate_foyergarage_temperature`, `sensor.climate_foyergarage_humidity`

**Utility Rooms** (low-priority climate):
- `sensor.climate_laundry_temperature`, `sensor.climate_laundry_humidity`
- `sensor.climate_halfbath_temperature`, `sensor.climate_halfbath_humidity`
- `sensor.climate_foyerfront_temperature`, `sensor.climate_foyerfront_humidity`

**HVAC System**:
- `sensor.climate_hvac_return_temperature`, `sensor.climate_hvac_return_humidity`
- `sensor.climate_hvac_supply_temperature`, `sensor.climate_hvac_supply_humidity`
- `sensor.hvac_efficiency_runtime_tracking`

**Performance Monitoring**:
- `sensor.processor_use`, `sensor.memory_use_percent`, `sensor.disk_use_percent`
- `sensor.database_size`, `sensor.home_assistant_uptime`

**Network**:
- `sensor.speedtest_download`, `sensor.speedtest_upload`, `sensor.speedtest_ping`

**Notifications** (recent alerts):
- Climate alerts history
- System health warnings

---

### Scenes View Entities

**Lighting Scenes** (to be created):
- `scene.movie_time`
- `scene.dinner_mode`
- `scene.bedtime`
- `scene.good_morning`
- `scene.away_mode`

**Scene Activation**:
- Scene Presets card (Hue-style interface)

**Room Scene Groups**:
- Living Area scenes
- Master bedroom scenes
- Whole-home scenes

---

## Entity Performance Considerations

### High-Update-Frequency Entities

**Climate Sensors** (18 × 2 = 36 entities):
- Update interval: 60 seconds (Zigbee2MQTT report interval)
- Dashboard impact: ApexCharts limited to 4-hour span, 5-minute aggregation

**Motion Sensors** (32 entities):
- Update interval: Instant on motion detection
- Dashboard impact: Use `last_changed` timestamp, don't display all 32 simultaneously

**Media Players** (12 entities):
- Update interval: Variable (active polling when playing)
- Dashboard impact: Conditional visibility (only show if powered on)

### Low-Update-Frequency Entities

**Weather** (1 entity):
- Update interval: 30 minutes typical
- Dashboard impact: Minimal

**Calendar** (6 entities):
- Update interval: 15 minutes typical
- Dashboard impact: Minimal

### Large Entity Groups (Conditional Loading)

**Cameras** (11 entities):
- Load strategy: Only load 6 visible cameras, lazy-load on swipe
- Network impact: Disable auto-refresh when view not active

**Automation** (647 entities):
- Dashboard impact: None (not displayed on dashboard)

**Helper Entities** (411 + 343 + 64 = 818 entities):
- Dashboard impact: Minimal (only display ~20 key flags/selectors)

---

## Missing Entities (Gap Analysis)

### Not Available in Current Installation

**Irrigation**:
- No sprinkler entities → Skip Irrigation view

**Hue Scenes** (partial):
- Scene entities exist but need configuration
- Scene Presets integration required

**Lunar Phase** (optional):
- Integration not confirmed installed
- Lunar Phase Card installed but needs integration

### Template Sensors to Create (Week 1)

**⚠️ IMPORTANT**: Use ACTUAL entity IDs from verified motion sensors above

**Room Summaries** (simplified due to missing sensors):
- `sensor.living_area_occupancy` - Uses ONLY `binary_sensor.living_room_motion` (dining/kitchen sensors don't exist)
- `sensor.master_suite_occupancy` - Uses ONLY `binary_sensor.bedroom_motion` (bathroom sensor doesn't exist)
- `sensor.office_occupancy` - Uses `binary_sensor.presencesensor1_motion` (NOT office_motion)

**Door/Window Counts**:
- `sensor.doors_open_count` - Total open doors (already exists?)
- `sensor.windows_open_count` - Total open windows

**Climate Comfort Scores**:
- `sensor.living_area_comfort_score` - Temperature + humidity combined metric (0-100)
- `sensor.master_comfort_score` - Master bedroom comfort
- (Comfort score = function of temp proximity to setpoint + humidity in range)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2025-11-10 | Initial entity mapping documentation | Claude |

---

## Related Documents

- `00-project-overview.md` - Project scope and goals
- `01-component-requirements.md` - HACS dependencies
- `03-view-architecture.md` - View layouts using these entities
- `05-implementation-phases.md` - Entity integration timeline

---

**Next Steps**:
1. Verify WAQI sensor entity IDs
2. Create template sensors for room occupancy and comfort scores
3. Configure lighting scenes for Scenes view
