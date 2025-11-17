# 🚀 ENERGY MONITORING ACTIVATION GUIDE
**Phase 2B-1 Implementation Complete** - Smart Plug → Emporia Vue 3 Expandable Architecture

## ✅ SYSTEM STATUS: READY FOR ACTIVATION

**Infrastructure**: 5 new energy monitoring packages successfully integrated  
**Validation**: Home Assistant restart successful - all packages loaded  
**Baseline**: Current stub sensors providing 2.1 kWh/day baseline ($91/year)  
**Target**: $520-960/year efficiency optimization through real energy feedback

---

## 🎯 IMMEDIATE ACTIVATION OPTIONS

### Option 1: START WITH SMART PLUG (RECOMMENDED)
**Current Hardware**: 1 smart plug monitoring dehumidifier  
**Activation**: Enable real dehumidifier energy monitoring  
**Benefit**: Immediate accuracy improvement for Gulf Coast humidity optimization

### Option 2: EMPORIA VUE 3 PREPARATION
**Future Hardware**: Whole-home monitoring planned  
**Preparation**: Complete installation readiness checklist  
**Benefit**: Seamless transition when Vue 3 hardware arrives

---

## 🔧 SMART PLUG ACTIVATION (OPTION 1)

### Step 1: Identify Your Smart Plug Entity
From your existing climate system, these dehumidifier entities were found:
- `switch.upstairs_dehumidifier` (most common reference)
- `switch.aprilaire_e130_dehumidifier` 
- `switch.dehumidifier_relay_l1`
- `dehumidifier.aprila_aire_e130`

**ACTION NEEDED**: Identify which entity has power monitoring capability  
**Example**: Look for `sensor.upstairs_dehumidifier_power` or similar

### Step 2: Configure Real Energy Entity
**Current Sensor Check**:
```bash
# Check if your smart plug already provides power monitoring
grep -r "dehumidifier.*power" /config/  # Look for existing power sensors
```

**If Power Sensor Exists**:
1. Note the exact entity name (e.g., `sensor.dehumidifier_power`)
2. Update the hybrid sensor configuration to use your real entity

**If No Power Sensor**:
- Smart plug may need configuration in its integration
- Check device settings in Home Assistant UI
- Some plugs require enabling power monitoring

### Step 3: Enable Real Energy Monitoring
**Via Home Assistant UI**:
1. Go to Settings → Devices & Services → Helpers
2. Find "Enable Dehumidifier Real Energy Monitoring"
3. Toggle to **ON**

**Via Developer Tools**:
```yaml
service: input_boolean.turn_on
target:
  entity_id: input_boolean.enable_dehumidifier_real_energy
```

### Step 4: Validate Real Data Integration
**Check Hybrid Sensor**:
- Entity: `sensor.climate_energy_dehumidifier_power_hybrid`
- Should show "real" as data source when smart plug active
- Should fall back to "stub" when smart plug unavailable

**Monitor Validation Dashboard**:
- Entity: `sensor.energy_monitoring_system_health`
- Shows real vs stub accuracy comparison
- Tracks system integration health

---

## 📊 EMPORIA VUE 3 PREPARATION (OPTION 2)

### Installation Readiness Checklist
**Pre-Installation**:
- [ ] Electrical panel access confirmed
- [ ] Wi-Fi signal strength at panel location tested
- [ ] Circuit breaker mapping completed
- [ ] Installation appointment scheduled

**Circuit Mapping for Gulf Coast Home**:
```yaml
# Pre-configured for your Lennar Cabot floor plan
Main Circuits:
- HVAC (Lennox Merit® ML14XC1)
- Dehumidifier (Aprilaire E130)
- Fans (Living Room, Office, Bedrooms)
- Major Appliances (Kitchen, Laundry)
- General Circuits (Lighting, Outlets)
```

**Vue 3 Configuration Preparation**:
- Entity templates already created in `climate_energy_vue3_preparation.yaml`
- Circuit monitoring sensors pre-configured
- Baseline data collection framework ready
- Integration testing scripts prepared

### Activation Sequence (When Vue 3 Installed)
1. **Enable Vue 3 Integration**: `input_boolean.enable_vue3_integration = ON`
2. **Test Whole-Home Data**: Verify main power monitoring
3. **Enable Circuit Monitoring**: `input_boolean.enable_vue3_circuit_monitoring = ON`
4. **Validate All Sensors**: Check hybrid sensors prefer Vue 3 data
5. **Retire Stub Sensors**: Gradually disable stub fallbacks

---

## 🎮 SYSTEM CONTROL PANEL

### Master Controls (Always Available)
```yaml
# Main system toggle
input_boolean.enable_energy_monitoring_system: true

# Validation dashboard
input_boolean.enable_energy_validation_dashboard: true
```

### Real Sensor Controls (Phase 1)
```yaml
# Smart plug era controls
input_boolean.enable_dehumidifier_real_energy: false → true (when smart plug configured)
input_boolean.enable_hvac_real_energy: false → true (when HVAC monitoring available)
input_boolean.enable_fan_real_energy: false → true (when fan power monitoring available)
```

### Vue 3 Controls (Phase 2)
```yaml
# Emporia Vue 3 era controls
input_boolean.enable_vue3_integration: false → true (when Vue 3 installed)
input_boolean.enable_vue3_circuit_monitoring: false → true (for circuit-level data)
```

---

## 📈 EFFICIENCY OPTIMIZATION PATHWAY

### Current State (Phase 0)
- **Energy Source**: Improved stub sensors
- **Baseline**: 2.1 kWh/day ($91/year)
- **Intelligence**: Coordination layer with estimated energy feedback

### Smart Plug Integration (Phase 1A)
- **Energy Source**: Real dehumidifier + improved stubs
- **Expected**: 5-10% accuracy improvement
- **Intelligence**: Enhanced humidity coordination with real energy data
- **Validation**: Real vs stub comparison metrics

### Full Vue 3 Integration (Phase 2)
- **Energy Source**: Whole-home + circuit monitoring
- **Expected**: 20-25% efficiency improvement ($520-960/year target)
- **Intelligence**: Full energy-aware automation optimization
- **Validation**: Complete ROI tracking and optimization

---

## 🛡️ SAFETY & ROLLBACK

### Emergency Rollback
**Instant Fallback**:
```yaml
# Disable all real energy sensors - immediate return to stubs
input_boolean.enable_energy_monitoring_system: false
```

**Selective Rollback**:
```yaml
# Disable specific problematic sensors while keeping others
input_boolean.enable_dehumidifier_real_energy: false
input_boolean.enable_vue3_integration: false
```

### System Health Monitoring
- **Entity**: `sensor.energy_monitoring_system_health`
- **Metrics**: Real sensor availability, accuracy scores, integration health
- **Alerts**: Automated notifications for sensor failures or accuracy degradation

---

## 🎯 NEXT STEPS RECOMMENDATIONS

### **IMMEDIATE (Today)**:
1. **Identify Smart Plug Power Entity**: Find your dehumidifier power sensor
2. **Test Real Data**: Enable `input_boolean.enable_dehumidifier_real_energy`
3. **Monitor Dashboard**: Watch validation metrics for accuracy improvement

### **SHORT-TERM (This Week)**:
1. **Optimize Smart Plug Integration**: Fine-tune real vs stub fallback
2. **Prepare Vue 3**: Complete installation readiness checklist
3. **Baseline Collection**: Gather data for Vue 3 comparison

### **MEDIUM-TERM (Next Month)**:
1. **Vue 3 Installation**: Schedule and complete whole-home monitoring setup
2. **Circuit Mapping**: Configure individual device monitoring
3. **Intelligence Enhancement**: Enable energy-aware automation optimization

---

## ✅ SUCCESS CRITERIA

### **Phase 1A Success** (Smart Plug Integration):
- Real dehumidifier energy data integrated ✓
- Coordination layer using real energy for decisions ✓
- Validation dashboard showing accuracy improvement ✓
- System health score >90% ✓

### **Phase 2 Success** (Vue 3 Integration):
- Whole-home energy monitoring operational ✓
- Individual circuit data feeding coordination layer ✓
- Efficiency improvement >20% validated ✓
- ROI progression toward $520-960/year target ✓

---

**🚀 READY TO ACTIVATE: Your expandable energy monitoring system is live and ready for immediate smart plug integration with seamless Vue 3 scaling capability!**