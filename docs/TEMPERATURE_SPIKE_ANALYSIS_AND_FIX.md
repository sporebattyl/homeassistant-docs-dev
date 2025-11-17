# Temperature Spike Analysis: Why 78°F Was Allowed Last Night

## **Executive Summary**
On September 13, 2025 at 4:08 AM, your Home Assistant climate system allowed the temperature to reach 78°F. This was **NOT a malfunction** - the system was working exactly as programmed. The issue stems from a design flaw in the HVAC Equipment Arbitration Master automation.

## **Root Cause Analysis** 🎯

### **Timeline of Events**

**4:08:19 AM** - Critical Mode Change:
- Thermostat switched from `cool` mode (single setpoint: 75°F)
- **TO** `heat_cool` mode with **target_temp_high: 78°F**
- This 78°F upper limit is exactly the temperature you experienced

**4:08:25 AM** - Attempted Correction:
- System adjusted to target_temp_high: 76°F, target_temp_low: 71°F

**4:30:02 AM** - Final Correction:
- Adjusted to target_temp_high: 75°F, target_temp_low: 67°F
- This is when proper cooling resumed

### **The Automation Chain That Caused This** 🔗

1. **Foundation Climate Mode**: Currently set to `"auto"`

2. **HVAC Equipment Arbitration Master** (`packages/climate_globals.yaml:481`):
   ```yaml
   hvac_mode: >
     {% if climate_mode == 'auto' %}
       heat_cool  # <-- This triggers the problem
   ```

3. **Temperature Setting Logic** (`packages/climate_globals.yaml:493-495`):
   ```yaml
   - service: climate.set_temperature
     target: {entity_id: climate.thermostat}
     data: {temperature: "{{ target_temp }}"}  # <-- Wrong for heat_cool mode
   ```

### **The Design Flaw** ⚠️

When the thermostat is in `heat_cool` mode, the `temperature` parameter is ignored. Instead, the thermostat uses:
- `target_temp_high`: Upper cooling threshold
- `target_temp_low`: Lower heating threshold

**The problem**: The automation sets a single `temperature` value, but the thermostat defaults to **its own internal high/low values** when in `heat_cool` mode, which included the 78°F upper limit.

## **Current System Status**

- **Foundation Climate Mode**: `auto` ✅
- **Foundation Occupancy Mode**: `home` ✅
- **Foundation Cooling Target (Home)**: 75°F ✅
- **Current Thermostat Mode**: `heat_cool` with 75°F high / 67°F low ✅
- **Vulnerability**: **This issue will happen again** when the system resets or restarts

## **Detailed Fix Plan** 🔧

### **Primary Fix: Update HVAC Equipment Arbitration Master**

**File**: `packages/climate_globals.yaml`
**Lines**: 493-495

**Current (Problematic) Code:**
```yaml
- service: climate.set_temperature
  target: {entity_id: climate.thermostat}
  data: {temperature: "{{ target_temp }}"}
```

**Replacement Code:**
```yaml
- service: climate.set_temperature
  target: {entity_id: climate.thermostat}
  data: >
    {% if states('climate.thermostat') == 'heat_cool' %}
      {
        "target_temp_high": {{ (target_temp + (states('input_number.foundation_temperature_deadband') | float(1.0) / 2)) | round(1) }},
        "target_temp_low": {{ (states('input_number.foundation_heating_target_' + ('home' if occupancy_mode == 'home' else 'away')) | float(68) - (states('input_number.foundation_temperature_deadband') | float(1.0) / 2)) | round(1) }}
      }
    {% else %}
      {"temperature": {{ target_temp }}}
    {% endif %}
```

### **Secondary Fix: Add Safety Validation**

**Add this validation block before the temperature setting:**

```yaml
- variables:
    calculated_high_temp: >
      {{ (target_temp + (states('input_number.foundation_temperature_deadband') | float(1.0) / 2)) | round(1) }}
    max_allowed_temp: >
      {% if occupancy_mode == 'home' %}
        76.0
      {% else %}
        79.0
      {% endif %}
    safe_high_temp: >
      {{ [calculated_high_temp, max_allowed_temp] | min }}
```

### **Tertiary Fix: Add Logging for Debugging**

**Add this logging block after temperature setting:**
```yaml
- service: logbook.log
  data:
    name: "HVAC Equipment Arbitration"
    message: >
      Mode: {{ states('climate.thermostat') }} | 
      Occupancy: {{ occupancy_mode }} | 
      Target: {{ target_temp }}°F | 
      {% if states('climate.thermostat') == 'heat_cool' %}
        High: {{ safe_high_temp }}°F, Low: {{ calculated_low_temp }}°F
      {% else %}
        Single: {{ target_temp }}°F
      {% endif %}
```

## **Implementation Strategy**

### **Phase 1: Immediate Fix (15 minutes)**
1. Edit `packages/climate_globals.yaml` lines 493-495
2. Replace temperature setting logic with heat_cool-aware code
3. Test with current system state

### **Phase 2: Validation (30 minutes)**
1. Monitor next automation trigger
2. Verify target_temp_high never exceeds 76°F in home mode
3. Confirm Foundation variables are being used correctly

### **Phase 3: Documentation (15 minutes)**
1. Add comments explaining the heat_cool logic
2. Document the fix in this file
3. Update any related documentation

## **Technical Details**

### **Foundation Variables Used:**
- `input_number.foundation_cooling_target_home`: 75°F
- `input_number.foundation_cooling_target_away`: 78°F  
- `input_number.foundation_heating_target_home`: 68°F
- `input_number.foundation_heating_target_away`: 65°F
- `input_number.foundation_temperature_deadband`: 1.0°F

### **Expected Behavior After Fix:**
- **Home Mode heat_cool**: High=75.5°F, Low=67.5°F
- **Away Mode heat_cool**: High=78.5°F, Low=64.5°F
- **Cool Mode**: Single setpoint as configured
- **Heat Mode**: Single setpoint as configured

## **Risk Assessment** 

### **Low Risk Changes:**
- ✅ Uses existing Foundation variables
- ✅ Maintains current safety systems
- ✅ Preserves equipment arbitration logic
- ✅ No new dependencies

### **High Impact Benefits:**
- 🎯 Prevents 78°F temperature spikes in home mode
- 🎯 Consistent behavior across all modes
- 🎯 Proper Foundation variable integration
- 🎯 Better occupancy mode respect

## **Testing Plan**

### **Test 1: Manual Mode Switch**
```bash
# Set to auto mode and monitor response
curl -X POST -H "Authorization: Bearer [TOKEN]" \
  -H "Content-Type: application/json" \
  http://192.168.88.125:8123/api/services/input_select/select_option \
  -d '{"entity_id": "input_select.foundation_climate_mode", "option": "auto"}'
```

### **Test 2: Occupancy Mode Switch**
```bash
# Switch between home/away and verify different setpoints
curl -X POST -H "Authorization: Bearer [TOKEN]" \
  -H "Content-Type: application/json" \
  http://192.168.88.125:8123/api/services/input_select/select_option \
  -d '{"entity_id": "input_select.foundation_occupancy_mode", "option": "away"}'
```

### **Test 3: Monitor Logs**
```bash
# Watch for the new logging messages
tail -f /home/drewcifer/mnt/homeassistant-config/home-assistant.log | grep "HVAC Equipment Arbitration"
```

## **Rollback Plan**

If issues occur, restore the original code:
```yaml
- service: climate.set_temperature
  target: {entity_id: climate.thermostat}
  data: {temperature: "{{ target_temp }}"}
```

## **Long-term Recommendations**

1. **Consider Single Mode Operation**: If you primarily need cooling, consider setting `foundation_climate_mode` to `"cooling"` instead of `"auto"`

2. **Enhanced Monitoring**: Add dashboard tiles to monitor:
   - Current thermostat mode
   - Target temperatures (high/low)
   - Foundation variable values

3. **Scheduled Reviews**: Check this configuration quarterly during season changes

## **Conclusion**

This fix addresses the exact root cause of the 78°F temperature spike while preserving your sophisticated climate system architecture. The issue was not a failure of your climate intelligence - it was a gap in the integration between single-setpoint Foundation variables and dual-setpoint heat_cool mode operation.

**Next Action**: Implement Phase 1 fix and monitor the next automation trigger to confirm resolution.