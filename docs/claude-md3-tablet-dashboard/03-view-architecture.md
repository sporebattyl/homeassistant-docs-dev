# View Architecture - MD3 Tablet Dashboard

**Last Updated**: 2025-11-10
**Status**: Planning Phase
**Target Device**: WF2185T 21.5" Tablet (1920×1080 estimated resolution)

---

## Overview

This document provides detailed view-by-view architecture for the MD3 Tablet Dashboard, including layouts, card types, navigation structure, and wireframe descriptions optimized for a 21.5" wall-mounted tablet display.

---

## Dashboard Global Architecture

### Navigation System

**Primary Navigation**: Navbar Card (bottom navigation bar)
**Navigation Style**: Icon + label tabs
**View Count**: 10 views total
**Navigation Position**: Bottom of screen (thumb-friendly for tablet)

#### Navbar Configuration

```yaml
type: custom:navbar-card
views:
  - view: overview
    icon: m3o:home
    name: Home
  - view: living
    icon: m3o:living
    name: Living
  - view: master
    icon: m3o:bed
    name: Master
  - view: rowan
    icon: m3o:child_care
    name: Rowan
  - view: office
    icon: m3o:work
    name: Office
  - view: guest
    icon: m3o:hotel
    name: Guest
  - view: security
    icon: m3o:security
    name: Security
  - view: calendar
    icon: m3o:calendar_month
    name: Calendar
  - view: system
    icon: m3o:settings
    name: System
  - view: scenes
    icon: m3o:lightbulb
    name: Scenes
```

### Screen Layout (21.5" - 1920×1080)

```
┌─────────────────────────────────────────────────────────────┐
│  HEADER (80px) - Status chips, weather widget, user info   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                                                             │
│                  MAIN CONTENT AREA                          │
│                    (920px height)                           │
│            Grid/Masonry Layout (responsive)                 │
│                                                             │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  NAVBAR (80px) - Bottom navigation (10 view tabs)          │
└─────────────────────────────────────────────────────────────┘

Total usable width: 1920px
Total usable height: 1080px
Content area: 1920×920px
Grid columns: 4 (465px each with 20px gutters, total: 1860px + 60px gutters = 1920px)
```

### Color System (Material You Theme)

**Primary Palette** (user-selectable via color picker):
- Dynamic color generation from single hue
- Automatic light/dark mode variants

**Climate-Specific Colors** (preserved from current theme):
- Success (comfortable): `#4CAF50` (71-75°F, 40-54% RH)
- Warning (borderline): `#F57C00` (76-77°F, 55-59% RH)
- Error (uncomfortable): `#F44336` (78°F+, 60% RH+)

**Transparency**: 85% opacity cards with gradient backgrounds

---

## View 1: Overview (Home Page)

**Purpose**: Main dashboard hub with weather, whole-home climate summary, emergency controls, and quick access to all rooms

**Priority**: 🔴 Critical (Week 1)

### Layout Structure

**Grid Template** (4 columns × 3 rows):
```
┌─────────────┬─────────────┬─────────────┬─────────────┐
│  WEATHER    │  CLIMATE    │  CLIMATE    │  STATUS     │
│  WIDGET     │  SUMMARY    │  SUMMARY    │  CHIPS      │
│  (Clock     │  (Temp/Hum) │  (cont.)    │  (Alarm/    │
│  Weather    │             │             │  Doors)     │
│  Card)      │             │             │             │
├─────────────┴─────────────┴─────────────┴─────────────┤
│           EMERGENCY CLIMATE CONTROLS (3 buttons)       │
│  [HUMIDITY]  [COOLING]  [RESET]  ⚠️ System Restart removed│
├─────────────┬─────────────┬─────────────┬─────────────┤
│  ROOM QUICK ACCESS (6 room navigation buttons)         │
│  [Living]  [Master]  [Rowan]  [Office]  [Guest]  [More]│
├─────────────┴─────────────┴─────────────┴─────────────┤
│  RECENT ACTIVITY / NOTIFICATIONS (expandable)          │
│  - Climate alerts, door events, motion timeline        │
└────────────────────────────────────────────────────────┘
```

### Card Specifications

#### Weather Widget (Top-Left)
- **Card**: `custom:clock-weather-card`
- **Entity**: `weather.forecast_home`
- **Size**: 465×300px (1 column)
- **Features**:
  - Animated weather icon
  - Current temp + feel-like
  - 5-day forecast
  - Sunrise/sunset times
- **Enhancements**:
  - ✅ **WAQI air quality chips AVAILABLE** (Manual REST sensors: `sensor.waqi_seabrook_aqi`, `sensor.waqi_seabrook_aqi_category`)

#### Climate Summary (Top-Center, 2 columns)
- **Card**: `custom:mushroom-climate-card` + `custom:mushroom-entity-card`
- **Entities**:
  - `climate.thermostat` (main card)
  - `sensor.average_house_temperature_enhanced`
  - `sensor.average_house_humidity_enhanced`
  - `switch.e130_dehumidifier_control`
  - `sensor.equipment_arbitration_status_enhanced`
- **Size**: 950×300px (2 columns)
- **Layout**:
  - Left: Thermostat control (current temp, setpoint sliders)
  - Right:
    - Average humidity gauge
    - Dehumidifier toggle
    - Equipment status chip
    - Dew point display

#### Status Chips (Top-Right)
- **Card**: `custom:mushroom-chips-card`
- **Size**: 465×300px (1 column)
- **Chips** (vertical stack):
  1. Alarm status (`alarm_control_panel.home_alarm`)
     - Icon color: Green (disarmed), Red (armed), Orange (triggered)
  2. Doors open count (`sensor.doors_open_count`)
     - "2 doors open" with list on tap
  3. Garage status (`cover.garage_door_1`, `cover.garage_door_2`)
     - "1 garage open" with controls on tap
  4. Person presence (`person.drews_iphone`)
     - "Drew: Home" with location timestamp

#### Emergency Controls (Middle Row)
- **Card**: `custom:button-card` (reuse existing templates)
- **Size**: 3 buttons × 400px each = 1200px (centered, equally spaced)
- **Layout**: Horizontal stack with Paper Buttons Row

**⚠️ VERIFIED 2025-11-13** - Using actual script entity IDs

**Button 1: Emergency Humidity Override**
- **Script**: `script.emergency_humidity_override` ✅
- **Icon**: `m3o:water_drop`
- **Color**: `#F44336` (red)
- **Label**: "HUMIDITY OVERRIDE"
- **Sublabel**: "Force 55% target"

**Button 2: Emergency Cooling Boost**
- **Script**: `script.emergency_cooling_boost` ✅
- **Icon**: `m3o:ac_unit`
- **Color**: `#1976d2` (blue)
- **Label**: "COOLING BOOST"
- **Sublabel**: "Force AC on"

**Button 3: Reset All Overrides**
- **Script**: `script.emergency_rollback_all_flags` ✅ (NOT reset_all_overrides)
- **Icon**: `m3o:check_circle`
- **Color**: `#4CAF50` (green)
- **Label**: "RESET ALL"
- **Sublabel**: "Clear overrides"

**❌ REMOVED**: ~~Climate System Restart~~ button (script doesn't exist, has timeout issue)

#### Room Quick Access (Third Row)
- **Card**: `custom:button-card` × 6
- **Size**: 320×200px each
- **Layout**: 6-column grid (full width)

**Buttons**:
1. Living Area → `view: living` navigation
2. Master → `view: master` navigation
3. Rowan → `view: rowan` navigation
4. Office → `view: office` navigation
5. Guest → `view: guest` navigation
6. System → `view: system` navigation

**Button Template**:
- Icon: Room-specific (m3o:living, m3o:bed, etc.)
- Label: Room name
- Sublabel: Current temperature from primary sensor
- Background: Gradient with room occupancy indicator (motion sensor)

#### Recent Activity (Bottom)
- **Card**: `custom:expander-card` (collapsed by default)
- **Size**: Full width × 150px (collapsed), 400px (expanded)
- **Content**:
  - Last 10 climate alerts (humidity warnings, override activations)
  - Last 5 door events (front door, garage)
  - Last 5 motion events (with timestamps)

---

## View 2-6: Climate Room Pages

**Common Structure**: All 5 room pages (Living, Master, Rowan, Office, Guest) follow this template with room-specific entities.

**Priority**: 🔴 Critical (Week 2)

### Standard Room Page Layout

**Grid Template** (3 columns × variable rows):
```
┌─────────────┬─────────────┬─────────────┐
│  ROOM       │  CLIMATE    │  CONTROLS   │
│  HEADER     │  GAUGES     │  (LIGHTS/   │
│  (Name,     │  (Temp/Hum) │  MEDIA/FAN) │
│  Occupancy) │             │             │
├─────────────┴─────────────┴─────────────┤
│  18-SENSOR NETWORK GRAPH (APEXCHARTS)   │
│  Temperature trends (4-hour span)        │
├─────────────┬─────────────┬─────────────┤
│  DEW POINT  │  COMFORT    │  CLIMATE    │
│  TRACKING   │  SCORE      │  SETPOINT   │
│             │  (0-100)    │  OVERRIDES  │
├─────────────┴─────────────┴─────────────┤
│  ROOM-SPECIFIC FEATURES (variable)      │
│  - Additional sensors, cameras, etc.    │
└─────────────────────────────────────────┘
```

### Example: Living Area Page

#### Room Header
- **Card**: `custom:mushroom-title-card`
- **Content**:
  - Title: "Living Area"
  - Subtitle: "Living Room • Dining Room • Kitchen"
  - Icon: `m3o:living`
  - Occupancy chip: `binary_sensor.living_room_motion` (green if active <5min)

#### Climate Gauges (4 Sensors)
- **Card**: `custom:mushroom-entity-card` × 4 (2×2 grid)
- **Entities**:
  - Living Room: `sensor.climate_living_temperature`, `sensor.climate_living_humidity`
  - Dining Room: `sensor.climate_dining_temperature`, `sensor.climate_dining_humidity`
  - Kitchen: `sensor.climate_kitchen1_temperature` (average of kitchen1+kitchen2)
- **Layout**:
  ```
  ┌─────────────┬─────────────┐
  │  Living     │  Dining     │
  │  74°F / 52% │  74°F / 52% │
  ├─────────────┼─────────────┤
  │  Kitchen    │  Avg Area   │
  │  73°F / 54% │  74°F / 53% │
  └─────────────┴─────────────┘
  ```

#### Controls (Right Column)
- **Lighting**: `custom:mushroom-light-card`
  - `light.living_room_lights` (brightness slider)
  - `light.dining_room_lights` (brightness slider)
  - `light.kitchen_lights` (brightness slider)
- **Fan**: `custom:mushroom-fan-card`
  - `fan.living_room_fan` (speed control)
- **Covers**: `custom:mushroom-cover-card`
  - `cover.blinds_1`
- **Media**: `custom:mushroom-media-player-card`
  - `media_player.living_room_tv` (collapsed when off)
  - `media_player.kitchen_speaker`

#### 18-Sensor Network Graph
- **Card**: `custom:apexcharts-card`
- **Size**: Full width × 300px
- **Entities**: All 4 living area temperature sensors
- **Features**:
  - 4-hour time span
  - 5-minute data aggregation
  - Color-coded lines (living=blue, dining=green, kitchen=orange, average=purple)
  - Y-axis: 68-78°F range
  - Comfort zone shading (71-75°F green band)

#### Dew Point & Comfort
- **Dew Point**: `custom:mushroom-entity-card`
  - `sensor.climate_living_dew_point`
  - Icon: `m3o:water_drop`
  - Color: Green (<60°F), Yellow (60-65°F), Red (>65°F)
- **Comfort Score**: `custom:mushroom-entity-card`
  - `sensor.living_area_comfort_score` (template sensor, 0-100)
  - Icon: `m3o:mood` (changes based on score)
  - Score calculation: Distance from ideal (73°F, 50% RH)

---

## View 7: Cameras & Security

**Purpose**: 11-camera surveillance grid, Envisalink alarm control, door/window/motion sensor timeline

**Priority**: 🟡 High (Week 3)

### Layout Structure

**Grid Template** (3 columns × variable rows):
```
┌─────────────────────────────────────────────────────┐
│  ALARM CONTROL (Mushroom Alarm Card)                │
│  alarm_control_panel.home_alarm                     │
├─────────────┬─────────────┬─────────────────────────┤
│  CAMERA     │  CAMERA     │  SENSOR TIMELINE        │
│  GRID       │  GRID       │  - Last 10 door events  │
│  (2x3 grid) │  (2x3 grid) │  - Last 10 motion       │
│  6 visible  │  (swipe 2)  │  - LLM vision events    │
│             │             │                         │
├─────────────┴─────────────┴─────────────────────────┤
│  DOORS STATUS (14 sensors, auto-entities)           │
│  [Front Door: Closed 2h ago] [Back Door: OPEN now]  │
├──────────────────────────────────────────────────────┤
│  MOTION ACTIVITY MAP (32 sensors, heatmap or list)  │
│  Last motion: Office (2 min ago)                    │
└──────────────────────────────────────────────────────┘
```

### Card Specifications

#### Alarm Control
- **Card**: `custom:mushroom-alarm-control-panel-card`
- **Entity**: `alarm_control_panel.home_alarm`
- **Size**: Full width × 200px
- **Features**:
  - Arm Home / Arm Away / Disarm buttons
  - Keypad overlay for code entry
  - Zone status (6 zones from Envisalink)
  - Color: Green (disarmed), Red (armed), Orange (triggered)

#### Camera Grid
- **Card**: `grid` layout with `picture-entity` cards
- **Cameras**: 9 total, all visible (no swipe needed)
- **Size**: Each camera 640×360px (16:9 aspect), 3 columns × 3 rows
- **Camera Layout** (3×3 grid):
  - **Row 1**: Side Yard, Driveway Lens 0, Driveway Lens 1
  - **Row 2**: Front Yard, Rowan's Room, Wyzethingino1
  - **Row 3**: Wyzethingino2, Wyzethingino3, Wyzethingino4
- **Entity IDs**:
  - `camera.side_yard_fluent` (Reolink)
  - `camera.driveway_fluent_lens_0` (Reolink)
  - `camera.driveway_fluent_lens_1` (Reolink)
  - `camera.front_yard_fluent` (Reolink)
  - `camera.rowan_room_fluent` (Reolink)
  - `camera.wyzethingino1_profile_0` (Thingino)
  - `camera.wyzethingino2_profile_0` (Thingino)
  - `camera.wyzethingino3_profile_0` (Thingino)
  - `camera.wyzethingino4_profile_0` (Thingino)
- **Features**:
  - Tap for full-screen
  - Always-loaded (slow refresh 10-30s)
  - Timestamp overlay

#### Sensor Timeline
- **Card**: `custom:auto-entities` + `entities-card`
- **Size**: 465px width (1 column, right side)
- **Filters**:
  - Last 10 door state changes (binary_sensor, device_class: door)
  - Last 10 motion detections (binary_sensor, device_class: motion)
- **Display**:
  - Entity icon, name, state, last_changed timestamp
  - Sorted by most recent

#### LLM Vision Events
- **Card**: `custom:llmvision-card`
- **Size**: Full width × 200px
- **Features**:
  - AI-generated camera event descriptions
  - "Person detected at front door" (3 min ago)
  - Thumbnail + description

#### Doors Status
- **Card**: `custom:auto-entities`
- **Filter**: `device_class: door`
- **Layout**: Horizontal chips (Mushroom chips card)
- **Display**: Door name + state (Closed/Open) + timestamp

---

## View 8: Calendar & Planning

**Purpose**: Unified 7-day week planner, multi-calendar integration, weather-aware planning (✅ WAQI air quality available via manual REST sensors)

**Priority**: 🟡 High (Week 3)

### Layout Structure

```
┌─────────────────────────────────────────────────────┐
│  WEEK HEADER (Date range, weather summary)          │
├─────────────┬───────────────────────────────────────┤
│  WEATHER    │  WEEK PLANNER CARD                    │
│  5-DAY      │  (7-day view, all 6 calendars)        │
│  FORECAST   │  - calendar.family (primary)          │
│  + WAQI AQI │  - calendar.cassandrew                │
│             │  - 4 additional calendars             │
│             │                                       │
├─────────────┴───────────────────────────────────────┤
│  CALENDAR CARD PRO (Month view, multi-calendar)     │
│  Current month + next month preview                 │
├──────────────────────────────────────────────────────┤
│  QUICK EVENT CREATION (optional, Week 4)            │
│  Title [___________] Start [____] All-day [x]       │
└──────────────────────────────────────────────────────┘
```

### Card Specifications

#### Week Header
- **Card**: `markdown-card` with Jinja2 template
- **Content**:
  - Date range: "November 10-16, 2025"
  - Weather summary: "Partly cloudy, highs 78-82°F"
  - ⚠️ **Air quality DEFERRED** (HA Bug #133919)

#### Weather Forecast (Left Column)
- **Card**: `custom:clock-weather-card` (compact mode)
- **Entity**: `weather.forecast_home`
- **Size**: 465×600px (1 column)
- **Features**:
  - 5-day forecast cards
  - ✅ **WAQI air quality chips AVAILABLE** (`sensor.waqi_seabrook_aqi` with color-coded background)
  - High/low temps, precipitation %

#### Week Planner
- **Card**: `custom:week-planner-card`
- **Size**: 1435×600px (3 columns: 465×3 + 40px gutters)
- **Calendars**: All 6 calendar entities
- **Features**:
  - 7-day horizontal timeline
  - Color-coded by calendar
  - Drag-to-reschedule (if supported)
  - Event details on tap

#### Calendar Card Pro
- **Card**: `custom:calendar-card-pro`
- **Size**: Full width × 400px
- **Features**:
  - Month grid view
  - Multi-calendar overlay
  - Quick navigation (previous/next month)
  - Event list for selected date

---

## View 9: System & Monitoring

**Purpose**: Garage controls, utility room climate, performance monitoring, notifications center

**Priority**: 🟢 Medium (Week 4)

### Layout Structure

```
┌─────────────┬─────────────┬─────────────────────────┐
│  GARAGE     │  GARAGE     │  NOTIFICATIONS          │
│  DOOR 1     │  DOOR 2     │  CENTER                 │
│  (Cover     │  (Cover     │  - Climate alerts       │
│  Card)      │  Card)      │  - System health        │
│             │             │  - Weather warnings     │
├─────────────┴─────────────┼─────────────────────────┤
│  UTILITY CLIMATE          │  PERFORMANCE            │
│  - Laundry, half bath,    │  - CPU, Memory, Disk    │
│  foyer sensors            │  - Database size        │
│                           │  - Network speed        │
├───────────────────────────┴─────────────────────────┤
│  HVAC SYSTEM MONITORING                             │
│  - Return/supply temp, runtime, efficiency          │
└──────────────────────────────────────────────────────┘
```

### Card Specifications

#### Garage Controls
- **Card**: `custom:mushroom-cover-card` × 2
- **Entities**: `cover.garage_door_1`, `cover.garage_door_2`
- **Features**:
  - Open/Close/Stop buttons
  - Position indicator
  - Camera feed from `camera.garage` (below cards)

#### Notifications Center
- **Card**: `custom:expander-card` with `auto-entities`
- **Filters**:
  - Climate alerts (last 24 hours)
  - System health warnings
  - ✅ **Weather warnings AVAILABLE** (WAQI sensors: AQI threshold alerts possible)
- **Display**: Timestamp, alert level, message

#### Performance Monitoring
- **Card**: `custom:mushroom-entity-card` × 6 (grid)
- **Entities**:
  - `sensor.processor_use` (CPU gauge)
  - `sensor.memory_use_percent` (RAM gauge)
  - `sensor.disk_use_percent` (Storage gauge)
  - `sensor.database_size` (HA DB size)
  - `sensor.speedtest_download` (Download Mbps)
  - `sensor.speedtest_upload` (Upload Mbps)

#### HVAC System Monitoring
- **Card**: `custom:apexcharts-card` (dual-axis temperature graph)
- **Entities**:
  - `sensor.climate_hvac_return_temperature` (blue line)
  - `sensor.climate_hvac_supply_temperature` (red line)
  - `sensor.hvac_efficiency_runtime_tracking` (bar chart overlay)
- **Size**: Full width × 300px

---

## View 10: Scenes (Week 3)

**Purpose**: Lighting scene presets with Hue-style interface for Zigbee2MQTT/Z-Wave

**Priority**: 🟡 High (Week 3)

### Layout Structure

```
┌──────────────────────────────────────────────────────┐
│  SCENE CATEGORIES (Tabs or filter chips)             │
│  [All] [Living Area] [Master] [Whole Home]           │
├──────────────────────────────────────────────────────┤
│  SCENE PRESETS CARD (Hue-style grid)                 │
│  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐        │
│  │ Movie  │ │ Dinner │ │Bedtime │ │ Good   │        │
│  │ Time   │ │ Mode   │ │        │ │ Morning│        │
│  │ [IMG]  │ │ [IMG]  │ │ [IMG]  │ │ [IMG]  │        │
│  └────────┘ └────────┘ └────────┘ └────────┘        │
│  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐        │
│  │ Away   │ │ Reading│ │ Party  │ │ Relax  │        │
│  │ Mode   │ │        │ │        │ │        │        │
│  │ [IMG]  │ │ [IMG]  │ │ [IMG]  │ │ [IMG]  │        │
│  └────────┘ └────────┘ └────────┘ └────────┘        │
├──────────────────────────────────────────────────────┤
│  ACTIVE LIGHTS (currently on, grouped by room)       │
│  Living Room: 3 lights | Master: 2 lights            │
└──────────────────────────────────────────────────────┘
```

### Card Specifications

#### Scene Categories
- **Card**: `custom:mushroom-chips-card`
- **Chips**: Filter buttons (All, Living Area, Master, Whole Home)
- **Action**: Filter Scene Presets card below

#### Scene Presets Grid
- **Card**: `custom:scene-presets` (after installation)
- **Layout**: 4 columns × 2 rows = 8 scenes visible
- **Scene Entities**:
  - `scene.movie_time`
  - `scene.dinner_mode`
  - `scene.bedtime`
  - `scene.good_morning`
  - `scene.away_mode`
  - (Create 3 additional scenes as needed)
- **Features**:
  - Thumbnail preview (color swatch or room image)
  - Tap to activate
  - Long-press for scene details

#### Active Lights
- **Card**: `custom:auto-entities` with `mushroom-light-card`
- **Filter**: Lights with state `on`
- **Layout**: Grid, grouped by room
- **Features**: Quick dimming, turn off all button

---

## Navigation Flow

### User Paths

**Path 1: Quick Climate Check**
- Overview → View climate summary → Done
- **Taps**: 0 (always on Overview)

**Path 2: Emergency Humidity Override**
- Overview → Tap "HUMIDITY OVERRIDE" button → Confirm → Done
- **Taps**: 2

**Path 3: Check Specific Room**
- Overview → Tap room quick access (e.g., "Office") → View Office page
- **Taps**: 1

**Path 4: Adjust Room Lights**
- Navbar → Office → Tap light card → Adjust brightness → Done
- **Taps**: 3

**Path 5: Arm Alarm Before Bed**
- Navbar → Security → Tap "Arm Home" → Enter code → Done
- **Taps**: 3

**Path 6: Check Weekly Calendar**
- Navbar → Calendar → View Week Planner
- **Taps**: 1

**Path 7: Activate Lighting Scene**
- Navbar → Scenes → Tap scene preset → Done
- **Taps**: 2

**Path 8: Check Garage Status**
- Overview → View garage chip (status visible) → (Optional: Tap for controls)
- **Taps**: 0-1

---

## Responsive Breakpoints

**21.5" Tablet** (1920×1080 - primary target):
- 4-column grid (465px columns with 20px gutters)
- All features visible without scrolling (vertical fit)

**Fallback: Smaller Tablets** (1280×800):
- 3-column grid (426px columns)
- Slight vertical scrolling required

**Fallback: Mobile** (Portrait, 480×854):
- 1-column stack layout
- Not optimized (tablet-first design)

---

## Accessibility Considerations

**Touch Targets**: Minimum 48×48px (MD3 spec)
**Font Sizes**:
- Headers: 24px
- Body: 16px
- Captions: 14px

**Color Contrast**: WCAG AA (≥4.5:1) already validated in current theme

**Motion**: Reduce motion option in Material You theme settings

---

## Performance Optimization

**Conditional Loading**:
- Cameras: Only load when Cameras & Security view active
- Charts: Lazy-load ApexCharts data on view entry
- Media Players: Conditional visibility (only show if powered on)

**Update Frequencies**:
- Climate sensors: 60-second polling (Zigbee2MQTT native)
- Weather: 30-minute polling (integration default)
- Cameras: Disable auto-refresh when view not visible

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2025-11-10 | Initial view architecture documentation | Claude |

---

## Related Documents

- `00-project-overview.md` - Project scope
- `02-entity-mapping.md` - Entity-to-view assignments
- `04-customization-strategy.md` - Theme and card styling
- `05-implementation-phases.md` - Build timeline

---

**Next Steps**: Create decluttering templates for reusable room cards and emergency button patterns
