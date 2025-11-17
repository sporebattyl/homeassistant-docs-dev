# Climate System Dependency Map
## Phase 1: Comprehensive Analysis for System Review

**Generated:** August 31, 2025  
**Scope:** 32 Active Climate Package Files  
**Purpose:** Foundation for systematic climate automation review

---

## Executive Summary

The climate system consists of 32 interconnected package files with a clear hierarchical dependency structure. The system is well-architected with foundational configuration files providing shared variables, core services providing reusable functionality, and specialized controllers managing specific subsystems.

**Key Findings:**
- **3 Foundation Files** provide core dependencies for all other packages
- **2 Critical Shared Services** are called by multiple automations  
- **5 Major Potential Conflict Zones** identified requiring careful coordination
- **Clear Layered Architecture** enables systematic review and optimization

---

## Architecture Overview

### Dependency Layers

The climate system follows a clear 4-layer architecture:

```
┌─────────────────────────────────────────────────────────┐
│ Layer 4: Specialized Controllers                        │
│ • climate_fan_coordination.yaml                        │
│ • climate_blinds*.yaml                                 │
│ • climate_weather.yaml                                 │
│ • climate_smarthome_*.yaml (7 files)                   │
└─────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────┐
│ Layer 3: System Controllers                            │
│ • climate_hvac_core.yaml                               │
│ • climate_humidity.yaml                                │
│ • climate_mode_coordination.yaml                       │
│ • climate_equipment_health.yaml                        │
└─────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────┐
│ Layer 2: Core Services                                 │
│ • scripts/dehumidifier_fan_control.yaml                │
│ • climate_notification_intelligence.yaml               │
└─────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────┐
│ Layer 1: Foundation                                     │
│ • climate_input_helpers.yaml                           │
│ • climate_globals.yaml                                 │  
│ • climate_sensors.yaml                                 │
└─────────────────────────────────────────────────────────┘
```

---

## Foundation Layer Dependencies

### climate_input_helpers.yaml (Critical Foundation)
**Role:** Central configuration provider for entire system  
**Provides:**
- `input_select.climate_occupancy_mode` (Home/Away/Guest/Sleep)
- `input_select.climate_seasonal_profile` (Summer/Winter/Shoulder)
- `input_number.*` entities for temperature/humidity setpoints
- `sensor.active_climate_*` template sensors (dynamic value selection)
- Mode coordination automation

**Dependencies:** None (foundational)  
**Dependents:** 28+ other climate files

### climate_globals.yaml (Shared State Management)
**Role:** System-wide state tracking and notification throttling  
**Provides:**
- `input_select.climate_system_state` / `climate_global_system_state`
- `timer.climate_global_notification_throttle` / `climate_notification_throttle`

**Dependencies:** None  
**Dependents:** Most automation files for state tracking and notifications

### climate_sensors.yaml (Calculated Values)
**Role:** Complex sensor calculations and mode-aware averaging  
**Provides:**
- `sensor.weighted_house_temperature` (mode-aware room temperature averaging)
- `sensor.hvac_target_temperature` (dynamic target based on time/mode)
- `sensor.climate_mode` (time-based mode calculation)
- Fan target temperature sensors for each room
- `sensor.weighted_house_humidity` (mode-aware humidity averaging)

**Dependencies:**
- All Aqara sensors (aqaratemphumid1-9)
- `climate.thermostat`
- Multiple input_number entities from climate_input_helpers.yaml

**Dependents:** All automation files requiring temperature/humidity values

---

## Core Services Layer

### scripts/dehumidifier_fan_control.yaml (Critical Shared Service)
**Role:** Priority-based fan coordination preventing automation conflicts  
**Provides:**
- `script.central_fan_control` (called by 8+ automations)
- `script.free_cooling_mode`
- Priority-based fan control logic

**Dependencies:**
- `climate.thermostat` (for fan mode control)
- `switch.dehumidifier_relay_l1`
- Various timer entities for state tracking

**Dependents:** 
- climate_hvac_core.yaml
- climate_humidity.yaml  
- climate_airflow_management.yaml
- climate_hvac_free_cooling.yaml

### climate_notification_intelligence.yaml (Shared Notification Service)
**Role:** Intelligent notification throttling and spam prevention  
**Provides:**
- `script.smart_climate_notification`
- `script.smart_maintenance_notification`
- Binary sensors for notification availability

**Dependencies:**
- Timer entities for throttling
- Mobile app notification service

**Dependents:** Most automation files with user notifications

---

## System Controllers Layer

### climate_hvac_core.yaml (Primary HVAC Control)
**Role:** Main heating/cooling automation logic  
**Key Dependencies:**
- `sensor.weighted_house_temperature` (from climate_sensors.yaml)
- `sensor.hvac_target_temperature` (from climate_sensors.yaml)
- `script.central_fan_control` (from scripts/dehumidifier_fan_control.yaml)
- `script.smart_climate_notification` (from climate_notification_intelligence.yaml)
- `timer.climate_global_notification_throttle` (from climate_globals.yaml)

### climate_humidity.yaml (Dehumidifier Control)
**Role:** Humidity control and dehumidifier automation  
**Key Dependencies:**
- `sensor.weighted_house_humidity` (from climate_sensors.yaml)
- `sensor.active_humidity_turn_on_target` (from climate_input_helpers.yaml)
- `sensor.active_humidity_turn_off_target` (from climate_input_helpers.yaml)
- `script.central_fan_control` (shared service)
- `switch.dehumidifier_relay_l1` (physical device)

### climate_mode_coordination.yaml (System Orchestration)
**Role:** Master mode propagation across all subsystems  
**Key Dependencies:**
- `sensor.master_climate_mode` (from climate_input_helpers.yaml)
- `sensor.climate_system_ready_status` (internal)
- Multiple active setpoint sensors (from climate_input_helpers.yaml)

---

## Inter-File Dependency Matrix

| Source File | Target Entity | Dependency Type | Risk Level |
|-------------|---------------|----------------|------------|
| climate_hvac_core.yaml | script.central_fan_control | Service Call | HIGH |
| climate_humidity.yaml | script.central_fan_control | Service Call | HIGH |
| climate_fan_coordination.yaml | input_select.climate_system_state | State Dependency | MEDIUM |
| All automations | timer.climate_global_notification_throttle | Resource Sharing | MEDIUM |
| climate_humidity.yaml | sensor.weighted_house_humidity | Sensor Dependency | HIGH |
| climate_hvac_core.yaml | sensor.hvac_target_temperature | Sensor Dependency | HIGH |
| Multiple files | sensor.climate_mode | Mode Dependency | HIGH |
| Multiple files | script.smart_climate_notification | Service Call | MEDIUM |

---

## Shared Entity Mapping

### Physical Device Control (Conflict Risk: HIGH)
- **climate.thermostat**: Controlled by climate_hvac_core.yaml, climate_mode_coordination.yaml
- **switch.dehumidifier_relay_l1**: Controlled by climate_humidity.yaml only
- **fan.living_room_fan**: Controlled by climate_fan_coordination.yaml, scripts/dehumidifier_fan_control.yaml
- **fan.office_fan**: Controlled by climate_fan_coordination.yaml, scripts/dehumidifier_fan_control.yaml

### Shared State Entities (Conflict Risk: MEDIUM)
- **input_select.climate_system_state**: Updated by multiple automations
- **timer.climate_global_notification_throttle**: Used by most notification systems

### Shared Calculation Dependencies (Risk: LOW - Read-only)
- **sensor.weighted_house_temperature**: Used by 6+ automation files
- **sensor.weighted_house_humidity**: Used by 3+ automation files
- **sensor.climate_mode**: Used by 8+ files for mode-aware behavior

---

## Potential Conflict Zones

### 1. Thermostat Fan Mode Control (HIGH RISK)
**Affected Files:**
- climate_hvac_core.yaml (calls script.central_fan_control)
- climate_humidity.yaml (calls script.central_fan_control)
- climate_airflow_management.yaml (calls script.central_fan_control)
- scripts/dehumidifier_fan_control.yaml (implements priority logic)

**Conflict Scenario:** Multiple automations could simultaneously attempt to change thermostat fan mode

**Mitigation:** Priority-based logic in script.central_fan_control provides coordination

### 2. Room Fan Control (HIGH RISK)
**Affected Files:**
- climate_fan_coordination.yaml (room-specific temperature-based control)
- scripts/dehumidifier_fan_control.yaml (free cooling mode control)

**Conflict Scenario:** Room fans could receive conflicting speed/state commands

**Risk Assessment:** Both files control same physical entities (fan.living_room_fan, fan.office_fan)

### 3. Climate System State Updates (MEDIUM RISK)
**Affected Files:**
- climate_globals.yaml (provides input_select.climate_system_state)
- climate_mode_coordination.yaml (updates system state)
- climate_hvac_core.yaml (may update system state)

**Conflict Scenario:** Race conditions in system state updates

### 4. Notification Throttling Resource Contention (MEDIUM RISK)
**Affected Files:**
- All automation files using shared notification throttle timers

**Conflict Scenario:** Timer state conflicts if multiple notifications fire simultaneously

### 5. Mode Selector Race Conditions (LOW RISK)
**Affected Files:**
- climate_input_helpers.yaml (mode change coordinator)
- climate_mode_coordination.yaml (master mode propagation)

**Conflict Scenario:** Mode changes could propagate inconsistently

---

## Critical Integration Points

### 1. Temperature Sensor Federation (STABLE)
- **Primary:** sensor.weighted_house_temperature
- **Fallback:** sensor.filtered_thermostat_temperature
- **Error Handling:** Built-in availability templates

### 2. Humidity Sensor Federation (STABLE)
- **Primary:** sensor.weighted_house_humidity  
- **Fallback:** sensor.average_house_humidity
- **Error Handling:** Comprehensive availability checking

### 3. Mode Propagation Chain (COMPLEX)
```
input_select.climate_occupancy_mode
    ↓
sensor.active_climate_temperature_setpoint
    ↓
sensor.hvac_target_temperature
    ↓
automation triggers
```

### 4. Fan Control Coordination (CRITICAL)
```
Multiple Trigger Sources
    ↓
script.central_fan_control (Priority Logic)
    ↓
climate.thermostat (Fan Mode) + Room Fans
```

---

## Cross-Package Communication Patterns

### Pattern 1: Hierarchical Mode Propagation
- climate_input_helpers.yaml → climate_mode_coordination.yaml → All other packages
- Clear top-down flow prevents circular dependencies

### Pattern 2: Service-Oriented Fan Control
- Multiple packages → script.central_fan_control → Physical devices
- Centralized coordination prevents conflicts

### Pattern 3: Calculated Sensor Dependencies
- climate_sensors.yaml provides calculated values → Consumed by automation packages
- One-way dependency maintains system stability

### Pattern 4: Notification Aggregation
- Multiple packages → climate_notification_intelligence.yaml → User notifications
- Centralized throttling and spam prevention

---

## Review Focus Area Recommendations

### High Priority Areas (Review First)
1. **Fan Control Coordination** (climate_fan_coordination.yaml + script.central_fan_control)
   - Verify no race conditions between room fan control and central fan control
   - Test priority logic under simultaneous trigger scenarios
   - Validate free cooling mode coordination

2. **Mode Propagation Logic** (climate_input_helpers.yaml + climate_mode_coordination.yaml)
   - Verify mode changes propagate correctly to all subsystems
   - Test fallback mechanisms for invalid states
   - Validate manual override behavior

3. **Temperature/Humidity Sensor Dependencies** (climate_sensors.yaml dependencies)
   - Verify weighted averaging calculations are correct for League City preferences
   - Test fallback behavior when sensors become unavailable
   - Validate mode-aware weighting logic

### Medium Priority Areas
4. **HVAC Core Logic** (climate_hvac_core.yaml)
   - Verify cooling/heating thresholds align with user preferences (75°F preference, 78°F+ acceptable)
   - Test equipment protection timers
   - Validate performance optimizations

5. **Humidity Control** (climate_humidity.yaml)
   - Verify humidity targets (48-53% preference, never >60%)
   - Test dehumidifier coordination with HVAC system
   - Validate error handling for sensor failures

### Lower Priority Areas
6. **Specialized Controllers** (blinds, weather, seasonal packages)
   - Test integration with core system
   - Verify proper dependency handling
   - Validate notification throttling compliance

---

## System Health Indicators

### Critical Dependencies Status
- ✅ climate_input_helpers.yaml (foundation stable)
- ✅ climate_globals.yaml (shared state management working)
- ✅ climate_sensors.yaml (calculated sensors operational)
- ✅ script.central_fan_control (coordination service active)

### Risk Assessment Summary
- **HIGH RISK**: Fan control conflicts (2 zones identified)
- **MEDIUM RISK**: State management race conditions (2 zones)
- **LOW RISK**: Mode propagation inconsistencies (1 zone)

### Recommendations for Phase 2 Review
1. Start with foundation layer validation
2. Test shared services under load
3. Verify conflict resolution mechanisms
4. Optimize for League City climate conditions (hot, humid)
5. Ensure 48-53% humidity range compliance
6. Validate 75°F comfort + 78°F+ efficiency balance

---

## Conclusion

The climate system demonstrates a well-structured, layered architecture with clear separation of concerns. The dependency analysis reveals a stable foundation with identifiable risk zones that can be systematically addressed during the review process.

**Next Steps:**
- Use this map to guide systematic review of each layer
- Test conflict scenarios identified in the risk zones
- Validate user preference compliance (75°F comfort, 48-53% humidity)
- Optimize for League City climate conditions

**Review Agent Coordination:**
- Foundation files should be reviewed first to establish baseline
- Service files should be tested for race conditions
- Controller files can be reviewed in parallel once foundation is validated
- Specialized controllers can be optimized after core system validation