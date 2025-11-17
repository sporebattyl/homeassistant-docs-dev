# Customization Strategy - MD3 Tablet Dashboard

**Last Updated**: 2025-11-10
**Status**: Planning Phase

---

## Overview

This document outlines the customization approach for adapting the ElementZoom MD3 dashboard to Gulf Coast climate priorities, including theme integration, card templates, and unique enhancements leveraging the 18-sensor climate network.

---

## Theme Integration Strategy

### Current Theme Analysis

**Existing Theme**: `themes/md3_enhanced_climate.yaml`

**Status**: ✅ Already MD3-Compliant

**Key Features**:
- **Transparency**: 85% opacity cards (`rgba(255,255,255,0.85)`)
- **Gradients**: Purple-blue (light), blue-teal (dark)
- **Elevation**: 6-level system (0dp - 24dp)
- **Motion**: 3 duration tokens (200ms, 300ms, 500ms) with cubic-bezier easing
- **Spacing**: 5 levels (4px - 24px)
- **Shape**: 5 radii (4px - 28px)
- **WCAG AA**: ≥4.5:1 contrast validated

**Climate-Specific Colors**:
```yaml
climate-success: "#4CAF50"     # 71-75°F, 40-54% RH
climate-warning: "#F57C00"     # 76-77°F, 55-59% RH
climate-error: "#F44336"       # 78°F+, 60% RH+
```

### Material You Theme Integration

**Goal**: Add dynamic color picker while preserving climate-specific colors

**Approach**: Hybrid theme (Material You base + climate overrides)

#### Implementation Strategy

**Step 1**: Install Material You Theme (Week 1)
```bash
# Via HACS UI
# HACS > Frontend > Explore & Download > "Material You Theme"
```

**Step 2**: Create Theme Configuration File

**IMPORTANT**: Home Assistant themes do NOT support inheritance keywords like `extends:` or `base:`. You must copy the entire Material You theme YAML and modify specific variables.

**File**: `themes/md3_climate_material_you.yaml`

```yaml
# Material Design 3 Climate Theme
# Based on Material You Theme with Gulf Coast climate-specific overrides

md3_climate_material_you:
  # ============================================================
  # STEP 1: Copy ALL variables from material_you theme file
  # Location: themes/material_you/*.yaml (find the theme file)
  # Copy the entire variable set here, then modify below
  # ============================================================

  # EXAMPLE: Material You base variables (you must copy actual values)
  primary-color: "#6750A4"  # User-selectable via color picker
  accent-color: "#625B71"
  # ... (50+ more Material You variables - copy from actual theme)

  # ============================================================
  # STEP 2: Override climate-specific variables below
  # ============================================================

  # Climate-specific color overrides (NON-NEGOTIABLE)
  climate-success-color: "#4CAF50"  # 71-75°F, 40-54% RH
  climate-warning-color: "#F57C00"  # 76-77°F, 55-59% RH
  climate-error-color: "#F44336"    # 78°F+, 60% RH+

  # Preserve current transparency system
  card-background-color: "rgba(var(--rgb-primary-background-color), 0.85)"
  ha-card-background: "rgba(var(--rgb-card-background-color), 0.85)"

  # Preserve current gradient backgrounds
  lovelace-background: |
    linear-gradient(135deg,
      rgba(var(--rgb-primary-color), 0.05) 0%,
      rgba(var(--rgb-accent-color), 0.05) 100%)

  # Preserve current elevation system
  ha-card-box-shadow: |
    0 2px 4px rgba(0,0,0,0.1),
    0 4px 8px rgba(0,0,0,0.05)

  # Climate-optimized spacing (from md3_enhanced_climate.yaml)
  # Copy spacing variables from current theme here
```

**Implementation Notes**:
1. Find Material You theme file: `themes/material_you/*.yaml`
2. Copy ENTIRE contents (all ~50+ variables) to `md3_climate_material_you.yaml`
3. Modify only the climate-specific variables shown above
4. Keep Material You's dynamic color system intact
5. Test color picker still works after modification

**Step 3**: Test Material You Color Picker
- Profile → Theme → Select "md3_climate_material_you"
- Verify color picker appears
- Select primary color → Validate climate colors not affected

**Step 4**: Fallback Strategy
- If Material You breaks existing styling:
  - Revert to `md3_enhanced_climate.yaml`
  - Document incompatibilities
  - Use static theme (no color picker)

---

## Card-Mod Styling Patterns

### Preserve from Current Dashboard

**Pattern 1: Emergency Button Template** (Already MD3-Compliant)

```yaml
button_card_templates:
  emergency_button:
    template:
      - base
    size: 60px
    aspect_ratio: 1/1
    tap_action:
      action: call-service
      service: script.[[script]]
    variables:
      color: "[[color]]"
      color_rgb: "[[color_rgb]]"
    styles:
      card:
        - background: "rgba(255, 255, 255, 0.1)"
        - backdrop-filter: "blur(10px)"
        - border-radius: "16px"
        - border: "2px solid rgba([[color_rgb]], 0.3)"
        - transition: "all 0.3s cubic-bezier(0.4, 0.0, 0.2, 1)"
      name:
        - color: "[[color]]"
        - font-weight: "600"
        - font-size: "14px"
      label:
        - color: "var(--secondary-text-color)"
        - font-size: "12px"
    state:
      - value: "on"
        styles:
          card:
            - border: "3px solid [[color]]"
            - background: "rgba([[color_rgb]], 0.2)"
            - box-shadow: "0 0 20px rgba([[color_rgb]], 0.3)"
```

**Usage in MD3 Dashboard**:
```yaml
- type: custom:button-card
  template: emergency_button
  entity: script.emergency_humidity_override
  name: "HUMIDITY OVERRIDE"
  label: "Force 55% target"
  icon: m3o:water_drop
  variables:
    color: "#F44336"
    color_rgb: "244, 67, 54"
    script: emergency_humidity_override
```

**Pattern 2: Transparent Card with Gradient Border**

**Current Usage**: All climate cards in `gulf-coast-climate-optimized.yaml`

```yaml
card_mod:
  style: |
    ha-card {
      background: rgba(255, 255, 255, 0.85);
      border: 1px solid rgba(26, 115, 232, 0.2);
      border-radius: 16px;
      box-shadow:
        0 2px 4px rgba(0,0,0,0.1),
        0 4px 8px rgba(0,0,0,0.05);
      backdrop-filter: blur(10px);
    }
```

**Pattern 3: Markdown Header with Background**

```yaml
- type: markdown
  content: "## 🌡️ Climate Overview"
  card_mod:
    style: |
      ha-card {
        background: linear-gradient(135deg, rgba(25, 118, 210, 0.1), rgba(3, 218, 198, 0.1));
        border-left: 4px solid #1976d2;
        border-radius: 12px;
        padding: 8px 16px;
      }
      ha-markdown {
        font-size: 20px !important;
        font-weight: 600 !important;
        color: #1976d2 !important;
      }
```

### New MD3-Specific Patterns

**Pattern 4: Mushroom Card State Colors (Climate-Aware)**

```yaml
- type: custom:mushroom-entity-card
  entity: sensor.climate_living_temperature
  name: "Living Room"
  icon: m3o:thermometer
  card_mod:
    style: |
      :host {
        {% set temp = states('sensor.climate_living_temperature') | float %}
        {% if temp >= 71 and temp <= 75 %}
          --card-mod-icon-color: #4CAF50;
        {% elif temp > 75 and temp <= 77 %}
          --card-mod-icon-color: #F57C00;
        {% else %}
          --card-mod-icon-color: #F44336;
        {% endif %}
      }
```

**Pattern 5: ApexCharts with Comfort Zone Shading**

```yaml
- type: custom:apexcharts-card
  header:
    show: true
    title: "18-Sensor Climate Network"
  graph_span: 4h
  series:
    - entity: sensor.climate_living_temperature
      name: "Living Room"
      color: "#1976d2"
    # (Additional 17 sensors...)
  apex_config:
    chart:
      background: "transparent"
    yaxis:
      min: 68
      max: 78
    annotations:
      yaxis:
        - y: 71
          y2: 75
          fillColor: "#4CAF50"
          opacity: 0.1
          label:
            text: "Comfort Zone"
            style:
              color: "#4CAF50"
```

---

## Gulf Coast Enhancements

### Enhancement 1: Dew Point Prominence

**Rationale**: Gulf Coast humidity management requires dew point monitoring

**Implementation**: Dew point cards on all climate room pages

```yaml
- type: custom:mushroom-entity-card
  entity: sensor.climate_living_dew_point
  name: "Dew Point"
  icon: m3o:water_drop
  card_mod:
    style: |
      :host {
        {% set dp = states('sensor.climate_living_dew_point') | float %}
        {% if dp < 60 %}
          --card-mod-icon-color: #4CAF50;  /* Comfortable */
        {% elif dp >= 60 and dp < 65 %}
          --card-mod-icon-color: #F57C00;  /* Borderline */
        {% else %}
          --card-mod-icon-color: #F44336;  /* Uncomfortable */
        {% endif %}
      }
  secondary_info: |
    {% set dp = states('sensor.climate_living_dew_point') | float %}
    {% if dp < 55 %}
      Dry - Consider humidification
    {% elif dp >= 55 and dp < 60 %}
      Comfortable
    {% elif dp >= 60 and dp < 65 %}
      Borderline - Monitor
    {% elif dp >= 65 and dp < 70 %}
      Muggy - Dehumidify
    {% else %}
      Oppressive - Emergency dehumidification
    {% endif %}
```

### Enhancement 2: Equipment Arbitration Status Display

**Rationale**: AC/dehumidifier mutual exclusion is critical safety feature

**Implementation**: Status chip on Overview page

```yaml
- type: custom:mushroom-chips-card
  chips:
    - type: entity
      entity: sensor.equipment_arbitration_status_enhanced
      icon: m3o:settings
      card_mod:
        style: |
          :host {
            {% set status = states('sensor.equipment_arbitration_status_enhanced') %}
            {% if 'violation' in status.lower() %}
              --chip-background: rgba(244, 67, 54, 0.2);
              --chip-border-color: #F44336;
            {% elif 'ac_active' in status.lower() %}
              --chip-background: rgba(25, 118, 210, 0.2);
              --chip-border-color: #1976d2;
            {% elif 'dehumidifier_active' in status.lower() %}
              --chip-background: rgba(3, 218, 198, 0.2);
              --chip-border-color: #03dac6;
            {% else %}
              --chip-background: rgba(76, 175, 80, 0.2);
              --chip-border-color: #4CAF50;
            {% endif %}
          }
      tap_action:
        action: more-info
```

### Enhancement 3: Energy Savings Metrics

**Rationale**: $548/year savings from climate optimizations (documented in project overview)

**Implementation**: Energy dashboard card on System view

```yaml
- type: vertical-stack
  cards:
    - type: markdown
      content: "## 💰 Energy Savings (Gulf Coast Climate Optimization)"
    - type: custom:mushroom-entity-card
      entity: sensor.climate_energy_savings_daily
      name: "Daily Savings"
      icon: m3o:attach_money
      secondary_info: "Estimated vs baseline HVAC usage"
    - type: custom:mushroom-entity-card
      entity: sensor.climate_energy_savings_monthly
      name: "Monthly Savings"
      secondary_info: "18-sensor network + equipment arbitration"
    - type: custom:mushroom-entity-card
      entity: sensor.climate_energy_savings_annual
      name: "Annual Savings"
      secondary_info: "$548/year documented (2025-11-10)"
```

### Enhancement 4: WAQI Air Quality Integration

**Status**: ✅ **WORKING - Manual REST Sensors** (implemented 2025-11-14)

**Solution**: Bypassed broken HA integration with manual REST sensors
- **Package**: `packages/waqi_manual_sensors.yaml`
- **Entities**: 9 sensors from Station #179 (Seabrook Friendship Park, Houston, TX)
- **Dashboard Impact**: Air quality chips NOW AVAILABLE for Overview and Calendar views

**Implementation** (ready for Phase 3):

```yaml
# Overview Page - Weather Section
- type: custom:mushroom-chips-card
  chips:
    - type: entity
      entity: sensor.waqi_seabrook_aqi  # Working via manual REST sensor
      icon: mdi:air-filter
      content_info: state
      card_mod:
        style: |
          :host {
            {% set aqi = states('sensor.waqi_seabrook_aqi') | int %}
            {% if aqi <= 50 %}
              --chip-background: rgba(76, 175, 80, 0.2);  /* Good */
            {% elif aqi <= 100 %}
              --chip-background: rgba(255, 235, 59, 0.2);  /* Moderate */
            {% elif aqi <= 150 %}
              --chip-background: rgba(255, 152, 0, 0.2);  /* Unhealthy for Sensitive */
            {% elif aqi <= 200 %}
              --chip-background: rgba(244, 67, 54, 0.2);  /* Unhealthy */
            {% else %}
              --chip-background: rgba(156, 39, 176, 0.2);  /* Very Unhealthy/Hazardous */
            {% endif %}
          }
      tap_action:
        action: more-info
    - type: entity
      entity: sensor.waqi_seabrook_pm2_5  # Working via manual REST sensor
      icon: mdi:grain
      content_info: state
      tap_action:
        action: more-info

# Calendar Page - Detailed Air Quality
- type: custom:mushroom-entity-card
  entity: sensor.waqi_seabrook_aqi_category  # Good/Moderate/Unhealthy/etc.
  icon: mdi:emoticon-happy  # Changes based on AQI level
  tap_action:
    action: more-info
```

**Available Entities**:
- `sensor.waqi_seabrook_aqi` - Primary AQI (0-500)
- `sensor.waqi_seabrook_aqi_category` - Text category
- `sensor.waqi_seabrook_pm2_5` - PM2.5 µg/m³
- `sensor.waqi_seabrook_ozone` - O3 ppb
- `sensor.waqi_seabrook_no2` - NO2 ppb

### Enhancement 5: Humidity-First Design

**Rationale**: Gulf Coast climate requires humidity as primary concern (temperature secondary)

**Implementation**: Humidity displayed equal prominence to temperature

**All Room Cards**:
```yaml
- type: custom:mushroom-entity-card
  entity: sensor.climate_living_temperature
  name: "Living Room"
  layout: horizontal
  primary_info: name
  secondary_info: state
  icon: m3o:thermometer

- type: custom:mushroom-entity-card
  entity: sensor.climate_living_humidity
  name: "Living Room Humidity"
  layout: horizontal
  primary_info: name
  secondary_info: state
  icon: m3o:water_percent
  # Equal size, side-by-side (not stacked)
```

---

## Decluttering Templates

### Template 1: Room Summary Card

**Purpose**: Reusable room climate summary (temperature + humidity + dew point)

```yaml
# ⚠️ CORRECTED SYNTAX - card-mod cannot use decluttering variables inside states()
decluttering_templates:
  room_summary:
    card:
      type: custom:stack-in-card
      cards:
        - type: custom:mushroom-title-card
          title: "[[room_name]]"
          subtitle: "[[room_subtitle]]"
        - type: horizontal-stack
          cards:
            - type: custom:mushroom-entity-card
              entity: "[[temp_entity]]"
              name: "Temperature"
              icon: m3o:thermometer
              card_mod:
                style: |
                  :host {
                    /* ✅ FIXED: Use config.entity instead of states('[[temp_entity]]') */
                    {% set temp = config.entity | state | float %}
                    {% if temp >= 71 and temp <= 75 %}
                      --card-mod-icon-color: #4CAF50;
                    {% elif temp > 75 and temp <= 77 %}
                      --card-mod-icon-color: #F57C00;
                    {% else %}
                      --card-mod-icon-color: #F44336;
                    {% endif %}
                  }
            - type: custom:mushroom-entity-card
              entity: "[[humidity_entity]]"
              name: "Humidity"
              icon: m3o:water_percent
              card_mod:
                style: |
                  :host {
                    /* ✅ FIXED: Use config.entity instead of states('[[humidity_entity]]') */
                    {% set hum = config.entity | state | float %}
                    {% if hum >= 40 and hum <= 54 %}
                      --card-mod-icon-color: #4CAF50;
                    {% elif hum > 54 and hum <= 59 %}
                      --card-mod-icon-color: #F57C00;
                    {% else %}
                      --card-mod-icon-color: #F44336;
                    {% endif %}
                  }
        - type: custom:mushroom-entity-card
          entity: "[[dew_point_entity]]"
          name: "Dew Point"
          icon: m3o:water_drop
```

**⚠️ IMPORTANT SYNTAX NOTE**:
- **WRONG**: `{% set temp = states('[[temp_entity]]') | float %}`
  - Decluttering `[[variables]]` are NOT evaluated inside Jinja2 `{% %}` blocks
  - This will literally try to get state of entity called "[[temp_entity]]" (fails)
- **CORRECT**: `{% set temp = config.entity | state | float %}`
  - `config.entity` accesses the card's configured entity (already substituted by decluttering)
  - Works correctly with decluttering template variables

**Usage**:
```yaml
- type: custom:decluttering-card
  template: room_summary
  variables:
    - room_name: "Living Room"
    - room_subtitle: "Main living area"
    - temp_entity: sensor.climate_living_temperature
    - humidity_entity: sensor.climate_living_humidity
    - dew_point_entity: sensor.climate_living_dew_point
```

### Template 2: Emergency Button (Reuse Existing)

**Preserve from current dashboard** (already documented above)

### Template 3: Climate Gauge (Circular Progress)

**Purpose**: Visual temperature/humidity gauge

```yaml
decluttering_templates:
  climate_gauge:
    card:
      type: custom:mushroom-entity-card
      entity: "[[entity]]"
      name: "[[name]]"
      icon: "[[icon]]"
      layout: vertical
      primary_info: state
      secondary_info: name
      card_mod:
        style: |
          ha-card {
            position: relative;
          }
          ha-card::before {
            content: "";
            position: absolute;
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 4px solid;
            border-color: [[color]];
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            opacity: 0.3;
          }
```

---

## Icon Strategy

### Icon Prefix Migration

**Current**: MDI icons (`mdi:` prefix)
**MD3**: Material Symbols (`m3o:` prefix for outlined, `m3of:` for filled)

**Migration Map** (Key Icons):

| Current MDI | MD3 Replacement | Use Case |
|-------------|-----------------|----------|
| `mdi:home` | `m3o:home` | Home/Overview |
| `mdi:thermometer` | `m3o:thermometer` | Temperature |
| `mdi:water-percent` | `m3o:water_percent` | Humidity |
| `mdi:air-conditioner` | `m3o:ac_unit` | AC control |
| `mdi:shield-home` | `m3o:security` | Alarm |
| `mdi:camera` | `m3o:videocam` | Cameras |
| `mdi:calendar` | `m3o:calendar_month` | Calendar |
| `mdi:lightbulb` | `m3o:lightbulb` | Lights/Scenes |
| `mdi:cog` | `m3o:settings` | System |

**Fallback Strategy**: If Material Symbols installation fails, use MDI icons

### Icon Fallback Map

If Material Symbols fails to install, load, or render correctly, use this map to convert to MDI icons.

#### Conversion Table

| Material Symbol | MDI Fallback | Usage | Priority | Views Using |
|-----------------|--------------|-------|----------|-------------|
| `m3o:home` | `mdi:home` | Overview/navbar | CRITICAL | All |
| `m3o:thermometer` | `mdi:thermometer` | Temperature displays | CRITICAL | All rooms |
| `m3o:water_percent` | `mdi:water-percent` | Humidity displays | CRITICAL | All rooms |
| `m3o:water_drop` | `mdi:water` | Dew point displays | CRITICAL | All rooms |
| `m3o:ac_unit` | `mdi:air-conditioner` | AC/cooling controls | HIGH | Overview, rooms |
| `m3o:security` | `mdi:shield-home` | Alarm/security | HIGH | Security view |
| `m3o:videocam` | `mdi:camera` | Camera feeds | HIGH | Security view |
| `m3o:calendar_month` | `mdi:calendar` | Calendar views | HIGH | Calendar view |
| `m3o:lightbulb` | `mdi:lightbulb` | Lights/scenes | MEDIUM | Scenes, rooms |
| `m3o:settings` | `mdi:cog` | System/config | MEDIUM | System view |
| `m3o:living` | `mdi:sofa` | Living room | LOW | Living view |
| `m3o:bed` | `mdi:bed` | Bedrooms | LOW | Master/Guest |
| `m3o:child_care` | `mdi:baby-carriage` | Rowan's room | LOW | Rowan view |
| `m3o:work` | `mdi:desk` | Office | LOW | Office view |
| `m3o:hotel` | `mdi:bed-empty` | Guest room | LOW | Guest view |

#### Bulk Replacement Commands

**Option 1: Replace ALL Material Symbols icons**
```bash
# Backup first
cp dashboards/ui-lovelace-tablet-md3.yaml dashboards/ui-lovelace-tablet-md3.yaml.backup

# Replace all m3o: with mdi:
sed -i 's/icon: m3o:/icon: mdi:/g' dashboards/ui-lovelace-tablet-md3.yaml
sed -i 's/icon: m3of:/icon: mdi:/g' dashboards/ui-lovelace-tablet-md3.yaml  # filled variant
sed -i 's/icon: m3or:/icon: mdi:/g' dashboards/ui-lovelace-tablet-md3.yaml  # rounded variant

# Validate
ha-validate

# If validation passes, commit
git add dashboards/ui-lovelace-tablet-md3.yaml
git commit -m "Fallback: Replace Material Symbols with MDI icons

Material Symbols component failed to load/render.
Replaced all m3o:/m3of:/m3or: icons with mdi: equivalents.

🤖 Generated with Claude Code"
```

**Option 2: Replace ONLY broken icons**
```bash
# Example: Only thermometer icon broken
sed -i 's/m3o:thermometer/mdi:thermometer/g' dashboards/ui-lovelace-tablet-md3.yaml

# Example: Multiple icons broken
sed -i 's/m3o:thermometer/mdi:thermometer/g; s/m3o:water_percent/mdi:water-percent/g' dashboards/ui-lovelace-tablet-md3.yaml
```

**Option 3: Manual replacement via editor**
- Open `dashboards/ui-lovelace-tablet-md3.yaml`
- Find: `icon: m3o:` → Replace: `icon: mdi:`
- Save, validate, commit

#### Testing Fallback Icons

After replacement:
1. Clear browser cache (Ctrl+Shift+R)
2. Navigate to dashboard
3. Check all icons render (not broken image boxes)
4. Verify icon meanings still clear (mdi: icons similar to m3o:)

#### Reverting to Material Symbols

If Material Symbols is fixed later:
```bash
# Restore from backup
cp dashboards/ui-lovelace-tablet-md3.yaml.backup dashboards/ui-lovelace-tablet-md3.yaml

# Or reverse replacement
sed -i 's/icon: mdi:home/icon: m3o:home/g' dashboards/ui-lovelace-tablet-md3.yaml
# (repeat for each icon)

# Validate, commit
ha-validate
git add dashboards/ui-lovelace-tablet-md3.yaml
git commit -m "Restore Material Symbols icons"
```

#### Prevention

To avoid needing fallback:
- Test Material Symbols on pattern test dashboard FIRST
- Check HACS for Material Symbols updates before HA updates
- Monitor Home Assistant release notes for breaking changes

---

## Animation & Motion

### Material Design 3 Motion Tokens

**Current Theme**: Already defines motion tokens
```yaml
# From md3_enhanced_climate.yaml
motion-duration-short: "200ms"
motion-duration-medium: "300ms"
motion-duration-long: "500ms"
motion-easing-standard: "cubic-bezier(0.4, 0.0, 0.2, 1)"
```

**Apply to MD3 Dashboard**:

**Card Transitions**:
```yaml
card_mod:
  style: |
    ha-card {
      transition: all var(--motion-duration-medium) var(--motion-easing-standard);
    }
    ha-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }
```

**Button Ripple** (Material Components):
```yaml
# Applied automatically by Mushroom cards and Material Components
# No custom CSS needed
```

**Page Transitions** (Navbar):
```yaml
# Configure in navbar-card
transition:
  duration: 300
  easing: "cubic-bezier(0.4, 0.0, 0.2, 1)"
```

---

## Color-Coding System

### Climate State Colors (Comprehensive)

**Temperature Ranges** (°F):
| Range | Color | Hex | Usage |
|-------|-------|-----|-------|
| < 68 | Blue | `#2196F3` | Too cold |
| 68-70 | Light Blue | `#03A9F4` | Cool |
| 71-75 | Green | `#4CAF50` | Comfortable ✅ |
| 76-77 | Amber | `#F57C00` | Warm |
| 78+ | Red | `#F44336` | Too hot |

**Humidity Ranges** (%):
| Range | Color | Hex | Usage |
|-------|-------|-----|-------|
| < 35 | Orange | `#FF9800` | Too dry |
| 35-39 | Yellow | `#FFC107` | Dry |
| 40-54 | Green | `#4CAF50` | Comfortable ✅ |
| 55-59 | Amber | `#F57C00` | Humid |
| 60+ | Red | `#F44336` | Too humid |

**Dew Point Ranges** (°F):
| Range | Color | Hex | Description |
|-------|-------|-----|-------------|
| < 55 | Yellow | `#FFC107` | Dry |
| 55-59 | Green | `#4CAF50` | Comfortable ✅ |
| 60-64 | Amber | `#F57C00` | Borderline |
| 65-69 | Orange | `#FF9800` | Muggy |
| 70+ | Red | `#F44336` | Oppressive |

**Equipment Status Colors**:
| Status | Color | Hex | Usage |
|--------|-------|-----|-------|
| AC Active | Blue | `#1976d2` | Cooling mode |
| Dehumidifier Active | Teal | `#03dac6` | Dehumidifying |
| Both Off | Green | `#4CAF50` | Normal |
| Arbitration Violation | Red | `#F44336` | ERROR - Both on |

---

## Typography

### Font System

**Material Design 3 Scale**:
- Display Large: 57px / 64px (Headlines only)
- **Headline Large**: 32px / 40px (Page titles)
- **Title Large**: 22px / 28px (Section headers)
- **Body Large**: 16px / 24px (Default text)
- **Label Medium**: 12px / 16px (Captions, labels)

**Current Theme**: Uses system fonts (Roboto on Android, San Francisco on iOS, Segoe UI on Windows)

**Preserve**: No custom fonts (performance + KISS principles)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2025-11-10 | Initial customization strategy documentation | Claude |

---

## Related Documents

- `00-project-overview.md` - Project goals
- `03-view-architecture.md` - View layouts using these styles
- `05-implementation-phases.md` - Theme integration timeline

---

**Next Steps**: Create decluttering templates file in dashboard YAML, test Material You Theme installation
