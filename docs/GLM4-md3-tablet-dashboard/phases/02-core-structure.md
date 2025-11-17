# Phase 2: Core Dashboard Structure

**Duration**: 2-3 days
**Status**: Ready after Phase 1 completion
**Prerequisites**: All HACS components installed

## 🎯 Phase Objectives

1. Create main dashboard framework with 8 pages
2. Implement tablet-optimized navigation system
3. Set up responsive grid layouts
4. Create page templates and structure
5. Establish navigation patterns

## 📱 Main Dashboard Framework

### Primary Dashboard Configuration
Create `dashboards/md3-tablet-dynamic.yaml`:
```yaml
title: "GLM MD3 TABLET DASHBOARD"
path: md3-tablet-dashboard
icon: mdi:tablet-dashboard
theme: md3-gulf-coast
badges: []
cards:
  # Global Navigation - Tablet Optimized
  - type: custom:mushroom-chips-card
    style: |
      ha-card {
        position: sticky;
        top: 0;
        z-index: 1000;
        background: rgba(254, 247, 255, 0.95);
        backdrop-filter: blur(10px);
        border-radius: 0 0 16px 16px;
        margin-bottom: 16px;
        border: none;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      }
    alignment: center
    chips:
      - type: template
        icon: mdi:view-dashboard
        content: "Overview"
        tap_action:
          action: navigate
          navigation_path: "/md3-tablet-dashboard/overview"
        card_mod:
          style: |
            ha-card {
              transition: all 0.3s ease;
            }
            ha-card:hover {
              transform: translateY(-2px);
              box-shadow: 0 4px 12px rgba(103, 80, 164, 0.2);
            }
      - type: template
        icon: mdi:thermostat
        content: "Climate"
        tap_action:
          action: navigate
          navigation_path: "/md3-tablet-dashboard/climate"
      - type: template
        icon: mdi:home-heart
        content: "Rooms"
        tap_action:
          action: navigate
          navigation_path: "/md3-tablet-dashboard/rooms"
      - type: template
        icon: mdi:weather-partly-cloudy
        content: "Weather"
        tap_action:
          action: navigate
          navigation_path: "/md3-tablet-dashboard/weather"
      - type: template
        icon: mdi:palette-swatch-variant
        content: "Scenes"
        tap_action:
          action: navigate
          navigation_path: "/md3-tablet-dashboard/scenes"
      - type: template
        icon: mdi:lightning-bolt
        content: "Energy"
        tap_action:
          action: navigate
          navigation_path: "/md3-tablet-dashboard/energy"
      - type: template
        icon: mdi:calendar-month
        content: "Schedule"
        tap_action:
          action: navigate
          navigation_path: "/md3-tablet-dashboard/schedule"
      - type: template
        icon: mdi:cog
        content: "Settings"
        tap_action:
          action: navigate
          navigation_path: "/md3-tablet-dashboard/settings"

  # Dynamic Content Area (sub-routes will be handled here)
  - type: custom:layout-card
    layout_type: custom:grid-layout
    layout:
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr))
      grid-template-rows: auto
      grid-gap: 16px
      margin: 16px
    cards:
      - type: markdown
        content: >
          ## Welcome to GLM MD3 TABLET DASHBOARD

          Select a page from the navigation above to get started.

          **Features:**
          - 🏠 Climate control with 18-sensor network
          - 🌡️ Gulf Coast weather monitoring
          - 🎭 Scene presets and automation
          - ⚡ Energy usage optimization
          - 📱 Tablet-optimized interface
        card_mod:
          style: |
            ha-card {
              background: linear-gradient(135deg, rgba(103, 80, 164, 0.1), rgba(67, 97, 238, 0.1));
              border-radius: 16px;
              border: 2px solid var(--primary-color);
              padding: 24px;
              text-align: center;
            }
```

## 🏠 Page 1: Overview (Main Landing)

### Overview Page Configuration
Create `dashboards/md3-tablet/overview.yaml`:
```yaml
title: "Overview"
path: overview
icon: mdi:view-dashboard
cards:
  # Welcome Section - Tablet Optimized
  - type: vertical-stack
    cards:
      - type: custom:mushroom-template-card
        primary: >
          [[[
            const hour = new Date().getHours();
            if (hour < 12) return "Good Morning";
            if (hour < 17) return "Good Afternoon";
            return "Good Evening";
          ]]]
        secondary: |
          Welcome to Gulf Coast Home |
          {{ now().strftime('%A, %B %d') }} |
          {{ states('weather.forecast_home') or 'Weather unavailable' }}
        icon: mdi:home
        icon_color: primary
        layout: horizontal
        card_mod:
          style: |
            ha-card {
              background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
              color: white;
              border-radius: 16px;
              margin: 8px 0;
              box-shadow: 0 4px 12px rgba(103, 80, 164, 0.3);
            }
            ha-card * {
              color: white !important;
            }

  # Quick Status Grid - 2x2 on Tablet
  - type: custom:layout-card
    layout_type: custom:grid-layout
    layout:
      grid-template-columns: repeat(2, 1fr)
      grid-template-rows: auto auto
      grid-gap: 16px
      margin: 0 16px
    cards:
      # Climate Status Card
      - type: custom:mushroom-template-card
        entity: sensor.average_house_temperature_enhanced_15_sensor
        primary: "House Climate"
        secondary: >
          Temperature: {{ states('sensor.average_house_temperature_enhanced_15_sensor') }}°F
          <br>
          Humidity: {{ states('sensor.average_house_humidity_enhanced') }}%
        icon: mdi:thermostat
        icon_color: |
          {% set temp = states('sensor.average_house_temperature_enhanced_15_sensor') | float %}
          {% if temp < 68 %} blue
          {% elif temp > 76 %} red
          {% else %} green
          {% endif %}
        tap_action:
          action: navigate
          navigation_path: "/md3-tablet-dashboard/climate"

      # Equipment Status Card
      - type: custom:mushroom-template-card
        entity: sensor.equipment_arbitration_status_enhanced
        primary: "Equipment"
        secondary: >
          AC: {{ 'Running' if is_state('climate.ml14xc1', 'cool') else 'Idle' }}
          <br>
          Dehumidifier: {{ 'Running' if is_state('switch.e130_dehumidifier_control', 'on') else 'Idle' }}
        icon: mdi:hvac
        icon_color: |
          {% if states('sensor.equipment_arbitration_status_enhanced') == 'Normal' %}
            green
          {% else %}
            orange
          {% endif %}

      # Weather Card
      - type: custom:mushroom-template-card
        entity: weather.forecast_home
        primary: "Gulf Coast Weather"
        secondary: >
          {{ state_attr('weather.forecast_home', 'temperature') }}°F
          <br>
          {{ states('weather.forecast_home') | title }}
        icon: mdi:weather-partly-cloudy
        icon_color: |
          {% set weather = states('weather.forecast_home') %}
          {% if 'sunny' in weather %} amber
          {% elif 'cloudy' in weather %} grey
          {% elif 'rain' in weather %} blue
          {% else %} indigo
          {% endif %}

      # Energy Status Card
      - type: custom:mushroom-template-card
        entity: sensor.daily_energy_cost
        primary: "Energy Today"
        secondary: >
          ${{ states('sensor.daily_energy_cost') or '0.00' }}
          <br>
          {{ states('sensor.current_power_usage') or '0' }}W
        icon: mdi:lightning-bolt
        icon_color: |
          {% set cost = states('sensor.daily_energy_cost') | float %}
          {% if cost > 5.00 %} red
          {% elif cost > 3.00 %} orange
          {% else %} green
          {% endif %}

  # Quick Actions - Horizontal Scroll on Tablet
  - type: custom:mushroom-chips-card
    alignment: justify
    chips:
      - type: entity
        entity: climate.ml14xc1
        icon: mdi:thermostat
        content: Climate Control
      - type: template
        icon: mdi:home-export
        content: "All Lights Off"
        tap_action:
          action: call-service
          service: light.turn_off
          target:
            entity_id: all
      - type: entity
        entity: switch.e130_dehumidifier_control
        icon: mdi:air-humidifier
        content: Dehumidifier
      - type: template
        icon: mdi:shield-home
        content: Security Mode
        tap_action:
          action: navigate
          navigation_path: "/md3-tablet-dashboard/security"
    style: |
      ha-card {
        background: rgba(255, 255, 255, 0.8);
        backdrop-filter: blur(10px);
        border-radius: 12px;
        margin: 16px;
      }
```

## 🌡️ Page 2: Climate Control

### Climate Control Page
Create `dashboards/md3-tablet/climate-control.yaml`:
```yaml
title: "Climate Control"
path: climate
icon: mdi:thermostat
cards:
  # Climate Command Header
  - type: custom:mushroom-title-card
    title: "🏠 Gulf Coast Climate Command"
    subtitle: "18-Sensor Network + Equipment Control"

  # Main Climate Controls - 3-Column Layout on Tablet
  - type: custom:layout-card
    layout_type: custom:grid-layout
    layout:
      grid-template-columns: repeat(3, 1fr)
      grid-gap: 16px
      margin: 0 16px
    cards:
      # Temperature Overview
      - type: entities
        title: "🌡️ Temperature Network"
        show_header_toggle: false
        entities:
          - entity: sensor.average_house_temperature_enhanced_15_sensor
            name: "House Average"
            icon: mdi:thermometer
            secondary_info: "18 sensors"
          - entity: sensor.hottest_room_temperature
            name: "Hottest Room"
            icon: mdi:thermometer-high
            secondary_info: |
              {{ state_attr('sensor.hottest_room_temperature', 'room') }}
          - entity: sensor.coldest_room_temperature
            name: "Coldest Room"
            icon: mdi:thermometer-low
            secondary_info: |
              {{ state_attr('sensor.coldest_room_temperature', 'room') }}
        card_mod:
          style: |
            ha-card {
              background: linear-gradient(135deg, rgba(33, 150, 243, 0.1), rgba(33, 150, 243, 0.05));
              border-radius: 16px;
              border-left: 4px solid #2196F3;
            }

      # Humidity & Dew Point
      - type: entities
        title: "💧 Humidity Control"
        show_header_toggle: false
        entities:
          - entity: sensor.average_house_humidity_enhanced
            name: "Average Humidity"
            icon: mdi:water-percent
          - entity: sensor.dew_point_average
            name: "Dew Point Average"
            icon: mdi:thermometer-water
          - entity: binary_sensor.high_humidity_alert
            name: "High Humidity Alert"
            icon: mdi:alert
        card_mod:
          style: |
            ha-card {
              background: linear-gradient(135deg, rgba(0, 150, 136, 0.1), rgba(0, 150, 136, 0.05));
              border-radius: 16px;
              border-left: 4px solid #009688;
            }

      # Equipment Status
      - type: entities
        title: "⚖️ Equipment Status"
        show_header_toggle: false
        entities:
          - entity: sensor.equipment_arbitration_status_enhanced
            name: "Arbitration Status"
            icon: mdi:scale-balance
          - entity: climate.ml14xc1
            name: "Lennox AC System"
            icon: mdi:air-conditioner
          - entity: switch.e130_dehumidifier_control
            name: "Aprilaire Dehumidifier"
            icon: mdi:air-humidifier
        card_mod:
          style: |
            ha-card {
              background: linear-gradient(135deg, rgba(255, 152, 0, 0.1), rgba(255, 152, 0, 0.05));
              border-radius: 16px;
              border-left: 4px solid #FF9800;
            }

  # Emergency Controls - Stylized for Gulf Coast
  - type: custom:mushroom-template-card
    primary: "🚨 Emergency Climate Controls"
    secondary: "Critical override buttons for Gulf Coast weather events"
    icon: mdi:alert
    icon_color: red
    layout: horizontal
    card_mod:
      style: |
        ha-card {
          background: rgba(239, 68, 68, 0.1);
          border-left: 4px solid #ef4444;
          border-radius: 12px;
          margin: 16px 0;
        }

  # Emergency Action Buttons
  - type: custom:layout-card
    layout_type: custom:grid-layout
    layout:
      grid-template-columns: repeat(2, 1fr)
      grid-gap: 16px
      margin: 0 16px 16px
    cards:
      - type: custom:button-card
        entity: input_boolean.emergency_humidity_override
        name: "🔄 Humidity Override"
        icon: mdi:water-percent-alert
        color_type: card
        color: red
        style: |
          ha-card {
            --ha-card-border-width: 0;
            --ha-card-box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
            font-size: 14px;
            border-radius: 12px;
          }
      - type: custom:button-card
        entity: input_boolean.emergency_cooling_boost
        name: "❄️ Cooling Boost"
        icon: mdi:snowflake-alert
        color_type: card
        color: blue
        style: |
          ha-card {
            --ha-card-border-width: 0;
            --ha-card-box-shadow: 0 4px 12px rgba(33, 150, 243, 0.3);
            font-size: 14px;
            border-radius: 12px;
          }
```

## 🏡 Page 3: Room Controls

### Room Controls Page
Create `dashboards/md3-tablet/room-controls.yaml`:
```yaml
title: "Room Controls"
path: rooms
icon: mdi:home-heart
cards:
  # Room Overview - Presence-Based
  - type: custom:mushroom-template-card
    primary: |
      [[[ return `Active Rooms: ${states['sensor.active_rooms_count'].state}` ]]]
    secondary: |
      [[[ return `Presence detected in: ${states['sensor.active_rooms_list'].state}` ]]]
    icon: mdi:home-map-marker
    icon_color: primary

  # Dynamic Room Grid - Auto-generated based on presence
  - type: custom:auto-entities
    card:
      type: custom:layout-card
      layout_type: custom:grid-layout
      layout:
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr))
        grid-gap: 16px
        margin: 0 16px
    filter:
      include:
        - group: group.room_groups
          options:
            type: entities
            title: |
              [[[ return entity.attributes.friendly_name ]]]
            show_header_toggle: false
            card_mod:
              style: |
                ha-card {
                  border-radius: 16px;
                  margin: 8px;
                  transition: all 0.3s ease;
                }
                ha-card:hover {
                  transform: translateY(-2px);
                  box-shadow: 0 4px 12px rgba(103, 80, 164, 0.2);
                }

  # Presence Sensors Status
  - type: custom:mushroom-chips-card
    title: "👥 Presence Status"
    alignment: center
    chips:
      - type: template
        content: |
          [[[ return `${states['sensor.home_occupancy_count'].state} people home` ]]]
        icon: mdi:account-multiple
      - type: entity
        entity: binary_sensor.someone_home
        icon: mdi:home-alert
      - type: template
        content: |
          [[[ return `${states('sensor.active_sensors_count')} active rooms` ]]]
        icon: mdi:motion-sensor
```

## 🎨 Tablet Responsive Design Patterns

### Portrait Mode Optimization (768px+)
```yaml
# For tablets in portrait
card_mod:
  style: |
    @media (max-width: 768px) {
      .grid-layout {
        grid-template-columns: 1fr !important;
      }
      ha-card {
        margin: 8px;
      }
    }
```

### Landscape Mode Optimization (1024px+)
```yaml
# For tablets in landscape
card_mod:
  style: |
    @media (min-width: 1024px) {
      .grid-layout {
        grid-template-columns: repeat(3, 1fr) !important;
      }
    }
```

## ✅ Phase 2 Verification

### Functionality Testing
- [ ] Main dashboard loads correctly
- [ ] Navigation between pages works
- [ ] Responsive layouts adapt to tablet orientations
- [ ] Grid layouts render properly
- [ ] Material Design 3 theme applies
- [ ] Touch targets are adequate (48px minimum)
- [ ] Loading times are acceptable (<2 seconds)

### Tablet-Specific Testing
- [ ] Portrait mode displays correctly
- [ ] Landscape mode optimized
- [ ] Touch interactions work smoothly
- [ ] Navigation is thumb-friendly
- [ ] Content is readable without zooming

## 🚀 Next Steps

Proceed to [Phase 3: Material Design 3 Implementation](03-md3-implementation.md) where we'll:
- Implement advanced MD3 styling
- Add dynamic theming capabilities
- Create smooth animations and transitions
- Optimize for tablet interactions

---

**Phase 2 Complete**: Core dashboard structure established with 8 pages, responsive layouts, and tablet-optimized navigation system ready for MD3 styling.