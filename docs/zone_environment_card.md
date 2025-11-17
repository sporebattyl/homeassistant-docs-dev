# Zone Environment Card Template

The `zone_environment_card` decluttering template standardizes the cards used in the **Climate Control Center v2** Zones view. It ensures that temperature, humidity, and motion indicators share the same styling, thresholds, and actions.

## Inputs
Each card instance is parameterized through the `variables` list when calling `custom:decluttering-card`:

- `temperature_entity` – primary sensor providing the zone temperature.
- `humidity_entity` – companion humidity sensor for the zone.
- `motion_entity` – binary sensor used to highlight motion activity (optional).
- `name` – friendly label shown in the card header.
- `icon` – Mushroom icon identifier (defaults to `mdi:home-thermometer`).
- `area` – Optional suffix displayed after the name for additional grouping.

## Behaviour & Thresholds
- **Icon colour** reflects temperature comfort bands: blue ≤ 71 °F, green between 72–77 °F, red ≥ 78 °F. Unavailable sensors fall back to grey.
- **Badge** surfaces humidity with gulf coast safety thresholds: blue below 55%, amber 55–59%, red ≥ 60%. The badge text echoes the rounded humidity value or `—` when unavailable.
- **Secondary text** prints the formatted temperature and humidity along with motion status (Active/Idle). Additional warning lines appear when humidity reaches or exceeds the 55% or 60% ceilings.
- **Actions**: tap opens the temperature entity, hold focuses on humidity, and double-tap reveals the associated motion sensor to streamline troubleshooting.

## Example Usage
```yaml
- type: custom:decluttering-card
  template: zone_environment_card
  variables:
    - temperature_entity: sensor.temphumidsensor1_temperature
    - humidity_entity: sensor.temphumidsensor1_humidity
    - motion_entity: binary_sensor.motion_dashboard_living_room
    - name: Living Room
    - icon: mdi:sofa
```

This template keeps the gulf coast humidity ceiling logic and motion highlights consistent across every zone card, making further adjustments a single edit in `ui-lovelace-climate-control-center-v2.yaml`.
