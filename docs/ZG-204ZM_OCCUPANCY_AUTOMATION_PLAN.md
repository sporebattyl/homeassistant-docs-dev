# ZG-204ZM Occupancy Automation Implementation Plan

## Project Overview

Create a **standalone occupancy detection system** using 15 ZG-204ZM sensors that provides state entities for existing climate automations to consume, following KISS principles for single-home power user configuration.

**Key Requirements:**
- ✅ Standalone occupancy automation (completely separate from climate)
- ✅ Provides state entities for OTHER automations to consume
- ✅ Current automations respond to occupancy + location + other sensors
- ✅ KISS principles for 2,386 sq ft single home power user
- ✅ Ultra-deep architectural thinking with Gemini collaboration

## ZG-204ZM Sensor Research Summary

### Technical Specifications
- **Model**: ZG-204ZM (Tuya ID: _TZE200_2aaelwxk)  
- **Protocol**: Zigbee 3.0
- **Power**: 2x AAA batteries (~6 months life)
- **Detection**: Dual PIR + 24GHz mmWave radar (HLK-LD2410S chip)
- **Range**: 0-6m static presence, 0-10m motion detection
- **Coverage**: ±60° horizontal (120° total)
- **Battery-Powered**: First-ever battery Zigbee occupancy sensor with mmWave

### Integration Requirements
- **Recommended**: Zigbee2MQTT (full parameter control)
- **Avoid**: ZHA (limited functionality, no occupancy cluster)
- **Configuration**: 30s minimum fading time, PIR+Radar mode recommended
- **Network**: Requires adequate Zigbee router density (1 router per 2-3 EndDevices)

## Current Home Assistant Analysis

### Existing Motion Sensors
```yaml
# Currently referenced in climate packages:
- binary_sensor.living_room_motion
- binary_sensor.kitchen_motion  
- binary_sensor.office_motion
- binary_sensor.bedroom_motion
- binary_sensor.guest_room_motion
- binary_sensor.guest_bathroom_motion
```

### Device Tracking
```yaml
- device_tracker.drews_iphone
```

### Occupancy Control Systems
- **Primary**: `input_select.climate_occupancy_mode` (Home/Away/Guest/Sleep)
- **Legacy**: `input_select.foundation_occupancy_mode` (home/away/sleep/vacation/guest)

## Sensor Placement Strategy (15 ZG-204ZM Sensors)

### Primary Activity Zones (6 sensors)
1. **occupancy_living_room** - Main living area
2. **occupancy_kitchen** - Kitchen/dining area  
3. **occupancy_master_bedroom** - Primary bedroom
4. **occupancy_office** - Home office/study
5. **occupancy_guest_bedroom** - Guest room
6. **occupancy_master_bathroom** - Primary bathroom

### Secondary Coverage Zones (5 sensors)
7. **occupancy_guest_bathroom** - Guest bathroom
8. **occupancy_dining_area** - Formal dining area
9. **occupancy_main_hallway** - Central traffic monitoring
10. **occupancy_entry_foyer** - Front entrance detection
11. **occupancy_laundry_utility** - Utility/laundry room

### Enhanced Coverage Zones (4 sensors)
12. **occupancy_kitchen_island** - Kitchen island/prep area
13. **occupancy_living_room_secondary** - Secondary living coverage  
14. **occupancy_master_suite_entrance** - Master suite hallway
15. **occupancy_back_patio_door** - Back entrance monitoring

## Standalone Occupancy Package Architecture

### Package Structure: `packages/occupancy_detection_standalone.yaml`

#### 1. Feature Flags (KISS Principle)
```yaml
input_boolean:
  occupancy_system_enabled:
    name: "Occupancy Detection System"
    icon: mdi:motion-sensor
    initial: true
  
  occupancy_zone_learning_mode:
    name: "Zone Learning Mode" 
    icon: mdi:school
    initial: false

  occupancy_high_sensitivity_mode:
    name: "High Sensitivity Mode"
    icon: mdi:radar
    initial: false
```

#### 2. Zone Configuration
```yaml
input_select:
  occupancy_sensitivity_level:
    name: "Occupancy Detection Sensitivity"
    options:
      - "Low"      # Conservative detection
      - "Medium"   # Balanced (default)
      - "High"     # Aggressive detection
    initial: "Medium"
    icon: mdi:tune
```

#### 3. State Entities for Consumption

##### Zone Occupancy States
```yaml
template:
  - binary_sensor:
      - name: "Zone Living Area Occupied"
        unique_id: zone_living_area_occupied
        state: >
          {{ is_state('binary_sensor.occupancy_living_room', 'on') or
             is_state('binary_sensor.occupancy_kitchen', 'on') or
             is_state('binary_sensor.occupancy_dining_area', 'on') or
             is_state('binary_sensor.occupancy_living_room_secondary', 'on') }}
        
      - name: "Zone Bedroom Area Occupied"
        unique_id: zone_bedroom_area_occupied
        state: >
          {{ is_state('binary_sensor.occupancy_master_bedroom', 'on') or
             is_state('binary_sensor.occupancy_master_bathroom', 'on') or
             is_state('binary_sensor.occupancy_master_suite_entrance', 'on') }}
        
      - name: "Zone Guest Area Occupied"
        unique_id: zone_guest_area_occupied
        state: >
          {{ is_state('binary_sensor.occupancy_guest_bedroom', 'on') or
             is_state('binary_sensor.occupancy_guest_bathroom', 'on') }}
        
      - name: "Zone Office Area Occupied"
        unique_id: zone_office_area_occupied
        state: >
          {{ is_state('binary_sensor.occupancy_office', 'on') }}

      - name: "Zone Service Areas Occupied"
        unique_id: zone_service_areas_occupied
        state: >
          {{ is_state('binary_sensor.occupancy_laundry_utility', 'on') or
             is_state('binary_sensor.occupancy_main_hallway', 'on') }}
```

##### House-Level Intelligence
```yaml
  - sensor:
      - name: "House Occupancy Level"
        unique_id: house_occupancy_level
        state: >
          {% if not is_state('input_boolean.occupancy_system_enabled', 'on') %}
            disabled
          {% else %}
            {% set zones = [
              'binary_sensor.zone_living_area_occupied',
              'binary_sensor.zone_bedroom_area_occupied', 
              'binary_sensor.zone_guest_area_occupied',
              'binary_sensor.zone_office_area_occupied'
            ] %}
            {% set active = zones | select('is_state', 'on') | list | length %}
            {% if active == 0 %}vacant
            {% elif active == 1 %}minimal
            {% elif active == 2 %}moderate  
            {% elif active >= 3 %}active
            {% endif %}
          {% endif %}
        icon: >
          {% set level = this.state %}
          {% if level == 'disabled' %}mdi:motion-sensor-off
          {% elif level == 'vacant' %}mdi:home-outline
          {% elif level == 'minimal' %}mdi:home
          {% elif level == 'moderate' %}mdi:home-account
          {% else %}mdi:account-multiple-plus
          {% endif %}
          
      - name: "Last Motion Location"
        unique_id: last_motion_location
        state: >
          {% if not is_state('input_boolean.occupancy_system_enabled', 'on') %}
            disabled
          {% else %}
            {% set sensors = [
              ('living_room', 'binary_sensor.occupancy_living_room'),
              ('kitchen', 'binary_sensor.occupancy_kitchen'),
              ('master_bedroom', 'binary_sensor.occupancy_master_bedroom'),
              ('office', 'binary_sensor.occupancy_office'),
              ('guest_bedroom', 'binary_sensor.occupancy_guest_bedroom'),
              ('master_bathroom', 'binary_sensor.occupancy_master_bathroom'),
              ('guest_bathroom', 'binary_sensor.occupancy_guest_bathroom'),
              ('entry_foyer', 'binary_sensor.occupancy_entry_foyer'),
              ('main_hallway', 'binary_sensor.occupancy_main_hallway')
            ] %}
            {% set active = sensors | selectattr('1', 'is_state', 'on') | list %}
            {% if active | length > 0 %}
              {{ active | map(attribute='0') | list | join(', ') }}
            {% else %}
              no_recent_activity
            {% endif %}
          {% endif %}
```

##### Occupancy Confidence Scoring
```yaml
      - name: "Occupancy Confidence Score"
        unique_id: occupancy_confidence_score
        unit_of_measurement: "%"
        state: >
          {% if not is_state('input_boolean.occupancy_system_enabled', 'on') %}
            0
          {% else %}
            {% set motion_score = 40 if states('sensor.house_occupancy_level') != 'vacant' else 0 %}
            {% set device_score = 30 if is_state('device_tracker.drews_iphone', 'home') else 0 %}
            {% set time_score = 20 if 6 <= now().hour <= 23 else 10 %}
            {% set pattern_score = 10 %} {# Base activity pattern score #}
            {% set total = motion_score + device_score + time_score + pattern_score %}
            {{ total }}
          {% endif %}
        icon: >
          {% set score = this.state | int(0) %}
          {% if score >= 80 %}mdi:shield-check
          {% elif score >= 60 %}mdi:shield
          {% elif score >= 40 %}mdi:shield-half-full
          {% else %}mdi:shield-off
          {% endif %}
        attributes:
          motion_contribution: >
            {% if states('sensor.house_occupancy_level') != 'vacant' %}40{% else %}0{% endif %}
          device_contribution: >
            {% if is_state('device_tracker.drews_iphone', 'home') %}30{% else %}0{% endif %}
          time_contribution: >
            {% if 6 <= now().hour <= 23 %}20{% else %}10{% endif %}
          pattern_contribution: "10"
```

##### High-Confidence Detection
```yaml
      - name: "House Occupied High Confidence"
        unique_id: house_occupied_high_confidence  
        device_class: occupancy
        state: >
          {% if not is_state('input_boolean.occupancy_system_enabled', 'on') %}
            off
          {% else %}
            {% set confidence = states('sensor.occupancy_confidence_score') | int(0) %}
            {% set threshold = 70 if is_state('input_boolean.occupancy_high_sensitivity_mode', 'off') else 60 %}
            {{ 'on' if confidence >= threshold else 'off' }}
          {% endif %}
```

## Integration with Existing Climate System

### Clean Separation Architecture

**State Provider Pattern:**
- Occupancy system provides states → Climate system consumes them
- No modification of core climate logic, only enhanced input sources  
- Existing `input_select.climate_occupancy_mode` remains as manual override
- Full backward compatibility with current automations

### Climate Integration Points

#### Enhanced House Occupancy Status
Modify `packages/climate_occupancy_automation_master.yaml`:

```yaml
template:
  - sensor:
      - name: "Enhanced House Occupancy Status"
        unique_id: enhanced_house_occupancy_status
        state: >
          {% if is_state('input_boolean.use_unified_occupancy_automation', 'on') %}
            {% set standalone_level = states('sensor.house_occupancy_level') %}
            {% set confidence = states('sensor.occupancy_confidence_score') | int(0) %}
            {% set phone_home = is_state('device_tracker.drews_iphone', 'home') %}
            {% set high_confidence_occupied = is_state('binary_sensor.house_occupied_high_confidence', 'on') %}
            
            {% if standalone_level == 'vacant' and not phone_home and confidence < 40 %}
              Away
            {% elif states('binary_sensor.zone_bedroom_area_occupied') == 'on' and now().hour >= 22 %}
              Sleep  
            {% elif states('binary_sensor.zone_guest_area_occupied') == 'on' %}
              Guest
            {% elif standalone_level in ['moderate', 'active'] or high_confidence_occupied %}
              Home
            {% elif phone_home and confidence >= 30 %}
              Home
            {% else %}
              Home  # Conservative default
            {% endif %}
          {% else %}
            {{ states('sensor.house_occupancy_status_unified') }}
          {% endif %}
```

#### Guest Detection Enhancement
```yaml
      - name: "Enhanced Guest Detection Intelligence"
        unique_id: enhanced_guest_detection_with_zones
        state: >
          {% set guest_zone_active = is_state('binary_sensor.zone_guest_area_occupied', 'on') %}
          {% set guest_confidence = guest_zone_active %}
          {% set owner_home = is_state('device_tracker.drews_iphone', 'home') %}
          {% set unusual_patterns = states('sensor.last_motion_location') in ['guest_bedroom', 'guest_bathroom'] %}
          
          {% if guest_zone_active %}
            Guest Presence Confirmed  
          {% elif unusual_patterns and not owner_home %}
            Potential Guest Activity (Owner Away)
          {% elif unusual_patterns and (now().hour >= 23 or now().hour <= 6) %}
            Possible Guest Activity Detected
          {% else %}
            No Guest Activity Detected  
          {% endif %}
```

## KISS Implementation Features

### Power User Controls
- **Master Control**: `input_boolean.occupancy_system_enabled`
- **Learning Mode**: `input_boolean.occupancy_zone_learning_mode`
- **Sensitivity**: `input_select.occupancy_sensitivity_level`
- **High Sensitivity**: `input_boolean.occupancy_high_sensitivity_mode`
- **Manual Override**: Always available through existing climate controls

### Simple Configuration Approach
- Pre-configured sensor thresholds optimized for ZG-204ZM
- Zigbee2MQTT integration with full parameter control
- Gulf Coast climate considerations (humidity impact on sensors)
- Conservative defaults with easy adjustment capability

## Deployment Strategy

### Phase 1: Sensor Infrastructure Setup
**Timeline: Week 1**

1. **Zigbee Network Preparation**
   - Install additional Zigbee routers (smart plugs) for mesh density
   - Ensure 1 router per 2-3 EndDevice target ratio
   - Test Zigbee network stability

2. **ZG-204ZM Sensor Installation**
   - Install all 15 sensors with logical naming convention
   - Configure via Zigbee2MQTT:
     - Fading Time: 30 seconds (minimum)
     - Motion Detection Mode: PIR + Radar (combined)
     - Motion Detection Sensitivity: 5/10 (medium start)
     - Static Detection Sensitivity: 5/10 (medium start)
     - LED Indicator: OFF (for discrete operation)

3. **Basic Package Deployment**
   - Create `packages/occupancy_detection_standalone.yaml`
   - Deploy with ALL feature flags set to FALSE/disabled
   - Test individual sensor functionality
   - Validate sensor entity creation and basic states

### Phase 2: Zone Detection Validation  
**Timeline: Week 2**

1. **Enable Core Functionality**
   - Set `input_boolean.occupancy_system_enabled: true`
   - Monitor zone grouping logic for 48-72 hours
   - Test house-level occupancy states
   - Validate occupancy confidence scoring

2. **Threshold Tuning**
   - Adjust individual sensor sensitivity based on real usage
   - Fine-tune zone grouping if needed
   - Monitor false positive/negative rates
   - Document optimal settings per room

3. **Pattern Analysis**
   - Enable `input_boolean.occupancy_zone_learning_mode: true`
   - Collect occupancy pattern data
   - Identify typical daily activity flows
   - Note any problematic detection areas

### Phase 3: Climate System Integration
**Timeline: Week 3**

1. **State Entity Integration**
   - Update `climate_occupancy_automation_master.yaml` to consume new states
   - Test climate system responses to occupancy changes  
   - Validate away/home mode decisions based on occupancy confidence
   - Monitor guest detection accuracy

2. **Integration Testing**
   - Test all occupancy-to-climate mode transitions
   - Validate that manual overrides still work correctly
   - Ensure backward compatibility when occupancy system disabled
   - Monitor for any conflicts or unexpected behaviors

3. **Performance Optimization**
   - Fine-tune occupancy confidence thresholds
   - Adjust sensitivity levels based on climate system feedback
   - Optimize detection timing for climate responsiveness
   - Document final configuration settings

### Phase 4: Advanced Features & Optimization
**Timeline: Week 4**

1. **Enhanced Intelligence**
   - Enable advanced pattern recognition if needed
   - Implement occupancy-based energy optimization suggestions  
   - Add zone-specific occupancy timing analysis
   - Create occupancy-based comfort scoring

2. **Gulf Coast Optimization**
   - Account for humidity impact on sensor performance
   - Optimize detection for Texas climate patterns
   - Consider seasonal adjustment recommendations
   - Document Gulf Coast specific settings

3. **System Validation**
   - Run comprehensive system tests
   - Validate all integration points working correctly
   - Document troubleshooting procedures
   - Create user guide for ongoing management

## Key Benefits Summary

✅ **Complete Separation**: Occupancy system is standalone and independently controllable  
✅ **State Provider Pattern**: Clean interface for other systems to consume occupancy data  
✅ **KISS Compliant**: Simple boolean controls appropriate for single home power user  
✅ **Backward Compatible**: Existing climate system continues unchanged if occupancy disabled  
✅ **Progressive Enhancement**: Can be deployed and tested incrementally with feature flags  
✅ **Manual Override**: Power user retains full control over all automatic decisions  
✅ **Zone Intelligence**: Provides room-level detail for advanced automations  
✅ **High Confidence Detection**: Multi-factor occupancy confidence scoring  
✅ **Gulf Coast Optimized**: Considers local climate impact on sensor performance  

## Files to Create/Modify

### New Files
- **`/packages/occupancy_detection_standalone.yaml`** (~600-700 lines)
  - All 15 ZG-204ZM sensor entities
  - Zone grouping logic
  - House-level state calculations  
  - Occupancy confidence scoring
  - Feature flag architecture
  - KISS control interfaces

### Enhanced Files  
- **`/packages/climate_occupancy_automation_master.yaml`**
  - Add consumption of new occupancy state entities
  - Enhanced guest detection using zone occupancy
  - Improved away/home mode decision logic using confidence scoring
  - Maintain backward compatibility with feature flags

### Optional Enhancements
- Other climate packages can optionally consume occupancy states as needed
- Room-specific automations can leverage individual sensor states
- Energy optimization packages can use zone occupancy for efficiency

## Technical Considerations

### ZG-204ZM Configuration Recommendations
```yaml
# Via Zigbee2MQTT device configuration:
fading_time: 30          # Minimum supported (30-second presence timeout)
motion_detection_mode: 2  # PIR + Radar combined mode
motion_sensitivity: 5     # Medium sensitivity (0-10 scale)
static_detection_distance: 6  # 6 meters maximum for residential
static_detection_sensitivity: 5  # Medium sensitivity 
led_indicator: false     # Disable for discrete operation
illuminance_calibration: 100  # No offset adjustment initially
```

### Zigbee Network Requirements
- **Router Density**: 1 Zigbee router per 2-3 EndDevices (need ~8 smart plugs minimum)
- **Channel Selection**: Use Zigbee channels 20-25 to avoid Wi-Fi interference
- **Network Healing**: Allow 24-48 hours after deployment for mesh optimization
- **Coordinator Position**: Central location for optimal coverage of all 15 sensors

### Gulf Coast Climate Considerations
- **Humidity Impact**: High humidity may affect mmWave performance slightly
- **Temperature Extremes**: Sensors rated for indoor use (avoid direct sun/heat)
- **Seasonal Adjustments**: May need sensitivity tweaking for winter vs summer activity patterns
- **HVAC Coordination**: Position sensors to avoid direct HVAC airflow for stable detection

This comprehensive plan provides a robust, scalable occupancy detection system that integrates cleanly with your existing sophisticated Home Assistant configuration while maintaining the KISS principle and full manual control appropriate for a single home power user.