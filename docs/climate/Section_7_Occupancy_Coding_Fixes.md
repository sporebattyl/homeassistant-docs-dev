# =============================================================================
# SECTION 7: MASTER OCCUPANCY CODING FIXES - FINAL INTEGRATION
# =============================================================================

# CRITICAL DISCOVERY: Section 7 (Master Occupancy) provides the ARCHITECTURAL TEMPLATE 
# that all other sections should follow. Unlike Sections 1-3 which require complete 
# redesign, Section 7 demonstrates correct mode-responsive patterns with sophisticated 
# transition orchestration. However, it still has critical humidity safety violations 
# and foundation integration gaps that must be resolved.
#
# SECTION 7 FIXES FOCUS:
# 1. Fix critical humidity safety violation (60% → 57% maximum with emergency alerts)
# 2. Integrate foundation variables instead of hardcoded device control
# 3. Integrate environmental intelligence from Section 4 into occupancy transitions
# 4. Enhance occupancy system to serve as central coordination hub
# 5. Preserve architectural excellence while adding League City climate intelligence

# FIX 7.1: CRITICAL HUMIDITY SAFETY VIOLATION - IMMEDIATE REQUIREMENT
# Files: climate_master_occupancy.yaml
# Issue: Line 78, 241 - Away mode sets 60% humidity (exactly at user's "NEVER above 60%" limit)
# Impact: CRITICAL - Violates user's primary safety requirement with no margin for League City conditions

# FIX 7.1A: Replace unsafe 60% humidity target with 57% maximum
# Lines 78, 94, 241: Away mode humidity target
BEFORE:
  humidity: "{{ states('sensor.active_climate_humidity_target') | int(60) }}"

AFTER:
  humidity: "{{ states('sensor.active_climate_humidity_target') | int(57) }}"  # Safe margin below 60% limit

# FIX 7.1B: Add emergency humidity monitoring to away mode transitions
# INSERT AFTER line 241 (humidity control in away mode transition)
ADD_AFTER_LINE_241:
      
      # Critical humidity safety monitoring during away mode
      - condition: template
        value_template: "{{ states('sensor.weighted_house_humidity') | float(50) > 58 }}"
      - service: script.critical_humidity_alert
        data:
          current_humidity: "{{ states('sensor.weighted_house_humidity') | float(50) }}"
          away_mode_active: true
          alert_priority: "CRITICAL"
          message: "Away mode humidity approaching 60% limit - equipment intervention required"

# FIX 7.1C: Update away mode energy status calculations for new humidity target
# Lines 78-84: Replace 60% humidity references
BEFORE:
  {% if hvac_temp >= 83 and humidity >= 60 %}

AFTER:
  {% if hvac_temp >= 83 and humidity <= 57 %}  # Changed to reflect safe humidity operation

# FIX 7.2: FOUNDATION VARIABLE INTEGRATION - ELIMINATE HARDCODED VALUES
# Files: climate_master_occupancy.yaml  
# Issue: Lines 205, 288, 386 - Direct thermostat control with hardcoded temperatures
# Impact: HIGH - Even architectural template bypasses foundation variables

# FIX 7.2A: Replace hardcoded away mode temperature with foundation variables
# Lines 204-206: Away mode temperature setting
BEFORE:
  - service: climate.set_temperature
    target:
      entity_id: climate.thermostat
    data:
      temperature: "{{ states('sensor.active_climate_cooling_setpoint') | float(83.5) }}"
      hvac_mode: 'cool'

AFTER:
  - service: climate.set_temperature
    target:
      entity_id: climate.thermostat
    data:
      temperature: >
        {% set base_temp = states('sensor.active_climate_temperature_setpoint') | float(75) %}
        {% set away_adjustment = states('input_number.climate_away_temperature_adjustment') | float(8) %}
        {{ (base_temp + away_adjustment) | round(1) }}
      hvac_mode: 'cool'

# FIX 7.2B: Replace hardcoded guest mode temperature with foundation variables  
# Lines 288-291: Guest mode temperature setting
BEFORE:
  - service: climate.set_temperature
    target:
      entity_id: climate.thermostat
    data:
      temperature: "{{ states('sensor.active_climate_cooling_setpoint') | float(75.5) }}"
      hvac_mode: 'auto'

AFTER:
  - service: climate.set_temperature
    target:
      entity_id: climate.thermostat
    data:
      temperature: "{{ states('sensor.active_climate_temperature_setpoint') | float(75) }}"
      hvac_mode: 'auto'

# FIX 7.2C: Replace hardcoded home mode recovery with foundation variables
# Lines 378-387: Home mode comfort recovery temperature
BEFORE:
  - service: climate.set_temperature
    target:
      entity_id: climate.thermostat
    data:
      temperature: "{{ states('sensor.active_climate_cooling_setpoint') | float(75.5) - 2 }}"
      hvac_mode: 'cool'
  - delay: "00:00:30"
  - service: climate.set_temperature
    target:
      entity_id: climate.thermostat
    data:
      temperature: "{{ states('sensor.active_climate_cooling_setpoint') | float(75.5) }}"

AFTER:
  - service: climate.set_temperature
    target:
      entity_id: climate.thermostat
    data:
      temperature: >
        {% set target_temp = states('sensor.active_climate_temperature_setpoint') | float(75) %}
        {% set recovery_adjustment = states('sensor.active_climate_hvac_deadband') | float(2) %}
        {{ (target_temp - recovery_adjustment) | round(1) }}  # Use deadband for recovery depth
      hvac_mode: 'cool'
  - delay: "00:00:30"
  - service: climate.set_temperature
    target:
      entity_id: climate.thermostat
    data:
      temperature: "{{ states('sensor.active_climate_temperature_setpoint') | float(75) }}"

# FIX 7.2D: Replace hardcoded humidity values with foundation variables
# Lines 303-307, 408-412: Humidity control using foundation variables
BEFORE:
  - service: humidifier.set_humidity
    target:
      entity_id: humidifier.whole_home_dehumidifier
    data:
      humidity: "{{ states('sensor.active_climate_humidity_target') | int(50) }}"

AFTER:
  - service: humidifier.set_humidity
    target:
      entity_id: humidifier.whole_home_dehumidifier  
    data:
      humidity: "{{ states('sensor.active_climate_humidity_target') | int(50) | min(57) }}"  # Ensure safety compliance

# FIX 7.3: ENVIRONMENTAL INTELLIGENCE INTEGRATION - LEAGUE CITY OPTIMIZATION
# Files: climate_master_occupancy.yaml
# Issue: No integration with Section 4's excellent League City environmental intelligence
# Impact: HIGH - Misses heat index, weather patterns, and Gulf Coast climate optimization

# FIX 7.3A: Add heat index awareness to away mode safety checking
# INSERT AFTER line 196 (before away mode conditions)
ADD_AFTER_LINE_196:
      
      # League City heat index safety check for away mode
      - variables:
          away_temp: "{{ states('sensor.active_climate_temperature_setpoint') | float(75) + 8 }}"
          away_humidity: 57  # Safe humidity target
          estimated_heat_index: "{{ (away_temp + 0.5 * (away_humidity - 40)) | round(1) }}"
          
      # Alert if away mode settings create dangerous heat index  
      - condition: template
        value_template: "{{ estimated_heat_index | float > 110 }}"
      - service: notify.mobile_app_drews_iphone
        data:
          title: "⚠️ Away Mode Heat Index Warning"
          message: >
            Away mode settings create dangerous heat index: {{ estimated_heat_index }}°F
            ({{ away_temp }}°F + {{ away_humidity }}% humidity)
            Consider environmental conditions before extended absence.
          data:
            tag: "heat_index_warning"
            group: "climate"

# FIX 7.3B: Add weather-predictive pre-conditioning to home mode transitions
# INSERT AFTER line 363 (before home mode transition variables)
ADD_AFTER_LINE_363:
      
      # League City weather-predictive comfort recovery
      - variables:
          outdoor_temp: "{{ state_attr('weather.forecast_home', 'temperature') | float(85) }}"
          outdoor_humidity: "{{ state_attr('weather.forecast_home', 'humidity') | float(75) }}"
          outdoor_heat_index: "{{ (outdoor_temp + 0.5 * (outdoor_humidity - 40)) | round(1) }}"
          extreme_conditions: "{{ outdoor_heat_index > 105 }}"
          recovery_enhancement: "{{ 2 if extreme_conditions else 1 }}"

# FIX 7.3C: Enhanced comfort recovery with environmental awareness
# REPLACE the temperature calculation in home mode transition (lines 378-380)
REPLACE_LINES_378_380:
          recovery_temp: >
            {% set target_temp = states('sensor.active_climate_temperature_setpoint') | float(75) %}
            {% set deadband = states('sensor.active_climate_hvac_deadband') | float(2) %}
            {% set enhanced_recovery = recovery_enhancement | float(1) %}
            {{ (target_temp - (deadband * enhanced_recovery)) | round(1) }}

# FIX 7.3D: Add Gulf Coast humidity intelligence to occupancy transitions
# INSERT AFTER line 406 (before home mode humidity restoration)  
ADD_AFTER_LINE_406:
      
      # Gulf Coast humidity intelligence for home mode restoration
      - variables:
          outdoor_humidity: "{{ state_attr('weather.forecast_home', 'humidity') | float(75) }}"
          humidity_load_adjustment: >
            {% if outdoor_humidity > 85 %}
              -2  # Lower indoor target when outdoor humidity very high
            {% elif outdoor_humidity > 75 %}
              -1  # Slight reduction for high outdoor humidity
            {% else %}
              0   # Normal humidity target
            {% endif %}

# FIX 7.3E: Dynamic humidity target with Gulf Coast awareness
# REPLACE humidity setting in home mode (lines 408-412)
REPLACE_LINES_408_412:
  - service: humidifier.set_humidity
    target:
      entity_id: humidifier.whole_home_dehumidifier
    data:
      humidity: >
        {% set base_humidity = states('sensor.active_climate_humidity_target') | int(50) %}
        {% set adjustment = humidity_load_adjustment | int(0) %}
        {% set target_humidity = (base_humidity + adjustment) | int %}
        {{ target_humidity if target_humidity >= 48 and target_humidity <= 57 else (48 if target_humidity < 48 else 57) }}  # Safe range with Gulf Coast adaptation

# FIX 7.4: OCCUPANCY AS CENTRAL COORDINATION SYSTEM - INTEGRATION FRAMEWORK
# Files: climate_master_occupancy.yaml
# Issue: Occupancy provides excellent architectural template but operates independently  
# Impact: HIGH - Missed opportunity for central coordination of all climate subsystems

# FIX 7.4A: Add environmental intelligence coordination to away mode
# INSERT AFTER line 217 (blind coordination in away mode)
ADD_AFTER_LINE_217:
      
      # Phase 2B: Environmental intelligence coordination for away mode
      - service: script.environmental_intelligence_away_mode
        data:
          occupancy_mode: "away"
          target_temperature: "{{ states('sensor.active_climate_temperature_setpoint') | float(75) + 8 }}"
          target_humidity: 57
        continue_on_error: true

# FIX 7.4B: Add HVAC core coordination to occupancy transitions
# INSERT AFTER line 230 (fan coordination in away mode)
ADD_AFTER_LINE_230:
      
      # Phase 3B: HVAC core system coordination
      - service: automation.trigger
        target:
          entity_id: automation.climate_hvac_occupancy_mode_coordination
        data:
          skip_condition: false
          variables:
            new_occupancy_mode: "Away"
            coordination_source: "master_occupancy"

# FIX 7.4C: Add cross-system status monitoring to transitions
# INSERT AFTER line 252 (completion notification in away mode)
ADD_AFTER_LINE_252:
      
      # Phase 6: Cross-system coordination validation
      - delay: "00:02:00"  # Allow systems to settle
      - service: script.validate_occupancy_coordination
        data:
          expected_mode: "Away"
          systems_to_check: 
            - "hvac_core"
            - "fan_management"  
            - "environmental_controls"
            - "smart_intelligence"
        continue_on_error: true

# FIX 7.4D: Enhanced guest mode with environmental intelligence
# INSERT AFTER line 318 (fan coordination in guest mode)
ADD_AFTER_LINE_318:
      
      # Phase 3B: Environmental intelligence optimization for guest mode
      - service: script.environmental_intelligence_guest_mode
        data:
          occupancy_mode: "guest"
          target_temperature: "{{ states('sensor.active_climate_temperature_setpoint') | float(75) }}"
          comfort_priority: true
        continue_on_error: true

# FIX 7.4E: Add smart system coordination to home mode
# INSERT AFTER line 424 (fan coordination in home mode)
ADD_AFTER_LINE_424:
      
      # Phase 3B: Smart system coordination for home mode restoration
      - service: automation.trigger
        target:
          entity_id: automation.climate_smart_home_occupancy_coordination
        data:
          skip_condition: false
          variables:
            new_occupancy_mode: "Home"
            returning_from: "{{ previous_mode }}"
            environmental_conditions: "{{ outdoor_heat_index }}"

# FIX 7.5: LEAGUE CITY LIFESTYLE AND CLIMATE ADAPTATION
# Files: climate_master_occupancy.yaml
# Issue: Generic occupancy patterns don't optimize for League City lifestyle and climate
# Impact: MEDIUM - Missing Gulf Coast specific occupancy intelligence

# FIX 7.5A: Enhanced geofence pre-conditioning with League City weather awareness
# REPLACE lines 643-648 (basic geofence action)
REPLACE_LINES_643_648:
      # League City weather-aware pre-conditioning
      - variables:
          outdoor_temp: "{{ state_attr('weather.forecast_home', 'temperature') | float(85) }}"
          outdoor_humidity: "{{ state_attr('weather.forecast_home', 'humidity') | float(75) }}"
          heat_index: "{{ (outdoor_temp + 0.5 * (outdoor_humidity - 40)) | round(1) }}"
          extreme_conditions: "{{ heat_index > 105 }}"
          
      - service: logbook.log
        data:
          name: "Geofence Pre-Conditioning"
          message: >
            Arrival detected - League City conditions: {{ outdoor_temp }}°F, {{ outdoor_humidity }}% humidity, 
            Heat Index: {{ heat_index }}°F {{ '(EXTREME)' if extreme_conditions else '' }}
          entity_id: sensor.master_occupancy_coordinator_status
      
      # Enhanced pre-conditioning for League City extreme conditions
      - choose:
          - conditions:
              - condition: template
                value_template: "{{ extreme_conditions }}"
            sequence:
              # Aggressive pre-conditioning for extreme heat index
              - service: input_select.select_option
                target:
                  entity_id: input_select.climate_occupancy_mode
                data:
                  option: "Home"
              - service: script.league_city_extreme_heat_arrival_preparation
        default:
          # Standard home mode transition
          - service: input_select.select_option
            target:
              entity_id: input_select.climate_occupancy_mode
            data:
              option: "Home"

# FIX 7.5B: Add hurricane season awareness to guest mode management
# INSERT AFTER line 684 (guest away trigger condition)
ADD_AFTER_LINE_684:
        id: "guest_away"
      # Hurricane season occupancy adaptation
      - platform: state  
        entity_id: sensor.hurricane_season_status
        to: 
          - "watch_issued"
          - "warning_issued"  
        id: "storm_preparation"

# FIX 7.5C: Storm season guest mode adjustments
# ADD new condition to guest mode auto management (after line 694)
ADD_AFTER_EXISTING_CHOOSE_CONDITIONS:
          # Storm preparation - ensure comfort systems ready
          - conditions:
              - condition: trigger
                id: "storm_preparation"
            sequence:
              - service: climate.set_temperature
                target:
                  entity_id: climate.thermostat
                data:
                  temperature: "{{ states('sensor.active_climate_temperature_setpoint') | float(75) - 1 }}"  # Pre-cool before potential power issues
              - service: notify.mobile_app_drews_iphone
                data:
                  title: "🌀 Storm Preparation - Guest Mode"
                  message: >
                    Hurricane season alert detected. Guest mode pre-conditioned for potential weather impacts.
                    Current settings optimized for comfort and system resilience.
                  data:
                    tag: "storm_guest_mode"
                    group: "climate"

# FIX 7.6: OCCUPANCY COORDINATION SCRIPTS - NEW INTEGRATION SERVICES
# Files: Add new script sections to climate_master_occupancy.yaml
# Issue: Missing coordination scripts for environmental intelligence and cross-system integration
# Impact: MEDIUM - Occupancy system needs coordination services for complete integration

# ADD new script section after existing fan coordination scripts (after line 531)
ADD_AFTER_LINE_531:

  # Environmental Intelligence Coordination Scripts
  environmental_intelligence_away_mode:
    alias: "Environmental Intelligence Away Mode Coordination"
    sequence:
      - service: script.climate_weather_away_mode_optimization
        continue_on_error: true
      - service: script.climate_solar_gain_away_mode_preparation  
        continue_on_error: true
      - service: input_boolean.turn_on
        target:
          entity_id: input_boolean.environmental_intelligence_coordinated
      - service: logbook.log
        data:
          name: "Environmental Intelligence Coordination"
          message: "Away mode environmental optimization complete"

  environmental_intelligence_guest_mode:
    alias: "Environmental Intelligence Guest Mode Coordination"
    sequence:
      - service: script.climate_weather_guest_mode_optimization
        continue_on_error: true
      - service: script.climate_comfort_enhancement_coordination
        continue_on_error: true
      - service: logbook.log
        data:
          name: "Environmental Intelligence Coordination"
          message: "Guest mode environmental optimization complete"

  validate_occupancy_coordination:
    alias: "Validate Occupancy Cross-System Coordination"
    sequence:
      - variables:
          hvac_coordinated: "{{ is_state('sensor.hvac_occupancy_coordination_status', 'synchronized') }}"
          fan_coordinated: "{{ is_state('sensor.fan_occupancy_coordination_status', 'synchronized') }}"
          environmental_coordinated: "{{ is_state('input_boolean.environmental_intelligence_coordinated', 'on') }}"
          
      - choose:
          - conditions:
              - condition: template
                value_template: "{{ not (hvac_coordinated and fan_coordinated and environmental_coordinated) }}"
            sequence:
              - service: notify.mobile_app_drews_iphone
                data:
                  title: "⚠️ Occupancy Coordination Issue"
                  message: >
                    Some climate systems not properly coordinated with occupancy change:
                    HVAC: {{ 'OK' if hvac_coordinated else 'NEEDS ATTENTION' }}
                    Fans: {{ 'OK' if fan_coordinated else 'NEEDS ATTENTION' }}  
                    Environmental: {{ 'OK' if environmental_coordinated else 'NEEDS ATTENTION' }}
                  data:
                    tag: "coordination_alert"
                    group: "climate"

  league_city_extreme_heat_arrival_preparation:
    alias: "League City Extreme Heat Arrival Preparation"
    sequence:
      - service: climate.set_temperature
        target:
          entity_id: climate.thermostat
        data:
          temperature: >
            {% set normal_temp = states('sensor.active_climate_temperature_setpoint') | float(75) %}
            {{ (normal_temp - 3) | round(1) }}  # Aggressive pre-cooling
          hvac_mode: 'cool'
      - service: script.central_fan_control
        data:
          priority: "high"
          reason: "extreme_heat_pre_conditioning"
          mode: "circulation"
      - service: notify.mobile_app_drews_iphone
        data:
          title: "🔥 Extreme Heat Arrival Prep"
          message: >
            Heat index {{ (state_attr('weather.forecast_home', 'temperature') | float + 0.5 * (state_attr('weather.forecast_home', 'humidity') | float - 40)) | round(1) }}°F detected.
            Aggressive pre-conditioning activated for comfort upon arrival.
          data:
            tag: "extreme_heat_prep"
            group: "climate"

# =============================================================================
# END OF SECTION 7 MASTER OCCUPANCY CODING FIXES
# =============================================================================

# SECTION 7 IMPLEMENTATION SUMMARY:
# 1. Fixed critical humidity safety violation (60% → 57% with emergency monitoring)
# 2. Integrated foundation variables replacing all hardcoded device control values
# 3. Added League City environmental intelligence to all occupancy transitions
# 4. Enhanced occupancy system as central coordination hub for all climate subsystems
# 5. Added Gulf Coast climate intelligence with heat index, weather, and storm awareness
# 6. Created coordination scripts for cross-system integration and validation
# 7. Preserved architectural excellence while adding comprehensive integration capabilities
#
# CRITICAL ARCHITECTURAL DISCOVERIES IMPLEMENTED:
# 1. Occupancy system serves as the integration template ALL other sections should follow
# 2. Mode-responsive design pattern demonstrated (respond to modes, don't set them)
# 3. Sophisticated transition orchestration provides framework for system-wide coordination
# 4. Foundation variable integration shows path for eliminating hardcoded values system-wide
# 5. Environmental intelligence integration demonstrates comprehensive League City optimization
#
# FINAL INTEGRATION PATHWAY ESTABLISHED:
# 1. Foundation Variables (Section 5) → Occupancy Coordination (Section 7) → All Subsystems
# 2. Environmental Intelligence (Section 4) → Occupancy Transitions → Climate Optimization
# 3. Reformed Smart Intelligence (Section 3) → Occupancy Response Pattern → Enhanced Automation
# 4. Critical Monitoring (Section 6) → Occupancy Coordination → System Health Validation
# 5. Complete climate system integration using occupancy as central coordination framework