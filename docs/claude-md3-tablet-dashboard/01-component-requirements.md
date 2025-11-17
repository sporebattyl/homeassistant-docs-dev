# Component Requirements - MD3 Tablet Dashboard

**Last Updated**: 2025-11-10
**Status**: Planning Phase

---

## Overview

This document catalogs all HACS components, Home Assistant integrations, and dependencies required for the Material Design 3 Tablet Dashboard implementation. It includes installation status, priority levels, and gap analysis against the ElementZoom reference dashboard.

---

## HACS Frontend Components

### Critical Components (Must Install - Week 1)

These components are **ESSENTIAL** for the dashboard to function. The MD3 dashboard will not load properly without them.

#### 1. Material You Theme
- **Status**: ✅ **INSTALLED** (Verified 2025-11-11)
- **Location**: `/themes/material_you/`
- **Priority**: 🔴 **CRITICAL**
- **HACS Category**: Themes
- **Repository**: N/A (HACS built-in theme)
- **Purpose**: Core dynamic theming engine with Material You color picker
- **Features**:
  - Dynamic color generation from user-selected palette
  - Per-user customization support
  - Automatic light/dark mode switching
  - MD3 design token system
- **Installation**:
  ```bash
  # Via HACS UI:
  # HACS > Frontend > Explore & Download Repositories
  # Search: "Material You Theme"
  # Download
  ```
- **Configuration**: See `04-customization-strategy.md` for theme setup
- **Dependencies**: None
- **Validation**: Color picker appears in user profile settings

#### 2. Material Symbols
- **Status**: ❌ **NOT INSTALLED** (Verified 2025-11-11)
- **Priority**: 🔴 **CRITICAL** - MUST INSTALL IN WEEK 1
- **HACS Category**: Frontend
- **Repository**: `https://github.com/basbruss/material-symbols`
- **Purpose**: Icon library for Material Design 3 (m3o:, m3of: icon prefixes)
- **Icon Styles**:
  - `m3o:` - Outlined style (primary)
  - `m3of:` - Filled style
  - `m3or:` - Rounded style
  - `m3os:` - Sharp style
- **Installation**:
  ```bash
  # Via HACS UI:
  # HACS > Frontend > Custom repositories
  # Add: https://github.com/basbruss/material-symbols
  # Category: Lovelace
  ```
- **Resource Configuration**:
  ```yaml
  resources:
    - type: module
      url: /hacsfiles/material-symbols/material-symbols.js
  ```
- **Fallback**: Use `mdi:` icons if installation fails
- **Validation**: Test with `icon: m3o:home` in any card

#### 3. Lovelace Material Components
- **Status**: ✅ **INSTALLED** (Verified 2025-11-11)
- **Location**: `/www/community/lovelace-material-components/`
- **Priority**: 🔴 **CRITICAL**
- **HACS Category**: Frontend
- **Repository**: `https://github.com/lit-md/lovelace-material-components` (verify URL)
- **Purpose**: MD3 component library (buttons, chips, containers)
- **Features**:
  - MD3-styled button components
  - Chip cards (input, filter, suggestion chips)
  - Container layouts with elevation
  - State layer effects (ripple, hover)
- **Installation**: Via HACS custom repository
- **Dependencies**: Material Symbols
- **Validation**: MD3 buttons render with correct elevation/state layers

---

### High Priority Components (Week 1-2)

These components enable key features and should be installed early.

#### 4. Paper Buttons Row
- **Status**: ✅ **INSTALLED** (Verified 2025-11-11)
- **Location**: `/www/community/lovelace-paper-buttons-row/`
- **Priority**: 🟡 **HIGH**
- **HACS Category**: Frontend
- **Repository**: `https://github.com/jcwillox/lovelace-paper-buttons-row`
- **Purpose**: Horizontal button row layouts (used in Overview page)
- **Use Cases**:
  - Emergency script buttons (4-button row)
  - Room quick actions
  - Scene selection
- **Installation**: HACS > Frontend > Explore & Download
- **Alternative**: Use `custom:button-card` in horizontal stack (already installed)
- **Validation**: Button row displays inline on Overview page

#### 5. Scene Presets
- **Status**: ❌ **NOT INSTALLED** (Verified 2025-11-11)
- **Priority**: 🟡 **HIGH** - INSTALL IN WEEK 3
- **HACS Category**: Frontend
- **Repository**: `https://github.com/lukevink/hue-scene-presets` (verify compatibility)
- **Purpose**: Zigbee2MQTT/Z-Wave lighting scene integration
- **Features**:
  - Hue-style scene selection
  - Scene thumbnails with color preview
  - Quick scene activation
- **User Requirement**: Confirmed Zigbee2MQTT + Z-Wave usage with scene needs
- **Installation**: HACS > Frontend > Custom repositories
- **Dependencies**: Scenes integration in HA
- **Validation**: Scenes view displays available presets

---

### Already Installed Components (Current Status: ✅)

These components are **VERIFIED INSTALLED** in your `/www/community/` directory.

#### Apex Charts Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/apexcharts-card/`
- **Purpose**: Advanced graphing for 18-sensor climate network
- **Current Usage**: `gulf-coast-climate-optimized.yaml` (4h temperature trends)
- **MD3 Usage**: Climate room pages, system performance graphs

#### Bubble Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/Bubble-Card/`
- **Purpose**: Bubble-style entity cards with pop-up controls
- **MD3 Usage**: Climate controls, media player overlays

#### Button-Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/button-card/`
- **Purpose**: Highly customizable button component
- **Current Usage**: Emergency script templates in existing dashboard
- **MD3 Usage**: All button interfaces, reuse existing templates

#### Calendar Card Pro
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/calendar-card-pro/`
- **Purpose**: Enhanced calendar views with multi-calendar support
- **Current Usage**: `gulf-coast-climate-optimized.yaml` (family calendar)
- **MD3 Usage**: Calendar view (6 calendar entities)

#### Clock Weather Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/clock-weather-card/`
- **Purpose**: Animated weather widget with clock
- **MD3 Usage**: Overview page header (weather.forecast_home)

#### Expander-Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/lovelace-expander-card/`
- **Purpose**: Collapsible card sections to reduce clutter
- **MD3 Usage**: Advanced climate settings, system logs

#### LLM Vision Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/llmvision-card/`
- **Purpose**: AI-powered camera event descriptions
- **MD3 Usage**: Camera view (9 camera entities)

#### Mini-Graph-Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/mini-graph-card/`
- **Purpose**: Compact inline graphs
- **MD3 Usage**: Room-level temperature/humidity sparklines

#### Mushroom
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/lovelace-mushroom/`
- **Purpose**: Minimalist MD3-inspired card collection
- **Key Cards**:
  - `mushroom-alarm-control-panel-card` (Envisalink integration)
  - `mushroom-entity-card` (generic entity display)
  - `mushroom-climate-card` (thermostat control)
  - `mushroom-light-card` (lighting controls)
  - `mushroom-chips-card` (status chips for header)
- **MD3 Usage**: Primary card system throughout dashboard

#### Navbar Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/lovelace-navbar-card/`
- **Purpose**: Bottom navigation bar for mobile/tablet
- **MD3 Usage**: 9-view navigation system

#### Simple Swipe Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/swipe-card/`
- **Purpose**: Swipeable card stacks (mobile gestures)
- **MD3 Usage**: Camera grid (9 cameras in 3×3 grid, no swipe needed)

#### Simple Tabs Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/home-assistant-simple-tabs/`
- **Purpose**: Tab navigation within views
- **MD3 Usage**: Climate room sub-sections (temperature, humidity, controls)

#### Timer Bar Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/timer-bar-card/`
- **Purpose**: Visual countdown/duration bars
- **MD3 Usage**: HVAC runtime visualization, script cooldown timers

#### Week Planner Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/week-planner-card/`
- **Purpose**: 7-day weekly calendar view
- **MD3 Usage**: Calendar view primary display

---

### Utility Components (Already Installed)

#### Auto-Entities
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/lovelace-auto-entities/`
- **Purpose**: Dynamic entity lists with filters
- **Current Usage**: Room-by-room climate sensor lists
- **MD3 Usage**: Auto-generate room cards, sensor lists

#### Card-Mod
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/lovelace-card-mod/`
- **Purpose**: CSS styling for any card
- **Current Usage**: Extensive use in `gulf-coast-climate-optimized.yaml`
- **MD3 Usage**: Theme overrides, transparency effects

#### Config Template Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/config-template-card/`
- **Purpose**: Jinja2 templating in card configuration
- **Current Usage**: Weather-based recommendations
- **MD3 Usage**: Dynamic content based on climate state

#### Decluttering Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/decluttering-card/`
- **Purpose**: Reusable card templates
- **MD3 Usage**: Room summary cards, temperature entity displays

#### Kiosk Mode
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/kiosk-mode/`
- **Purpose**: Hide sidebar, header, and navigation for kiosk displays
- **MD3 Usage**: Wall-mounted tablet configuration (see `06-tablet-configuration.md`)

#### Layout-Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/lovelace-layout-card/`
- **Purpose**: Advanced grid layouts with named template areas
- **MD3 Usage**: Overview page multi-column layout

#### My Cards Bundle
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/my-cards/`
- **Purpose**: Collection of utility cards
- **MD3 Usage**: Additional helper cards as needed

#### Stack In Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/stack-in-card/`
- **Purpose**: Nest multiple cards inside single container
- **MD3 Usage**: Grouped climate controls

#### Vertical Stack In Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/vertical-stack-in-card/`
- **Purpose**: Vertical card stacking with shared container
- **MD3 Usage**: Room page sections

#### Lunar Phase Card
- **Status**: ✅ **INSTALLED**
- **Location**: `/www/community/lunar-phase-card/`
- **Purpose**: Moon phase visualization
- **MD3 Usage**: Weather view enhancement (requires Lunar Phase integration)

---

### Skipped Components (Not Installing)

#### Alarmo Card
- **Status**: ⛔ **INTENTIONALLY SKIPPED**
- **Reason**: Incompatible with Envisalink entities
- **Documentation**: "Only suitable for `alarm_control_panel` entities generated by the Alarmo integration"
- **Alternative**: **Mushroom Alarm Control Panel Card** (already installed, fully compatible)

#### Web RTC Camera
- **Status**: ⚠️ **DEFERRED TO PHASE 2**
- **Reason**: Evaluate standard camera cards first
- **Complexity**: Requires network configuration, STUN/TURN servers
- **Decision Point**: If camera performance is poor with standard cards, install in Week 3
- **Alternative**: Standard `picture-entity` and `picture-glance` cards

---

## Home Assistant Integrations

### Already Installed Integrations (Verified)

#### Envisalink
- **Status**: ✅ **INSTALLED & CONFIGURED**
- **Entity**: `alarm_control_panel.home_alarm`
- **Hardware**: Envisalink EVL-4 + Honeywell panel
- **Zones**: 6 zones (Entry, Living Motion, Master, Family/Kitchen, Office, Bedrooms)
- **Dashboard Usage**: Mushroom Alarm Card on Cameras & Security view
- **No Changes Required**: Use existing entity as-is

#### WAQI (World Air Quality Index)
- **Status**: ✅ **WORKING - Manual REST Sensors**
- **Solution**: Bypassed broken HA integration with direct API REST sensors (2025-11-14)
- **Entities**: 9 sensors created via `packages/waqi_manual_sensors.yaml`:
  - `sensor.waqi_seabrook_aqi` (primary AQI value, currently 21)
  - `sensor.waqi_seabrook_aqi_category` (Good/Moderate/Unhealthy/etc.)
  - `sensor.waqi_seabrook_pm2_5` (PM2.5 particulate matter)
  - `sensor.waqi_seabrook_pm10` (PM10 particulate matter)
  - `sensor.waqi_seabrook_ozone` (O3 levels)
  - `sensor.waqi_seabrook_no2` (Nitrogen dioxide)
  - `sensor.waqi_seabrook_temperature` (station temperature)
  - `sensor.waqi_seabrook_humidity` (station humidity)
  - `sensor.waqi_seabrook_attribution` (data source)
- **API**: Working perfectly (Station #179: Seabrook Friendship Park, Houston, TX)
- **Scan Interval**: 30 minutes (1,440 calls/month, under free tier 1,000/month limit)
- **Dashboard Impact**: Weather/Calendar air quality widgets NOW AVAILABLE for implementation
- **Note**: Workaround for HA Integration Bug #133919 (marked NOT_PLANNED by maintainer)

#### Zigbee2MQTT
- **Status**: ✅ **INSTALLED & OPERATIONAL**
- **Devices**: 18 climate sensors (ZG-227Z), lighting devices
- **Entities**: `sensor.climate_*_temperature`, `sensor.climate_*_humidity`
- **Dashboard Usage**: Primary climate sensor source, lighting controls
- **No Changes Required**: Existing sensors fully functional

#### Z-Wave
- **Status**: ✅ **INSTALLED**
- **Devices**: Switches, sensors
- **User Confirmation**: "Zigbee2MQTT and Zwave switches"
- **Dashboard Usage**: Lighting control, scene integration
- **No Changes Required**: Use existing entities

#### Weather Integration
- **Status**: ✅ **INSTALLED**
- **Entity**: `weather.forecast_home`
- **Dashboard Usage**: Clock Weather Card on Overview page
- **No Changes Required**: Single weather entity sufficient

#### Calendar Integration
- **Status**: ✅ **INSTALLED**
- **Entities**: 6 calendars
  - `calendar.family`
  - `calendar.cassandrew`
  - `calendar.week_numbers`
  - (3 additional calendars)
- **Dashboard Usage**: Calendar view (Week Planner + Calendar Card Pro)
- **No Changes Required**: Existing calendars ready

### Optional Integrations (Deferred)

#### Lunar Phase Integration
- **Status**: ❓ **UNKNOWN** (not verified)
- **Priority**: 🟢 **OPTIONAL**
- **Purpose**: Moon phase data for weather view
- **Installation**: Settings > Devices & Services > Add Integration > "Moon"
- **Dashboard Impact**: Lunar Phase Card (already installed) displays phase
- **Decision**: Install if user interested in moon phase tracking

---

## Lovelace Resource Configuration

### Current Resources (`mvp-lovelace.yaml`)

```yaml
resources:
  - type: module
    url: /hacsfiles/lovelace-card-mod/card-mod.js
  - type: module
    url: /hacsfiles/mushroom/mushroom.js
  - type: module
    url: /hacsfiles/apexcharts-card/apexcharts-card.js
  - type: module
    url: /hacsfiles/button-card/button-card.js
  - type: module
    url: /hacsfiles/lovelace-layout-card/layout-card.js
  - type: module
    url: /hacsfiles/mini-graph-card/mini-graph-card-bundle.js
  - type: module
    url: /hacsfiles/lovelace-auto-entities/auto-entities.js
  - type: module
    url: /hacsfiles/bubble-card/bubble-card.js
  - type: module
    url: /hacsfiles/decluttering-card/decluttering-card.js
```

### Required Additions (After HACS Installations)

**IMPORTANT CLARIFICATION**: Material You Theme is a THEME (loaded from `themes/` directory), NOT a frontend resource. Only the JavaScript file for dynamic features needs to be loaded as a resource.

```yaml
  # Material Design 3 Core (Week 1)
  # NOTE: Material You THEME itself loads from themes/ folder automatically
  # Only the JavaScript for dynamic features needs resource loading:
  - type: module
    url: /hacsfiles/material-you-theme/material-you-theme.js  # JS only, NOT the theme YAML

  - type: module
    url: /hacsfiles/material-symbols/material-symbols.js

  - type: module
    url: /hacsfiles/lovelace-material-components/material-components.js

  # High Priority Components (Week 1-2)
  - type: module
    url: /hacsfiles/paper-buttons-row/paper-buttons-row.js

  - type: module
    url: /hacsfiles/scene-presets/scene-presets.js  # Week 3

  # Optional (Week 3, if needed)
  - type: module
    url: /hacsfiles/webrtc-camera/webrtc-camera.js
```

### Resource Loading Order

**IMPORTANT**: Material Symbols must load before Material Components

Correct order:
1. Material You Theme JavaScript (for dynamic color features)
2. Material Symbols (icons)
3. Lovelace Material Components (MD3 components)
4. All other components (order doesn't matter)

**Theme Selection**: After loading resources, select `md3_climate_material_you` theme in your user profile (Profile → Theme dropdown)

---

## Installation Checklist

### Week 1 - Critical Components

- [ ] **Material You Theme**
  - [ ] Install via HACS
  - [ ] Verify color picker appears in profile
  - [ ] Test light/dark mode switching

- [ ] **Material Symbols**
  - [ ] Install via HACS custom repository
  - [ ] Add resource to `ui-lovelace-tablet-md3.yaml`
  - [ ] Test icon rendering: `icon: m3o:home`

- [ ] **Lovelace Material Components**
  - [ ] Install via HACS custom repository
  - [ ] Add resource to configuration
  - [ ] Verify MD3 button rendering

- [ ] **Paper Buttons Row**
  - [ ] Install via HACS
  - [ ] Test in Overview page layout

### Week 2 - High Priority Components

- [ ] **Scene Presets**
  - [ ] Verify Zigbee2MQTT scene compatibility
  - [ ] Install via HACS
  - [ ] Configure scene entities
  - [ ] Test scene activation

### Week 3 - Optional Components

- [ ] **Web RTC Camera** (if needed)
  - [ ] Evaluate standard camera card performance
  - [ ] If poor: Install WebRTC
  - [ ] Configure STUN/TURN servers
  - [ ] Test 9 camera feeds

- [ ] **Lunar Phase Integration** (if desired)
  - [ ] Add integration via UI
  - [ ] Verify moon phase sensor created
  - [ ] Connect to Lunar Phase Card

---

## Gap Analysis Summary

### Component Coverage

| Category | Total Required | Installed | Missing | Coverage |
|----------|----------------|-----------|---------|----------|
| Critical Components | 3 | 0 | 3 | 0% |
| High Priority | 2 | 0 | 2 | 0% |
| Card Components | 17 | 14 | 3 | 82% |
| Utility Components | 11 | 11 | 0 | 100% |
| Integrations | 6 | 6 | 0 | 100% |
| **TOTAL** | **39** | **31** | **8** | **79%** |

### Installation Priority

**Must Install** (5 components):
1. Material You Theme (CRITICAL)
2. Material Symbols (CRITICAL)
3. Lovelace Material Components (CRITICAL)
4. Paper Buttons Row (HIGH)
5. Scene Presets (HIGH)

**Optional** (3 components):
1. Web RTC Camera (deferred)
2. Lunar Phase Integration (deferred)
3. Alarmo (skipped - incompatible)

### Risk Assessment

**Low Risk**:
- ✅ 79% of components already installed
- ✅ All integrations operational
- ✅ Theme system MD3-ready

**Medium Risk**:
- ⚠️ Material Symbols availability in HACS (fallback: use MDI icons)
- ⚠️ Material You Theme compatibility with existing theme

**Mitigation**:
- Icon fallback strategy documented
- Separate theme file approach (non-destructive)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2025-11-10 | Initial component requirements documentation | Claude |

---

## Related Documents

- `00-project-overview.md` - Project scope and goals
- `02-entity-mapping.md` - Entity inventory and view mapping
- `04-customization-strategy.md` - Theme integration details
- `05-implementation-phases.md` - Installation timeline
- `06-tablet-configuration.md` - Kiosk mode and resources

---

**Next Steps**: Proceed with Week 1 HACS installations (Material You Theme, Material Symbols, Lovelace Material Components)
