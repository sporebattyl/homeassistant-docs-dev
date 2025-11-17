# Gulf Coast Calendar Integration Documentation

## Overview

This document describes the enhanced calendar implementation for Drew's Gulf Coast Home Assistant setup, inspired by the Material Design 3 Dynamic Tablet Dashboard reference repository.

## Calendar Components

### Primary Calendar Card
- **Component**: `calendar-card-pro` by Alexpfau
- **Repository**: https://github.com/alexpfau/calendar-card-pro
- **Features**:
  - Material Design 3 compatibility
  - Multi-calendar support
  - Weather integration
  - Performance optimized with smart caching
  - Theme-aware styling

### Available Calendars
- `calendar.family` - Main family calendar
- `calendar.dmjtx5_gmail_com` - Personal Gmail calendar
- `calendar.cassandrew` - Work calendar
- `calendar.holidays_in_united_states` - US holidays
- `calendar.birthdays` - Birthday notifications

## Gulf Coast-Specific Features

### Weather-Aware Scheduling
The calendar integration provides intelligent scheduling recommendations based on Gulf Coast weather patterns:

#### Temperature-Based Recommendations
- **Extreme Heat (>90°F)**: Pre-cooling before peak hours, indoor activities preferred
- **Hot Days (85-90°F)**: Plan indoor activities, schedule outdoor events for morning/evening
- **Warm Days (75-85°F)**: Optimal for outdoor activities
- **Mild Days (<75°F)**: Comfortable for any activity

#### Humidity Integration
- **Very High Humidity (>80%)**: Limit outdoor exertion
- **High Humidity (70-80%)**: Stay hydrated, plan indoor backup activities
- **Dew Point Analysis**: Enhanced dehumidification recommendations

#### Energy Optimization
- **Peak Hours**: 2:00 PM - 7:00 PM (avoid heavy appliance use)
- **Pre-cooling**: 1:00 PM - 2:00 PM before peak heat
- **Low Humidity Windows**: Optimized outdoor activity timing

### Climate-Aware Automations

#### Pre-cooling Automation
- **Trigger**: Calendar events starting within 2 hours
- **Condition**: Temperature >85°F and home mode active
- **Action**: Pre-cool home to 72°F, send mobile notification

#### High Humidity Event Warnings
- **Trigger**: Calendar events starting within 6 hours
- **Condition**: Humidity >75%
- **Action**: Send humidity alert with indoor activity recommendations

### Seasonal Maintenance Calendar

#### Summer (May-September)
- Monthly HVAC filter changes
- Dehumidifier drainage checks
- Mold/mildew monitoring
- Cooling schedule optimization

#### Hurricane Season (June-November)
- Monthly emergency supply checks
- Backup power system testing
- Evacuation route review
- Outdoor equipment securing

#### Spring (March-May)
- HVAC system tune-up
- Dehumidifier coil cleaning
- Humidity sensor calibration
- Summer preparation

#### Fall (October-December)
- HVAC winter preparation
- Drainage system cleaning
- Annual system inspection
- Humidity control reduction

## Dashboard Integration

### Main Climate Dashboard (`gulf-coast-climate-optimized.yaml`)
- **Smart Scheduling Section**: Shows optimal outdoor times and energy windows
- **Today's Schedule**: Quick view of family calendar events
- **Gulf Coast Planning**: Real-time weather-based recommendations
- **Quick Event Creation**: Fast event scheduling with weather context

### Dedicated Calendar Dashboard (`gulf-coast-calendar-enhanced.yaml`)
- **Multi-calendar View**: Full calendar integration with weather context
- **Climate-Optimized Schedule**: 3-day weather-aware planning
- **Maintenance Calendar**: Gulf Coast-specific maintenance reminders
- **Event Management**: Quick event creation with weather integration

## Configuration Files

### Packages
- `packages/gulf_coast_calendar_integrations.yaml` - Main calendar integration package

### Dashboards
- `dashboards/gulf-coast-calendar-enhanced.yaml` - Dedicated calendar dashboard
- `dashboards/gulf-coast-climate-optimized.yaml` - Climate dashboard with calendar integration

### Input Entities
- `input_text.gulf_coast_event_title` - Event title input
- `input_datetime.gulf_coast_event_time` - Event time/date picker
- `select.gulf_coast_event_calendar` - Calendar selection dropdown
- `input_boolean.gulf_coast_event_create` - Event creation trigger

### Template Sensors
- `sensor.optimal_outdoor_hours` - Best outdoor activity times
- `sensor.peak_energy_hours` - Peak energy consumption window
- `sensor.humidity_optimal_window` - Low humidity activity periods

## Scripts and Automations

### Event Creation Script
- **Name**: `create_gulf_coast_calendar_event`
- **Function**: Creates calendar events with weather context and energy tips
- **Calendars**: Supports family, personal, work, and maintenance calendars

### Climate Automations
- **Pre-cooling**: `calendar_precool_before_events`
- **Humidity Warnings**: `calendar_humidity_event_warning`
- **Seasonal Maintenance**: `calendar_seasonal_maintenance`

## Mobile Integration

### Notifications
- Pre-cooling alerts for hot weather events
- High humidity warnings
- Seasonal maintenance reminders
- Energy optimization tips

### Weather Context
- Real-time temperature and humidity data
- Dew point analysis
- Precipitation probability
- Energy efficiency recommendations

## Material Design 3 Styling

### Color Scheme
- **Primary**: Blue tones for temperature control
- **Secondary**: Teal for humidity features
- **Accent**: Orange for energy management
- **Warning**: Red for emergency controls

### Card Styling
- Backdrop blur effects for modern appearance
- Rounded corners (12-16px radius)
- Semi-transparent backgrounds with border accents
- Smooth transitions and hover effects

## Usage Instructions

### Creating Weather-Aware Events
1. Navigate to Gulf Coast Climate Control Center
2. Use the "Quick Event" section in the calendar integration
3. Enter event title and time
4. Select target calendar
5. Click "Create Event" - weather context automatically added

### Viewing Scheduling Recommendations
1. Check "Smart Scheduling Integration" in main climate dashboard
2. Review optimal outdoor times based on current conditions
3. Plan activities around peak energy hours (2-7 PM)
4. Monitor humidity windows for comfort optimization

### Seasonal Maintenance
1. Automated monthly reminders during peak seasons
2. Hurricane preparedness checks (June-November)
3. HVAC maintenance scheduling (May-September)
4. Winter preparation (October-December)

## Troubleshooting

### Common Issues
- **Calendar Not Loading**: Check Home Assistant calendar integrations
- **Weather Data Missing**: Verify weather forecast integration
- **Automations Not Triggering**: Ensure calendar entity IDs are correct

### Entity Validation
```bash
# Check calendar entities
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states" | jq '.[] | select(.entity_id | contains("calendar"))'

# Check weather data
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/weather.forecast_home"
```

### Maintenance
- Update calendar card pro to latest version
- Review seasonal automations quarterly
- Verify weather integration during season changes
- Test mobile notification delivery

## Future Enhancements

### Planned Features
- Weather forecast integration beyond current conditions
- Historical weather analysis for event planning
- Integration with Gulf Coast specific weather alerts
- Enhanced energy consumption tracking
- Voice assistant integration for event creation

### Optimization Opportunities
- Machine learning for personalized schedule recommendations
- Integration with local event calendars
- Traffic-aware travel time planning
- Social calendar sharing capabilities