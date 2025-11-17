# Climate Safety Protocols (Enhanced with 15-Sensor Integration)

**Updated**: September 16, 2025  
**Status**: Phase 2F Complete + Sensor Integration Preparation  
**Critical Focus**: Gulf Coast humidity protection + Equipment arbitration with multi-zone monitoring

*This document details all safety-critical logic for the enhanced climate system with 15 temperature/humidity sensors, focusing on Gulf Coast climate protection and sophisticated equipment coordination.*

---

## 🚨 CRITICAL SAFETY REQUIREMENTS (NON-NEGOTIABLE)

### **60% Humidity Ceiling - Enhanced Multi-Zone Protection**
**Absolute Requirement**: No zone may exceed 60% humidity for >5 minutes  
**Gulf Coast Justification**: Mold prevention in high-humidity League City, TX climate  
**Enhancement**: 15-sensor validation with zone-specific identification and response

#### Multi-Zone Safety Protocol Levels
```yaml
# Safety Protocol Definitions (Enhanced)
Normal Operation:     All 15 zones <60% humidity
Caution Level:        1 zone 60-62% humidity (localized monitoring)
Warning Level:        3+ zones >60% OR 1 zone >62% humidity
Critical Level:       Any zone >65% humidity (emergency dehumidification)
Emergency Level:      Any zone >70% humidity (equipment override + notifications)
```

#### Enhanced Emergency Response Logic
```yaml
# Multi-Zone Emergency Response Framework
sensor:
  humidity_emergency_status_enhanced:
    # Real-time analysis of all 15 zones
    # Triggers: Caution/Warning/Critical/Emergency based on zone analysis
    # Output: Zone identification + severity level + recommended action

automation:
  emergency_humidity_response_enhanced:
    # Trigger: Any sensor >60% for 5+ minutes
    # Action: Zone-specific response with equipment coordination
    # Notification: Mobile alert with zone identification
    # Equipment: Graduated response based on severity level
```

### **Equipment Arbitration - Zone-Aware Coordination**
**Critical Requirement**: Prevent AC/dehumidifier conflicts with sensor-enhanced decision making  
**Equipment**: Lennox ML14XC1 (14 SEER) + Aprilaire E130 dehumidifier  
**Enhancement**: 15-sensor data feeding arbitration logic

#### Enhanced Arbitration Logic
```yaml
# Zone-Aware Equipment Arbitration
Equipment Decision Matrix (Enhanced):
  Emergency Dehumidification:   Any zone >65% → E130 priority + AC coordination
  Coordinated Mode:            Avg humidity >55% + Avg temp >target+2° → Both systems
  AC Priority:                 Avg temp >target+3° + humidity <60% → ML14XC1 only
  Dehumidification Only:       Avg humidity >50% + temp <target-1° → E130 only
  Standby:                     All zones normal → Equipment idle

Zone-Specific Triggers:
  Hot Zone Priority:           Max temp variance >3°F → AC with zone focus
  Humid Zone Priority:         Zone humidity >58% → Dehumidifier with zone focus
  Variance Management:         Temp/humidity variance >threshold → Coordinated response
```

### **Runtime Protection - Gulf Coast Optimized**
**Requirement**: 15-minute minimum runtime + 10-minute cooldown periods  
**Justification**: Equipment protection + effective moisture removal in Gulf Coast climate  
**Enhancement**: Zone feedback optimization for cycle efficiency

---

## 🛡️ ENHANCED SAFETY SYSTEMS ARCHITECTURE

### **Multi-Zone Monitoring Framework**
```yaml
# 15-Sensor Safety Monitoring System
Primary Safety Sensors:
  - sensor.temphumidsensor1_humidity through sensor.temphumidsensor15_humidity
  - sensor.temphumidsensor1_temperature through sensor.temphumidsensor15_temperature

Enhanced Safety Calculations:
  - sensor.average_house_humidity_enhanced (15-sensor average)
  - sensor.highest_humidity_zone_enhanced (zone identification)
  - sensor.humidity_emergency_status_enhanced (multi-level analysis)
  - sensor.temperature_variance_analysis_enhanced (zone variance)
  - sensor.zone_specific_heat_index_enhanced (Gulf Coast optimized)

Equipment Arbitration Enhanced:
  - sensor.equipment_arbitration_status_enhanced (zone-aware decisions)
  - binary_sensor.equipment_mutual_exclusion_active (conflict prevention)
  - sensor.runtime_protection_status (15min/10min cycle monitoring)
```

### **Emergency Response Procedures**

#### Level 1: Caution (1 zone 60-62% humidity)
```yaml
Response Actions:
  1. Increased monitoring frequency (1-minute updates)
  2. Localized air circulation enhancement
  3. Equipment preparation (standby activation)
  4. User notification (info level)

Automation Logic:
  - Monitor specific zone for trend analysis
  - Prepare equipment for potential activation
  - No immediate equipment engagement
  - 15-minute trend evaluation before escalation
```

#### Level 2: Warning (3+ zones >60% OR 1 zone >62%)
```yaml
Response Actions:
  1. Dehumidifier activation (E130)
  2. AC coordination evaluation
  3. Mobile notification (normal priority)
  4. Zone-specific fan activation
  5. 15-minute runtime commitment

Automation Logic:
  - Immediate E130 dehumidifier activation
  - ML14XC1 coordination assessment based on temperature
  - Zone identification in mobile notification
  - Graduated response based on affected zone count
```

#### Level 3: Critical (Any zone >65%)
```yaml
Response Actions:
  1. Emergency dehumidification (E130 priority)
  2. AC coordination (if temperature permits)
  3. High-priority mobile notification with zone ID
  4. All air circulation systems activated
  5. 20-minute runtime commitment (extended)

Automation Logic:
  - Override normal equipment arbitration
  - E130 dehumidifier immediate activation
  - ML14XC1 coordination based on zone analysis
  - Mobile notification includes zone name and severity
  - Extended runtime for effective moisture removal
```

#### Level 4: Emergency (Any zone >70%)
```yaml
Response Actions:
  1. Equipment override (both AC + dehumidifier if needed)
  2. Critical mobile notification + persistent alerts
  3. All circulation systems maximum activation
  4. Continuous monitoring with 30-second updates
  5. 30-minute runtime commitment (maximum)

Automation Logic:
  - Emergency override of all normal logic
  - Both ML14XC1 and E130 activation if temperature permits
  - Critical mobile notification with location details
  - System health monitoring for equipment protection
  - Extended runtime with safety monitoring
```

---

## 🔧 TECHNICAL SAFETY IMPLEMENTATION

### **Enhanced Emergency Scripts**
```yaml
script:
  emergency_dehumidification_enhanced:
    alias: "Enhanced Emergency Dehumidification (Zone-Aware)"
    sequence:
      # Zone identification and severity assessment
      - service: script.assess_humidity_emergency_zones
        response_variable: emergency_assessment
      
      # Mobile notification with zone details
      - service: notify.mobile_app_drewcifer
        data:
          message: >
            🚨 HUMIDITY EMERGENCY: {{ emergency_assessment.primary_zone }} 
            at {{ emergency_assessment.max_humidity }}% 
            ({{ emergency_assessment.affected_zones }} zones affected)
          data:
            tag: "humidity_emergency_enhanced"
            priority: high
            ttl: 0
            persistent: true
      
      # Equipment activation based on severity
      - choose:
          # Critical: Any zone >65%
          - conditions:
              - condition: template
                value_template: "{{ emergency_assessment.max_humidity | float > 65 }}"
            sequence:
              - service: climate.set_preset_mode
                target:
                  entity_id: climate.main_floor
                data:
                  preset_mode: "dehumidify"
              - service: switch.turn_on
                target:
                  entity_id: switch.aprilaire_e130_dehumidifier
              - delay: "00:20:00"  # Extended runtime for critical
          
          # Warning: Multiple zones >60%
          - conditions:
              - condition: template
                value_template: "{{ emergency_assessment.affected_zones | int >= 3 }}"
            sequence:
              - service: switch.turn_on
                target:
                  entity_id: switch.aprilaire_e130_dehumidifier
              - delay: "00:15:00"  # Standard Gulf Coast runtime
          
          # Default: Single zone response
          default:
            - service: switch.turn_on
              target:
                entity_id: switch.aprilaire_e130_dehumidifier
            - service: fan.turn_on
              target:
                entity_id: "fan.{{ emergency_assessment.primary_zone | lower | replace(' ', '_') }}"
            - delay: "00:15:00"
      
      # Validation and follow-up
      - service: script.validate_humidity_improvement_enhanced
        data:
          initial_assessment: "{{ emergency_assessment }}"

  assess_humidity_emergency_zones:
    alias: "Assess Humidity Emergency Zones"
    sequence:
      - service: template
        response_variable: zone_analysis
        value_template: >
          {%- set humidity_data = [
            ('Living Room', states('sensor.temphumidsensor1_humidity') | float),
            ('Kitchen', states('sensor.temphumidsensor2_humidity') | float),
            ('Master Bedroom', states('sensor.temphumidsensor3_humidity') | float),
            ('Office', states('sensor.temphumidsensor4_humidity') | float),
            ('Guest Bedroom', states('sensor.temphumidsensor5_humidity') | float),
            ('Bathroom 1', states('sensor.temphumidsensor6_humidity') | float),
            ('Bathroom 2', states('sensor.temphumidsensor7_humidity') | float),
            ('Dining Room', states('sensor.temphumidsensor8_humidity') | float),
            ('Laundry Room', states('sensor.temphumidsensor9_humidity') | float),
            ('Garage Entry', states('sensor.temphumidsensor10_humidity') | float),
            ('Hallway', states('sensor.temphumidsensor11_humidity') | float),
            ('Utility Room', states('sensor.temphumidsensor12_humidity') | float),
            ('Pantry', states('sensor.temphumidsensor13_humidity') | float),
            ('Walk-in Closet', states('sensor.temphumidsensor14_humidity') | float),
            ('Attic Space', states('sensor.temphumidsensor15_humidity') | float)
          ] -%}
          {%- set valid_data = humidity_data | selectattr('1', 'ne', 0.0) | list -%}
          {%- set max_humidity = valid_data | map(attribute='1') | max -%}
          {%- set primary_zone = (valid_data | selectattr('1', 'eq', max_humidity) | first)[0] -%}
          {%- set affected_zones = (valid_data | selectattr('1', 'gt', 60) | list | length) -%}
          {{- {
            'max_humidity': max_humidity,
            'primary_zone': primary_zone,
            'affected_zones': affected_zones,
            'emergency_level': 'Critical' if max_humidity > 65 else ('Warning' if affected_zones >= 3 else 'Caution')
          } | tojson -}}
```

### **Equipment Protection Safeguards**
```yaml
# Enhanced Equipment Protection with Zone Awareness
binary_sensor:
  equipment_protection_active_enhanced:
    friendly_name: "Enhanced Equipment Protection Active"
    value_template: >
      {%- set ac_runtime = states('sensor.ml14xc1_runtime_minutes') | int -%}
      {%- set dehumid_runtime = states('sensor.e130_runtime_minutes') | int -%}
      {%- set last_cycle = states('sensor.equipment_last_cycle_minutes') | int -%}
      
      {%- if ac_runtime > 0 and ac_runtime < 15 -%}
        true  # AC protection: <15min runtime
      {%- elif dehumid_runtime > 0 and dehumid_runtime < 15 -%}
        true  # Dehumidifier protection: <15min runtime  
      {%- elif last_cycle < 10 -%}
        true  # Cooldown protection: <10min since last cycle
      {%- else -%}
        false # Equipment available for new cycle
      {%- endif -%}

automation:
  equipment_conflict_prevention_enhanced:
    alias: "Enhanced Equipment Conflict Prevention"
    trigger:
      - platform: state
        entity_id: 
          - climate.main_floor
          - switch.aprilaire_e130_dehumidifier
        to: 'on'
    condition:
      - condition: state
        entity_id: input_boolean.climate_domain_safety_enabled
        state: 'on'
    action:
      - choose:
          # Prevent AC activation during dehumidifier cycle
          - conditions:
              - condition: state
                entity_id: switch.aprilaire_e130_dehumidifier
                state: 'on'
              - condition: state
                entity_id: climate.main_floor
                attribute: hvac_action
                state: 'cooling'
            sequence:
              # Enhanced conflict resolution with zone data
              - service: script.resolve_equipment_conflict_enhanced
                data:
                  conflict_type: "AC during dehumidifier"
                  zone_priority: "{{ states('sensor.highest_humidity_zone_enhanced') }}"
          
          # Prevent dehumidifier activation during AC cycle
          - conditions:
              - condition: state
                entity_id: climate.main_floor
                attribute: hvac_action
                state: 'cooling'
              - condition: state
                entity_id: switch.aprilaire_e130_dehumidifier
                state: 'on'
            sequence:
              - service: script.resolve_equipment_conflict_enhanced
                data:
                  conflict_type: "Dehumidifier during AC"
                  zone_priority: "{{ states('sensor.highest_humidity_zone_enhanced') }}"
```

---

## 📱 MOBILE NOTIFICATION PROTOCOLS

### **Enhanced Notification Hierarchy**
```yaml
# Zone-Specific Mobile Notifications
Mobile Notification Levels (Enhanced):
  Info:      Single zone approaching 58% humidity
  Normal:    Single zone exceeding 60% humidity  
  High:      Multiple zones >60% OR single zone >62%
  Critical:  Any zone >65% (persistent notification)
  Emergency: Any zone >70% (override Do Not Disturb)

Notification Content Enhancement:
  - Zone identification by name
  - Current humidity level
  - Total affected zones count
  - Equipment response action
  - Expected resolution timeframe
  - Historical trend context
```

### **Emergency Contact Escalation**
```yaml
# Escalation Procedures for Critical Situations
Level 1 (65%+ humidity): 
  - Mobile notification (high priority)
  - Persistent notification (no auto-dismiss)
  - Equipment override activation

Level 2 (70%+ humidity):
  - Override Do Not Disturb
  - Repeat notification every 5 minutes until acknowledged
  - Consider secondary contact notification
  - Equipment maximum response

Level 3 (75%+ humidity - System Failure):
  - Emergency contact notification
  - Equipment shut-off for protection
  - System health check required before restart
```

---

## 🔄 SAFETY VALIDATION PROCEDURES

### **Pre-Sensor Integration Safety Tests**
```bash
# Validate existing safety systems before sensor integration
curl -H "Authorization: Bearer [TOKEN]" "http://192.168.88.125:8123/api/states/binary_sensor.humidity_emergency_active"
curl -H "Authorization: Bearer [TOKEN]" "http://192.168.88.125:8123/api/states/binary_sensor.equipment_protection_active"

# Test emergency response automation
curl -X POST -H "Authorization: Bearer [TOKEN]" -d '{"entity_id": "automation.humidity_emergency_response"}' "http://192.168.88.125:8123/api/services/automation/trigger"
```

### **Post-Integration Validation Commands**
```bash
# Validate enhanced safety systems
curl -H "Authorization: Bearer [TOKEN]" "http://192.168.88.125:8123/api/states/sensor.humidity_emergency_status_enhanced"
curl -H "Authorization: Bearer [TOKEN]" "http://192.168.88.125:8123/api/states/sensor.equipment_arbitration_status_enhanced"

# Test multi-zone emergency response
for i in {1..15}; do
  curl -H "Authorization: Bearer [TOKEN]" "http://192.168.88.125:8123/api/states/sensor.temphumidsensor${i}_humidity" | jq '.state'
done

# Validate zone identification
curl -H "Authorization: Bearer [TOKEN]" "http://192.168.88.125:8123/api/states/sensor.highest_humidity_zone_enhanced" | jq '.attributes.zone_name'
```

### **Emergency Response Testing**
```yaml
# Controlled Emergency Response Tests (Safe Environment)
Test Procedure:
  1. Simulate single zone >60% (controlled test)
  2. Verify caution level response
  3. Simulate multiple zones >60% 
  4. Verify warning level response
  5. Simulate single zone >65% (if safe)
  6. Verify critical level response
  7. Validate mobile notifications at each level
  8. Confirm equipment response appropriateness
  9. Test emergency override functionality
  10. Validate system recovery procedures
```

---

## ⚠️ SAFETY CRITICAL REMINDERS

### **Non-Negotiable Safety Requirements**
1. **60% humidity ceiling**: Enhanced with 15-sensor validation and zone identification
2. **Equipment arbitration**: Zone-aware coordination prevents conflicts
3. **Mobile notifications**: Zone-specific alerts with severity levels
4. **Runtime protection**: 15min/10min cycles optimized with zone feedback
5. **Emergency override**: Multi-level response based on zone analysis

### **Gulf Coast Specific Considerations**
- **High humidity baseline**: League City TX climate requires constant vigilance
- **Mold prevention priority**: 60% ceiling is absolute for health protection
- **Equipment sizing**: ML14XC1/E130 coordination optimized for Gulf Coast loads
- **Seasonal variations**: Enhanced monitoring during high humidity seasons

### **System Monitoring Requirements**
- **Continuous monitoring**: All 15 sensors active during high humidity seasons
- **Trend analysis**: Zone variance monitoring for predictive response
- **Equipment health**: Enhanced monitoring with zone-specific feedback
- **Performance validation**: Regular testing of emergency response procedures

---

**SAFETY STATUS**: Enhanced with 15-Sensor Integration Preparation ✅  
**Critical Features**: Multi-zone 60% humidity ceiling + Zone-aware equipment arbitration  
**Emergency Response**: Zone identification + Graduated response protocols  
**Mobile Integration**: Enhanced notifications with zone specificity and severity levels

**Gulf Coast Optimization**: Advanced safety protocols specifically designed for League City TX high-humidity climate with sophisticated 15-sensor monitoring and zone-aware emergency response procedures.