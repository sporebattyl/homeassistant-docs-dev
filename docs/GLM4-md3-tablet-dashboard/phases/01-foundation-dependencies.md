# Phase 1: Foundation & Dependencies

**Duration**: 1-2 days
**Status**: Ready to Start
**Prerequisites**: HACS installed, Home Assistant 2025.10.4+

## 🎯 Phase Objectives

1. Install all required HACS components
2. Set up Material Design 3 theme foundation
3. Verify component compatibility
4. Create project structure
5. Test basic functionality

## 📦 Required HACS Components

### Core MD3 Components
```yaml
# Essential for MD3 implementation
- mushroom-cards              # Primary MD3 card library
- button-card                # Advanced button styling
- card-mod                   # CSS styling capabilities
- stack-in-card              # Card organization
- auto-entities              # Dynamic card generation
- layout-card                # Grid layouts
```

### Enhanced Features
```yaml
# Advanced functionality
- apexcharts-card            # Advanced charts and graphs
- bubble-card                # Modern floating elements
- mini-graph-card           # Trending data visualization
- simple-icons              # Extended icon library
- swiss-army-knife-card     # Complex layouts
- timer-bar-card            # Visual progress indicators
- mushroom-title-card       # Enhanced title cards
```

### Tablet Optimization
```yaml
# Tablet-specific features
- lovelace-card-tools       # Utility functions
- custom-header             # Custom header options
- vertical-stack-in-card    # Better vertical layouts
- hui-element               # Enhanced UI elements
- state-switch              # Advanced state management
```

## 🔧 Installation Process

### 1. Install via HACS UI
```
Settings → HACS → Integrations → Explore & Download Repositories
Search for each component above and install
```

### 2. Manual Installation (if needed)
Add to `configuration.yaml` resources:
```yaml
frontend:
  modules:
    - url: /hacsfiles/mushroom/mushroom.js
      type: module
    - url: /hacsfiles/button-card/button-card.js
      type: module
    - url: /hacsfiles/card-mod/card-mod.js
      type: module
    # Add other components as needed
```

### 3. Restart Home Assistant
```bash
ha-restart
```

## 🎨 Theme Foundation Setup

### Material Design 3 Base Theme
Create `themes/md3-tablet-base.yaml`:
```yaml
md3-tablet-base:
  # Material Design 3 Color Scheme
  primary-color: "#6750A4"
  primary-background-color: "#FEF7FF"
  secondary-color: "#625B71"
  tertiary-color: "#7D5260"

  # Surface Colors
  surface-color: "#FFFBFE"
  surface-variant-color: "#E7E0EC"
  background-color: "#FEF7FF"

  # Text Colors
  on-primary-color: "#FFFFFF"
  on-surface-color: "#1C1B1F"
  on-background-color: "#1C1B1F"

  # State Colors
  error-color: "#BA1A1A"
  warning-color: "#B68B00"
  success-color: "#146C2E"

  # MD3 Specific
  border-radius: "16px"
  card-border-radius: "16px"
  state-icon-color: "#6750A4"

  # Tablet Optimizations
  ha-card-border-radius: "16px"
  ha-card-box-shadow: "0px 1px 3px rgba(0,0,0,0.12), 0px 1px 2px rgba(0,0,0,0.24)"

  # Animations
  animation-easing: "cubic-bezier(0.4, 0.0, 0.2, 1)"
  animation-duration: "200ms"
```

### Gulf Coast Climate Theme
Create `themes/md3-gulf-coast.yaml`:
```yaml
md3-gulf-coast:
  # Gulf Coast Inspired Colors
  primary-color: "#1565C0"        # Ocean blue
  primary-background-color: "#E3F2FD"
  secondary-color: "#00838F"      # Gulf green
  tertiary-color: "#2E7D32"       # Coastal green

  # Climate-Specific
  climate-heat-color: "#F44336"   # Heat alert red
  climate-cool-color: "#2196F3"   # Cool blue
  humidity-high-color: "#FF9800"  # Humidity orange
  humidity-normal-color: "#4CAF50" # Normal green

  # Dew Point Colors
  dew-point-comfortable: "#4CAF50"   # Comfortable green
  dew-point-moderate: "#FFC107"     # Moderate yellow
  dew-point-high: "#FF5722"         # High orange
  dew-point-extreme: "#F44336"      # Extreme red

  # Equipment Status
  equipment-on-color: "#4CAF50"     # Equipment running green
  equipment-off-color: "#9E9E9E"    # Equipment off gray
  equipment-error-color: "#F44336"  # Error red

  # Gulf Coast Weather Integration
  weather-sunny: "#FFC107"
  weather-cloudy: "#78909C"
  weather-rainy: "#42A5F5"
  weather-stormy: "#5C6BC0"
```

## 📁 Project Structure Setup

### Dashboard Directory
```bash
mkdir -p dashboards/md3-tablet/
mkdir -p themes/md3/
mkdir -p config/md3-templates/
```

### File Organization
```
dashboards/md3-tablet/
├── overview.yaml              # Main overview page
├── climate-control.yaml       # Climate dashboard
├── room-controls.yaml         # Room-based controls
├── weather-environment.yaml   # Weather + environmental
├── scenes-automation.yaml     # Scene presets
├── energy-monitoring.yaml     # Energy usage
├── calendar-scheduling.yaml   # Calendar integration
└── settings-customization.yaml # Settings + themes

themes/md3/
├── md3-tablet-base.yaml       # Base MD3 theme
├── md3-gulf-coast.yaml        # Gulf Coast variant
├── md3-dark.yaml              # Dark mode variant
└── md3-responsive.yaml        # Responsive adjustments
```

## ✅ Verification Checklist

### Component Installation
- [ ] All HACS components installed successfully
- [ ] Components appear in Resources list
- [ ] No JavaScript errors in browser console
- [ ] Cards appear in card picker

### Theme Functionality
- [ ] Base MD3 theme applies correctly
- [ ] Gulf Coast variant loads
- [ ] Color scheme matches design
- [ ] Dark mode switching works

### Basic Testing
- [ ] Create simple Mushroom card
- [ ] Test Button Card functionality
- [ ] Verify card-mod styling works
- [ ] Check responsive layouts

## 🔧 Configuration Updates

### Add to `configuration.yaml`:
```yaml
frontend:
  themes: !include_dir_merge_named themes/

# Load MD3 dashboard configurations
lovelace:
  mode: yaml
  resources:
    - url: /hacsfiles/mushroom/mushroom.js
      type: module
    - url: /hacsfiles/button-card/button-card.js
      type: module
    - url: /hacsfiles/card-mod/card-mod.js
      type: module
    - url: /hacsfiles/stack-in-card/stack-in-card.js
      type: module
    - url: /hacsfiles/auto-entities/auto-entities.js
      type: module
    - url: /hacsfiles/layout-card/layout-card.js
      type: module
    - url: /hacsfiles/apexcharts-card/apexcharts-card.js
      type: module
    - url: /hacsfiles/bubble-card/bubble-card.js
      type: module
```

## 🚀 Next Steps

Once Phase 1 is complete:
1. **Phase 2**: Core dashboard structure and navigation
2. **Phase 3**: Material Design 3 implementation
4. **Phase 4**: Gulf Coast climate integration
5. **Phase 5**: Dynamic features and animations
6. **Phase 6**: Optimization and polish

## 🐛 Troubleshooting

### Common Issues
1. **Components not loading**: Check HACS installation and restart HA
2. **Theme not applying**: Verify theme files in correct directory
3. **Card errors**: Check browser console for JavaScript errors
4. **Responsive issues**: Test on tablet device/emulator

### Support Resources
- [Mushroom Cards Documentation](https://github.com/piitaya/lovelace-mushroom)
- [Button Card Documentation](https://github.com/custom-cards/button-card)
- [Home Assistant Community](https://community.home-assistant.io/)

---

**Ready for Phase 2?** Once all dependencies are installed and verified, proceed to [Phase 2: Core Dashboard Structure](02-core-structure.md)