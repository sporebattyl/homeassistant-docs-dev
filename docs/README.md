# 📚 Climate Optimization Documentation Hub
**ClaudeLog.com Best Practices Implementation** | **Updated: September 15, 2025**

**Current Status**: ✅ **Phase 2C Complete** - Ready for Phase 2D Final Optimization  
**Architecture**: 15 packages + coordination layer + energy intelligence (optimal structure)

---

## 🎯 QUICK START NAVIGATION

### **🚀 For Immediate Session Continuation**
```
docs/claudelog-sessions/SESSION_HANDOFF_MASTER.md
```
**Zero ramp-up session transfer with complete technical context**

### **📊 For Current System Understanding**
```
docs/phase-reports/PHASE_2C_COMPLETION_CONSOLIDATED.md
```
**Comprehensive achievement summary with architecture details**

### **🎯 For Next Phase Execution**
```
docs/handoff-continuity/PHASE_2D_PREPARATION.md
```
**Ready-to-execute optimization plan with proven methodology**

### **📋 For Navigation & Organization**
```
docs/claudelog-sessions/DOCUMENTATION_ORGANIZATION_GUIDE.md
```
**Complete documentation structure and access patterns**

---

## 📸 Entity State Snapshots

### `climate-entities.json`
**Captured:** 2025-10-12
**Entities:** 3,822 total (1,062 climate-related)
**Purpose:** Complete system state snapshot for AI model context
**Usage:** Reference in `IMPROVED_CLIMATE_PROMPT.md` for climate automation reviews

**Filtering Examples:**
```bash
# Climate-related entities only
jq '[.[] | select(.entity_id | startswith("climate.") or startswith("sensor.temp"))]' climate-entities.json

# Unavailable entities
jq '[.[] | select(.state == "unavailable")]' climate-entities.json

# 15-sensor network status
jq '[.[] | select(.entity_id | test("temphumidsensor[0-9]+"))]' climate-entities.json
```

---

# Home Assistant Configuration Archive

## Overview (Historical Reference)
This Home Assistant configuration features advanced automation for smart home control, security monitoring, and robotic vacuum cleaning with sophisticated room-specific operations.

**Note**: The documentation below represents the historical configuration structure. For current climate optimization project documentation, use the navigation links above.

## Configuration Structure

### Core Configuration
- `configuration.yaml` - Main configuration with organized includes
- `secrets.yaml` - Sensitive information (not tracked in git)

### Customizations Directory (`customization/`)
- **covers.yaml** - Garage door template covers (momentary switch logic)
- **envisalink.yaml** - Honeywell alarm panel integration  
- **input_boolean.yaml** - Helper switches for automation logic
- **input_number.yaml** - Numeric helpers (e.g., Sonos volume control)
- **lights.yaml** - Light groups and configurations
- **recorder.yaml** - Database optimization settings
- **shell_command.yaml** - Custom shell commands

### Automations Directory (`automations/`)
- **cleaning.yaml** - Advanced Dreame vacuum automations with room segments
- **garage.yaml** - Garage door control, lighting, and security
- **lighting.yaml** - Occupancy-based lighting and outdoor timers
- **media_controls.yaml** - Sonos volume sync automations
- **monitoring.yaml** - Device status monitoring and night security
- **other.yaml** - Miscellaneous automations
- **sceneautomation.yaml** - Night/morning routines and fan control
- **switches.yaml** - Z-Wave switch blueprint automations

### Templates Directory (`templates/`)
- **aicleaner_sensors.yaml** - AI cleaning analysis sensors
- **office_sensors.yaml** - Office occupancy and environment sensors

## Key Features

### 🧹 Advanced Vacuum Control
- **Room-specific cleaning** with 22 mapped room segments
- **Multi-mode operation** (sweeping → mopping with automatic mode switching)
- **Bin emptying cycles** between room groups
- **Litter robot integration** for automatic bathroom cleaning
- **Z-Wave switch triggers** for instant room cleaning (5x button press)

### 🔒 Comprehensive Security
- **Night automation** with device verification and retry logic
- **Monitoring alerts** for device offline/online status
- **Garage door security** with auto-close when leaving
- **Alarm panel integration** with Envisalink (Honeywell)

### 💡 Smart Lighting
- **Occupancy-based control** with motion sensors
- **Outdoor lighting** synchronized with sunrise/sunset
- **Z-Wave dimmer integration** with multi-tap actions
- **Under-cabinet lighting** with auto-off and DND mode

### 🎵 Media Control
- **Sonos volume control** via input_number helper with bi-directional sync
- **Office TV automation** based on occupancy patterns

### ⚡ Performance Optimizations
- **Database recorder** configured to exclude high-frequency sensors
- **30-day history retention** with optimized commit intervals
- **Entity filtering** to reduce database size

## Blueprint Information

### Corrected Blueprints
- **muddro_zen7x_corrected.yaml** - Fixed numeric comparison for Z-Wave JS press count events
  - Critical fix for 5x button press automations
  - Used by ZEN77 switches for vacuum triggers

## Room Segment Map
Dreame vacuum room segments (22 total):
- **1**: Master Bedroom, **2**: Master Bath, **3**: Laundry
- **4**: Half Bath, **5**: Guest Bathroom, **6-7**: Corridors
- **8**: Guest Bedroom, **9**: Office, **10**: Entryway
- **11,13,14,21**: Living Room areas, **12,19**: Foyer areas
- **15**: Kitchen, **16**: Bar, **17**: Corridor 3
- **18**: Closet, **20**: Dining Hall, **22**: Corridor 4

## Maintenance Notes

### Recent Improvements (2025-07-27)
✅ **Sonos Volume Control** - Replaced light entity with proper input_number helper  
✅ **Garage Door Logic** - Documented momentary switch pattern with modern syntax  
✅ **Blueprint Verification** - Confirmed corrected Z-Wave blueprint is essential  
✅ **Database Optimization** - Added recorder configuration for performance  
✅ **File Organization** - Moved backup files to `/backups/` directory

### Custom Components Status
- **dreame_vacuum**: v2.0.0b19 (beta) - ✅ Working perfectly, advanced features required
- **adaptive_lighting**: ✅ Active and stable
- **ai_automation_suggester**: ✅ Active for automation recommendations  
- **hacs**: ✅ Managing custom component updates
- **petkit**: ✅ Litter robot integration
- **tuya_local**: ✅ Local Tuya device control

## Getting Started
1. Review `secrets.yaml.example` for required secret definitions
2. Verify entity names match your devices in automations
3. Check Z-Wave device IDs in switch automations
4. Test vacuum room segments for your floor plan

## Support
- Check `home-assistant.log` for any configuration errors
- Blueprint documentation in `/blueprints/automation/README.md`
- Vacuum room mapping documented in cleaning automations