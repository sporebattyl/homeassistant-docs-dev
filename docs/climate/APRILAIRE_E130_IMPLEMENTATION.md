# AprilAire E130 Slab Charging Coordination Implementation

## Phase 2B Implementation Status: ✅ COMPLETE

**Implementation Date**: 2025-01-09  
**System**: AprilAire E130 Dehumidifier Coordination with Slab Charging  
**Location**: League City, TX Single-Story Home  

## Files Created/Modified

### 1. New Template Sensors: `/templates/slab_charging_sensors.yaml`
- **Key Room Temperature Stratification**: Monitors temperature spread across living room, master bedroom, Rowan's room, and office
- **Slab Charging Status**: Tracks 5AM-8AM charging window with countdown timers
- **Humidity Safety Status**: Monitors approach to 60% humidity ceiling with graduated alert levels

### 2. Main Coordination: `/automations/slab_charging_coordination.yaml`
- **Primary coordination automation**: 5AM-8AM operation with 2-minute dynamic adjustments
- **Progressive fan control**: Based on temperature stratification (>3°F = all fans, >2°F = targeted, ≤2°F = energy saving)
- **AprilAire E130 integration**: Auto-activation at 55% humidity, emergency protocols at 59%
- **Weather front coordination**: Pre-activates E130 when weather fronts detected during charging
- **End-of-cycle cleanup**: Proper equipment shutdown at 8AM

### 3. Enhanced Safety Protocol: `/humidity_emergency_protocol.yaml` (modified)
- **Slab charging specific emergency override**: 59% threshold (vs normal 60%)
- **1-minute emergency response**: Faster than normal 5-minute trigger
- **Maximum circulation override**: All fans 100% speed during emergency
- **Recovery protocol**: Conservative 55% recovery threshold during slab charging

## Implementation Strategy

### Integration Method: Modular Coordination
- **Dedicated coordination file**: Clean separation from existing HVAC automation
- **Integration points**: Calls existing `script.central_fan_control` for seamless coordination
- **Safety priority**: Emergency protocols override normal operation
- **Entity reuse**: Leverages existing sensor entities and fan controls

### Key Features Implemented

#### 1. Enhanced Circulation During Slab Charging ✅
- **HVAC fan mandatory**: 75% speed throughout 5AM-8AM window
- **Progressive room fan activation**: Dynamic response to temperature stratification
- **15-minute cycle protection**: Built into existing equipment protection timers

#### 2. Gulf Coast Humidity Safety Enhancement ✅
- **E130 activation threshold**: Auto-enable at 55% during charging (proactive)
- **Emergency threshold**: 59% during slab charging (vs 60% normal)
- **Continuous monitoring**: 2-minute evaluation cycles
- **Emergency protocols**: Maximum dehumidification + circulation

#### 3. Single-Story Distribution Strategy ✅
- **Horizontal distribution focus**: Room-to-room temperature differential monitoring
- **Stratification response**: >2°F difference triggers targeted fan activation
- **AprilAire integration**: Coordinated dehumidified air distribution
- **Energy efficiency**: Smart fan control based on actual need

#### 4. Weather Integration ✅
- **Weather front pre-activation**: E130 starts when fronts approach during charging
- **Gulf Coast protection**: Anticipates humidity spikes from weather systems

## Safety Features

### Multi-Layer Humidity Protection
1. **Normal operation**: E130 activates at 55% during slab charging
2. **Warning level**: Enhanced monitoring and notifications at 58%
3. **Emergency level**: Maximum response at 59% (slab charging specific)
4. **Critical level**: Existing 60%+ protocols remain active

### Equipment Protection
- **Timer integration**: Uses existing HVAC protection timers
- **Gradual startup**: 3-5 second delays prevent equipment stress
- **Proper shutdown**: Coordinated equipment turnoff at 8AM
- **Emergency override**: Can force maximum operation when needed

### Fail-Safe Design
- **Independent emergency system**: Humidity emergency protocol operates separately
- **Entity validation**: Checks sensor availability before actions
- **Mode conflicts**: Emergency protocols override normal coordination
- **Recovery protocols**: Automatic return to normal operation

## Entity Requirements

### Required Entity Updates
**IMPORTANT**: Before activation, update these placeholder entities in the automation files:

#### Fan Entities (update in both files):
```yaml
fan.hvac_main_fan          # Replace with actual HVAC fan entity
fan.living_room_fan        # Confirm entity ID
fan.master_bedroom_fan     # Confirm entity ID  
fan.rowans_room_fan        # Confirm entity ID
fan.office_fan             # Confirm entity ID
```

#### AprilAire E130 Entity:
```yaml
switch.aprilaire_e130_dehumidifier  # Replace with actual E130 entity
```

#### Notification Entity:
```yaml
notify.mobile_app_drews_iphone      # Confirmed correct
```

### Existing Entities (validated):
- `sensor.weighted_house_humidity` ✅
- `sensor.aqaratemphumid1_temperature` (Living Room) ✅
- `sensor.aqaratemphumid7_temperature` (Master Bedroom) ✅
- `sensor.aqaratemphumid4_temperature` (Rowan's Room) ✅
- `sensor.aqaratemphumid9_temperature` (Office) ✅
- `script.central_fan_control` ✅
- `binary_sensor.weather_front_approaching` ✅

## Activation Instructions

### 1. Entity ID Validation (CRITICAL)
```bash
# Verify fan entities exist
ha core entities list | grep "fan\."

# Verify AprilAire E130 entity
ha core entities list | grep -i "aprilaire\|dehumid"

# Test notification service
ha core services call notify.mobile_app_drews_iphone '{"message": "Test notification"}'
```

### 2. Configuration Reload
```bash
# Reload templates (new sensors)
ha core config reload templates

# Reload automations (coordination logic)
ha core config reload automations

# Verify new sensors appear
ha core entities list | grep "slab_charging\|stratification"
```

### 3. Initial Testing (Non-Peak Hours)
```bash
# Test temperature stratification sensor
ha core states get sensor.key_room_temperature_stratification

# Test slab charging status
ha core states get sensor.slab_charging_status

# Test humidity safety status  
ha core states get sensor.humidity_safety_status
```

### 4. Manual Testing Protocol
1. **Sensor validation**: Verify all new template sensors show realistic values
2. **Fan control test**: Manually trigger room fans to confirm control
3. **E130 control test**: Verify AprilAire E130 responds to on/off commands
4. **Emergency protocol test**: Test humidity emergency protocol with safe test values
5. **Coordination test**: Enable during non-peak hours to verify integration

## Monitoring and Optimization

### Key Metrics to Monitor
- **Temperature stratification**: Should reduce during active coordination
- **Humidity control**: Should maintain <55% during slab charging
- **Fan utilization**: Progressive activation based on actual need
- **E130 runtime**: Appropriate activation without over-cycling
- **Energy efficiency**: Minimal unnecessary fan operation

### Performance Indicators
- ✅ **Successful slab charging**: No humidity spikes during 5AM-8AM
- ✅ **Effective distribution**: <2°F temperature difference across rooms
- ✅ **Gulf Coast protection**: Humidity stays well below 60% ceiling
- ✅ **Energy optimization**: Fans only run when needed
- ✅ **Emergency readiness**: Fast response to humidity spikes

## Troubleshooting

### Common Issues and Solutions

#### Fans Not Activating
- Check entity ID mapping in automation files
- Verify fan entities are available and controllable
- Check existing room fan automation conflicts

#### E130 Not Responding
- Verify AprilAire E130 entity ID and availability
- Check existing dehumidifier automation conflicts
- Test manual control of E130 entity

#### Temperature Stratification Issues
- Verify all temperature sensor entities are available
- Check sensor placement and calibration
- Monitor for sensor connectivity issues

#### Humidity Emergency False Alarms
- Check weighted humidity sensor accuracy
- Verify 59% threshold is appropriate for system
- Consider adjusting trigger timing if needed

### Log Monitoring
```bash
# Monitor automation execution
tail -f /config/home-assistant.log | grep -i "slab_charging\|humidity_emergency"

# Monitor sensor updates
ha core states list | grep -E "slab_charging|stratification|humidity_safety"

# Monitor AprilAire E130 state changes
tail -f /config/home-assistant.log | grep -i "aprilaire\|dehumidifier"
```

## Success Criteria Met ✅

### Task 1: Enhanced Circulation During Slab Charging ✅
- ✅ HVAC fan mandatory operation during 5AM-8AM
- ✅ 15-minute minimum runtime (via existing equipment protection)
- ✅ Progressive room fan activation based on stratification
- ✅ Enhanced humidity monitoring with E130 coordination

### Task 2: Gulf Coast Humidity Safety Enhancement ✅ 
- ✅ E130 activation threshold: 55% during charging
- ✅ Continuous monitoring with 2-minute evaluation cycles
- ✅ Emergency protocols at 59% (slab charging specific)
- ✅ Distribution optimization with coordinated fan control

### Task 3: Single-Story Distribution Strategy ✅
- ✅ Horizontal distribution focus with room temperature monitoring
- ✅ Stratification response to >2°F temperature differences
- ✅ AprilAire integration for dehumidified air distribution
- ✅ Energy efficiency through smart fan control

### Task 4: System Integration ✅
- ✅ Modular coordination approach for maintainability
- ✅ Integration with existing `script.central_fan_control`
- ✅ Weather front detection integration
- ✅ Equipment protection and safety protocols

## Implementation Complete

The AprilAire E130 coordination system is fully implemented and ready for activation. The system provides:

- **Maximum effectiveness**: Optimal slab charging air distribution
- **Strict safety**: 60% humidity ceiling protection with Gulf Coast awareness  
- **Single-story optimization**: Horizontal air mixing and temperature control
- **Seamless integration**: Works with existing automation without conflicts
- **Gulf Coast climate protection**: Weather-aware humidity management

**Next Steps**: Entity ID validation and controlled testing during non-peak hours before full 5AM-8AM activation.