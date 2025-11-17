# Phase 3: Material Design 3 Implementation

**Duration**: 3-4 days
**Status**: Ready after Phase 2 completion
**Prerequisites**: Core dashboard structure established

## 🎯 Phase Objectives

1. Implement Material Design 3 styling principles
2. Create dynamic theming system
3. Add MD3 animations and transitions
4. Optimize touch interactions for tablets
5. Establish color system and typography

## 🎨 Material Design 3 Color System

### Dynamic Color Tokens
Create `themes/md3-colors.yaml`:
```yaml
md3-colors:
  # Material Design 3 Color Tokens
  --md-sys-color-primary: #6750A4
  --md-sys-color-on-primary: #FFFFFF
  --md-sys-color-primary-container: #EADDFF
  --md-sys-color-on-primary-container: #21005D

  --md-sys-color-secondary: #625B71
  --md-sys-color-on-secondary: #FFFFFF
  --md-sys-color-secondary-container: #E8DEF8
  --md-sys-color-on-secondary-container: #1D192B

  --md-sys-color-tertiary: #7D5260
  --md-sys-color-on-tertiary: #FFFFFF
  --md-sys-color-tertiary-container: #FFD8E4
  --md-sys-color-on-tertiary-container: #31111D

  --md-sys-color-surface: #FEF7FF
  --md-sys-color-on-surface: #1C1B1F
  --md-sys-color-surface-variant: #E7E0EC
  --md-sys-color-on-surface-variant: #49454F

  --md-sys-color-background: #FEF7FF
  --md-sys-color-on-background: #1C1B1F

  # Gulf Coast Climate Colors
  --climate-heat: #F44336
  --climate-cool: #2196F3
  --humidity-high: #FF9800
  --humidity-normal: #4CAF50
  --dew-point-comfortable: #4CAF50
  --dew-point-moderate: #FFC107
  --dew-point-high: #FF5722

  # State Colors
  --state-active: #4CAF50
  --state-inactive: #9E9E9E
  --state-warning: #FF9800
  --state-error: #F44336
  --state-info: #2196F3

  # Tablet-Specific
  --tablet-touch-target: 48px
  --tablet-border-radius: 16px
  --tablet-elevation-1: 0px 1px 3px rgba(0,0,0,0.12), 0px 1px 2px rgba(0,0,0,0.24)
  --tablet-elevation-2: 0px 3px 6px rgba(0,0,0,0.16), 0px 3px 6px rgba(0,0,0,0.23)
  --tablet-elevation-3: 0px 10px 20px rgba(0,0,0,0.19), 0px 6px 6px rgba(0,0,0,0.23)
```

### Typography System
Create `themes/md3-typography.yaml`:
```yaml
md3-typography:
  # Material Design 3 Typography Scale
  --md-sys-typescale-headline-large-font: 'Google Sans'
  --md-sys-typescale-headline-large-weight: 400
  --md-sys-typescale-headline-large-size: 32px
  --md-sys-typescale-headline-large-line-height: 40px
  --md-sys-typescale-headline-large-letter-spacing: 0px

  --md-sys-typescale-headline-medium-font: 'Google Sans'
  --md-sys-typescale-headline-medium-weight: 400
  --md-sys-typescale-headline-medium-size: 28px
  --md-sys-typescale-headline-medium-line-height: 36px
  --md-sys-typescale-headline-medium-letter-spacing: 0px

  --md-sys-typescale-body-large-font: 'Google Sans'
  --md-sys-typescale-body-large-weight: 400
  --md-sys-typescale-body-large-size: 16px
  --md-sys-typescale-body-large-line-height: 24px
  --md-sys-typescale-body-large-letter-spacing: 0.5px

  --md-sys-typescale-body-medium-font: 'Google Sans'
  --md-sys-typescale-body-medium-weight: 400
  --md-sys-typescale-body-medium-size: 14px
  --md-sys-typescale-body-medium-line-height: 20px
  --md-sys-typescale-body-medium-letter-spacing: 0.25px

  --md-sys-typescale-label-large-font: 'Google Sans'
  --md-sys-typescale-label-large-weight: 500
  --md-sys-typescale-label-large-size: 14px
  --md-sys-typescale-label-large-line-height: 20px
  --md-sys-typescale-label-large-letter-spacing: 0.1px
```

## 🎭 Advanced MD3 Card Styling

### Enhanced Mushroom Card Template
Create `config/md3-templates/mushroom-card-enhanced.yaml`:
```yaml
button_card_templates:
  md3_gulf_coast_climate:
    template:
      - mushroom_entity_card
    entity: >
      [[[ return variables.entity || entity; ]]]
    name: >
      [[[ return variables.name || state_attr(entity, 'friendly_name'); ]]]
    icon: >
      [[[ return variables.icon || state_attr(entity, 'icon'); ]]]
    layout: vertical
    double_tap_action:
      action: more-info
    card_mod:
      style: |
        ha-card {
          background: var(--md-sys-color-surface);
          border-radius: var(--tablet-border-radius);
          box-shadow: var(--tablet-elevation-1);
          transition: all 0.3s cubic-bezier(0.4, 0.0, 0.2, 1);
          border: 1px solid var(--md-sys-color-outline, #E7E0EC);
          overflow: hidden;
          position: relative;
        }

        ha-card:hover {
          transform: translateY(-2px);
          box-shadow: var(--tablet-elevation-2);
          border-color: var(--md-sys-color-primary);
        }

        ha-card:active {
          transform: translateY(0px);
          box-shadow: var(--tablet-elevation-1);
        }

        /* Ripple effect */
        ha-card::after {
          content: '';
          position: absolute;
          top: 50%;
          left: 50%;
          width: 5px;
          height: 5px;
          background: rgba(103, 80, 164, 0.3);
          opacity: 0;
          border-radius: 100%;
          transform: scale(1, 1) translate(-50%);
          transform-origin: 50% 50%;
        }

        ha-card:focus-within::after {
          animation: ripple 1s ease-out;
        }

        @keyframes ripple {
          0% {
            transform: scale(0, 0);
            opacity: 1;
          }
          20% {
            transform: scale(25, 25);
            opacity: 1;
          }
          100% {
            opacity: 0;
            transform: scale(40, 40);
          }
        }

        /* State indicator */
        mushroom-state-item {
          padding: 12px;
        }

        mushroom-shape-icon {
          --shape-color: var(--md-sys-color-primary-container);
          --icon-color: var(--md-sys-color-on-primary-container);
          transition: all 0.3s ease;
        }

        /* Content styling */
        mushroom-badge-icon {
          position: absolute;
          top: 8px;
          right: 8px;
          z-index: 10;
        }

        .primary {
          font-family: var(--md-sys-typescale-label-large-font);
          font-weight: var(--md-sys-typescale-label-large-weight);
          font-size: var(--md-sys-typescale-label-large-size);
          color: var(--md-sys-color-on-surface);
          margin-bottom: 4px;
        }

        .secondary {
          font-family: var(--md-sys-typescale-body-medium-font);
          font-weight: var(--md-sys-typescale-body-medium-weight);
          font-size: var(--md-sys-typescale-body-medium-size);
          color: var(--md-sys-color-on-surface-variant);
        }

  md3_climate_sensor:
    template: md3_gulf_coast_climate
    show_entity_picture: false
    show_name: true
    show_state: true
    card_mod:
      style: |
        /* Climate-specific color coding */
        ha-card {
          background: linear-gradient(135deg,
            rgba(33, 150, 243, 0.05),
            rgba(33, 150, 243, 0.02));
        }

        {% if 'temperature' in config.entity %}
        {% set temp = states(config.entity) | float %}
        {% if temp > 76 %}
        mushroom-shape-icon {
          --shape-color: var(--climate-heat);
          --icon-color: white;
        }
        {% elif temp < 68 %}
        mushroom-shape-icon {
          --shape-color: var(--climate-cool);
          --icon-color: white;
        }
        {% endif %}
        {% endif %}

        {% if 'humidity' in config.entity %}
        {% set humidity = states(config.entity) | float %}
        {% if humidity > 60 %}
        mushroom-shape-icon {
          --shape-color: var(--humidity-high);
          --icon-color: white;
        }
        {% else %}
        mushroom-shape-icon {
          --shape-color: var(--humidity-normal);
          --icon-color: white;
        }
        {% endif %}
        {% endif %}
```

### Dynamic Theming Card
Create `config/md3-templates/dynamic-theme-card.yaml`:
```yaml
# Time-based theme switching card
type: custom:mushroom-template-card
entity: sun.sun
primary: |
  [[[
    const hour = new Date().getHours();
    if (hour >= 6 && hour < 12) return "☀️ Good Morning";
    if (hour >= 12 && hour < 17) return "🌤️ Good Afternoon";
    if (hour >= 17 && hour < 20) return "🌅 Good Evening";
    return "🌙 Good Night";
  ]]]
secondary: |
  [[[
    const hour = new Date().getHours();
    if (hour >= 6 && hour < 12) return "Time for coffee and climate check";
    if (hour >= 12 && hour < 17) return "Peak cooling hours - monitor AC";
    if (hour >= 17 && hour < 20) return "Evening comfort time";
    return "Night mode - energy saving";
  ]]]
icon: mdi:theme-light-dark
icon_color: |
  [[[
    const hour = new Date().getHours();
    if (hour >= 6 && hour < 12) return 'amber';
    if (hour >= 12 && hour < 17) return 'orange';
    if (hour >= 17 && hour < 20) return 'deep-orange';
    return 'indigo';
  ]]]
card_mod:
  style: |
    ha-card {
      background: linear-gradient(135deg,
        [[[
          const hour = new Date().getHours();
          if (hour >= 6 && hour < 12) return '#FFF8E1';
          if (hour >= 12 && hour < 17) return '#FFF3E0';
          if (hour >= 17 && hour < 20) return '#FBE9E7';
          return '#E8EAF6';
        ]]],
        [[[
          const hour = new Date().getHours();
          if (hour >= 6 && hour < 12) return '#FFECB3';
          if (hour >= 12 && hour < 17) return '#FFE0B2';
          if (hour >= 17 && hour < 20) return '#FFCCBC';
          return '#C5CAE9';
        ]]]
      );
      border-radius: 16px;
      border: none;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      transition: all 0.5s ease;
    }

    ha-card:hover {
      transform: scale(1.02);
      box-shadow: 0 6px 16px rgba(0,0,0,0.15);
    }
```

## 🌊 Smooth Animations and Transitions

### CSS Animation Library
Create `config/md3-templates/animations.yaml`:
```yaml
# Global animation styles for MD3 dashboard
md3_animations:
  fade_in: |
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .fade-in {
      animation: fadeIn 0.6s cubic-bezier(0.4, 0.0, 0.2, 1) forwards;
    }

  slide_in_right: |
    @keyframes slideInRight {
      from { transform: translateX(100%); opacity: 0; }
      to { transform: translateX(0); opacity: 1; }
    }
    .slide-in-right {
      animation: slideInRight 0.4s cubic-bezier(0.4, 0.0, 0.2, 1) forwards;
    }

  scale_in: |
    @keyframes scaleIn {
      from { transform: scale(0.8); opacity: 0; }
      to { transform: scale(1); opacity: 1; }
    }
    .scale-in {
      animation: scaleIn 0.3s cubic-bezier(0.4, 0.0, 0.2, 1) forwards;
    }

  pulse: |
    @keyframes pulse {
      0%, 100% { transform: scale(1); }
      50% { transform: scale(1.05); }
    }
    .pulse {
      animation: pulse 2s infinite;
    }
```

### Interactive Card Animations
```yaml
# Enhanced card with MD3 animations
type: custom:mushroom-template-card
entity: climate.ml14xc1
primary: "Climate Control"
secondary: "Touch to adjust settings"
icon: mdi:thermostat
icon_color: primary
card_mod:
  style: |
    /* Base card styling */
    ha-card {
      background: var(--md-sys-color-surface);
      border-radius: var(--tablet-border-radius);
      box-shadow: var(--tablet-elevation-1);
      transition: all 0.3s cubic-bezier(0.4, 0.0, 0.2, 1);
      position: relative;
      overflow: hidden;
    }

    /* Hover effect */
    ha-card:hover {
      transform: translateY(-4px) scale(1.02);
      box-shadow: var(--tablet-elevation-3);
      background: var(--md-sys-color-primary-container);
    }

    ha-card:hover mushroom-shape-icon {
      --shape-color: var(--md-sys-color-primary);
      --icon-color: var(--md-sys-color-on-primary);
    }

    ha-card:hover .primary,
    ha-card:hover .secondary {
      color: var(--md-sys-color-on-primary-container);
    }

    /* Active/pressed state */
    ha-card:active {
      transform: translateY(-2px) scale(1.01);
      box-shadow: var(--tablet-elevation-2);
      transition: all 0.1s ease;
    }

    /* Loading animation */
    ha-card.loading {
      animation: pulse 1.5s infinite;
    }

    /* State-based animations */
    {% if is_state('climate.ml14xc1', 'cool') %}
    ha-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 3px;
      background: linear-gradient(90deg,
        transparent 0%,
        var(--climate-cool) 50%,
        transparent 100%);
      animation: loadingSlide 2s linear infinite;
    }

    @keyframes loadingSlide {
      0% { transform: translateX(-100%); }
      100% { transform: translateX(100%); }
    }
    {% endif %}
```

## 📱 Tablet-Optimized Interactions

### Touch-Friendly Buttons
```yaml
# Enhanced touch targets for tablet
type: custom:button-card
template: md3_tablet_button
entity: light.living_room
icon: mdi:lightbulb
size: 60px
styles:
  card:
    - width: 80px
    - height: 80px
    - border-radius: 16px
    - box-shadow: var(--tablet-elevation-1)
    - transition: all 0.3s cubic-bezier(0.4, 0.0, 0.2, 1)
    - background: var(--md-sys-color-surface)
  icon:
    - width: 40px
    - height: 40px
  name:
    - font-size: 12px
    - font-weight: 500
    - text-align: center
    - margin-top: 8px
  state:
    - font-size: 10px
    - font-weight: 400
    - text-align: center
```

### Swipe Navigation Enhancement
```yaml
# Enhanced navigation with swipe gestures
type: custom:layout-card
layout_type: custom:grid-layout
layout:
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr))
  grid-gap: 16px
  margin: 16px
cards:
  - type: custom:mushroom-chips-card
    alignment: center
    chips:
      - type: template
        icon: mdi:gesture-swipe-horizontal
        content: "Swipe to navigate"
        card_mod:
          style: |
            ha-card {
              background: rgba(103, 80, 164, 0.1);
              border-radius: 20px;
              padding: 8px 16px;
              font-size: 12px;
              animation: fadeInUp 0.6s ease-out;
            }

            @keyframes fadeInUp {
              from {
                opacity: 0;
                transform: translateY(20px);
              }
              to {
                opacity: 1;
                transform: translateY(0);
              }
            }
```

## 🎨 Gulf Coast Theme Integration

### Climate-Specific Color Coding
```yaml
# Temperature-based color theming
type: custom:mushroom-template-card
entity: sensor.average_house_temperature_enhanced_15_sensor
primary: "House Temperature"
secondary: "{{ states(entity) }}°F"
icon: mdi:thermostat
icon_color: |
  {% set temp = states(entity) | float %}
  {% if temp >= 78 %} red          # Too hot - Gulf Coast summer
  {% elif temp >= 74 %} orange     # Warm - target range high
  {% elif temp >= 70 %} green      # Comfortable - ideal range
  {% elif temp >= 66 %} blue       # Cool - target range low
  {% else %} indigo               # Too cold
  {% endif %}
card_mod:
  style: |
    ha-card {
      background: linear-gradient(135deg,
        rgba(
          {% if states(entity) | float >= 78 %} 244, 67, 54
          {% elif states(entity) | float >= 74 %} 255, 152, 0
          {% elif states(entity) | float >= 70 %} 76, 175, 80
          {% elif states(entity) | float >= 66 %} 33, 150, 243
          {% else %} 63, 81, 181
          {% endif %}, 0.1
        ),
        rgba(
          {% if states(entity) | float >= 78 %} 244, 67, 54
          {% elif states(entity) | float >= 74 %} 255, 152, 0
          {% elif states(entity) | float >= 70 %} 76, 175, 80
          {% elif states(entity) | float >= 66 %} 33, 150, 243
          {% else %} 63, 81, 181
          {% endif %}, 0.05
        )
      );
      border-left: 4px solid
      {% if states(entity) | float >= 78 %} #F44336
      {% elif states(entity) | float >= 74 %} #FF9800
      {% elif states(entity) | float >= 70 %} #4CAF50
      {% elif states(entity) | float >= 66 %} #2196F3
      {% else %} #3F51B5
      {% endif %};
    }
```

## ✅ Phase 3 Verification

### MD3 Compliance Testing
- [ ] Color system follows Material Design 3 guidelines
- [ ] Typography uses MD3 type scale
- [ ] Elevation shadows are correctly implemented
- [ ] Border radius matches MD3 standards (16px)
- [ ] State colors are accessible and consistent

### Animation Performance
- [ ] Animations are smooth (60fps)
- [ ] Loading times remain under 2 seconds
- [ ] Touch interactions are responsive
- [ ] No visual glitches or jank

### Tablet Optimization
- [ ] Touch targets meet minimum size (48px)
- [ ] Swipe gestures work smoothly
- [ ] Responsive layouts adapt properly
- [ ] Text is readable without zooming

## 🚀 Next Steps

Proceed to [Phase 4: Gulf Coast Climate Integration](04-climate-integration.md) where we'll:
- Integrate 18-sensor climate network
- Create advanced dew point monitoring
- Implement equipment arbitration controls
- Add Gulf Coast-specific features

---

**Phase 3 Complete**: Material Design 3 implementation with dynamic theming, smooth animations, and tablet-optimized interactions ready for climate integration.