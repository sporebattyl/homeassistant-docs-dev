# GEMINI.md

## Directory Overview

This directory contains a comprehensive and advanced configuration for a Home Assistant instance. It is designed to manage a smart home with a focus on sophisticated automation, security, and energy efficiency. The configuration is highly customized and modular, with a clear separation of concerns between different components of the system. This configuration is for a single home power user in the League City, TX Gulf Coast climate.

## System Overview
- **Version**: Home Assistant 2025.9.1
- **Physical**: 2,386 sq ft home, Lennox ML14XC1 AC + Aprilaire E130 dehumidifier
- **Climate Control**: 18 ZG-227Z temperature/humidity sensors.
- **Architecture**: KISS principles - single home power user, avoid enterprise complexity.

## Key Files and Directories

*   **`configuration.yaml`**: The main entry point for the Home Assistant configuration. It includes other configuration files and defines the core settings.
*   **`packages/`**: This directory contains groups of configurations that are bundled together to provide a specific feature. This is the primary method for organizing complex domain logic. The climate control system is a major part of this, with 7 active climate packages.
*   **`custom_components/`**: This directory contains custom components that are not part of the standard Home Assistant distribution. These components extend the functionality of Home Assistant to support additional devices and services.
*   **`customization/`**: This directory holds customizations for various Home Assistant entities. This includes things like device names, icons, and other attributes, grouped by domain.
*   **`development/`**: Contains related development projects, like `ai-room-cleaner` and `homeassistant-mcp`.
*   **`zigbee2mqtt/`**: Configuration for the Zigbee2MQTT bridge.

## Architecture Overview

### Configuration Structure
- **Main config**: `configuration.yaml` - Uses include directives.
- **Packages**: `/packages/*.yaml` - Primary organization (KISS approach).
- **Climate System**: 7 active climate packages (~6,287 lines total), with `climate_fresh_start.yaml` being the primary modern package.

### Key Integrations
- **AI Room Cleaner**: `development/ai-room-cleaner/` (FastAPI + JS frontend)
- **Vacuum Automation**: Dreame L10s Ultra with 22 room segments
- **MCP Server**: TypeScript/Node.js bridge to Home Assistant
- **Zigbee2MQTT**: `/zigbee2mqtt/configuration.yaml`

## Climate System

The climate control system is a core feature of this configuration, designed for the Gulf Coast climate.

### Overview
- **Hardware**: Lennox ML14XC1 AC and Aprilaire E130 dehumidifier.
- **Sensors**: 18 ZG-227Z temperature/humidity sensors.
- **Control Strategy**: Currently uses a 60% humidity ceiling, with a planned transition to dew point-based control.
- **Features**: Equipment arbitration to prevent conflicts, emergency protocols, and detailed energy management.

### Package Structure
The climate logic is split across 7 packages, with a plan to consolidate them.
- **`climate_fresh_start.yaml`**: The primary, modern package for dew point-first control.
- **`climate_emergency_dashboard_support.yaml`**: A legacy package to be archived.
- Other packages for dashboard enhancements, energy management, UI, and interface management.

### Consolidation Plan
A detailed, 11-phase plan exists to consolidate the climate logic into `climate_fresh_start.yaml`. This plan is documented in `/home/drewcifer/homeassistant-config/consolidation_phases_2025_10_17/`. The plan is not yet executed.

## Development

### Essential Commands
- **Check configuration**: `hass --config /home/drewcifer/mnt/homeassistant-config --check-config`
- **Restart Home Assistant**: `curl -X POST -H "Authorization: Bearer <YOUR_TOKEN>" -H "Content-Type: application/json" http://192.168.88.125:8123/api/services/homeassistant/restart`
- **View logs**: `tail -f /home/drewcifer/mnt/homeassistant-config/home-assistant.log`

### Development Patterns
- **Packages pattern**: Primary method for complex domain logic.
- **KISS Feature Flag Pattern**: Use `input_boolean` to toggle features.

### Configuration Validation
Always validate before restarting:
1.  `hass --config . --check-config`
2.  Template syntax in Developer Tools > Template
3.  Package validation for include directives

## Usage

This directory is the live configuration for a Home Assistant instance. To use it, you would typically:

1.  Install Home Assistant on a dedicated device.
2.  Clone this repository to the Home Assistant configuration directory.
3.  Create a `secrets.yaml` file to store sensitive information like passwords and API keys. See `README_SECRETS.md` for more information.
4.  Restart Home Assistant to apply the new configuration.

To adapt this configuration for a different home, you would need to:
*   Modify the `configuration.yaml` file to match your hardware.
*   Update the entity IDs in the automation and script files to match your devices.
*   Adjust the room layouts and other settings in the various configuration files.
