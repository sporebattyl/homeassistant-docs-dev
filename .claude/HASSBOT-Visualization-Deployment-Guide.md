# HASSBOT Visualization Agent - Deployment Guide

## Overview

The HASSBOT Visualization Agent creates a comprehensive 4-dashboard hierarchy in Grafana with seamless Home Assistant integration, providing actionable insights for climate optimization and predictive maintenance.

## Dashboard Inventory

### 1. Home Overview Dashboard (`grafana-home-overview-dashboard.json`)
- **Purpose**: Real-time status of all 9 rooms and system overview
- **Key Features**:
  - Current house status (temp/humidity)
  - Room-by-room temperature and humidity bar gauges
  - HVAC system status
  - Energy consumption summary
  - System health indicators
  - 24-hour temperature trends

### 2. Climate Deep Dive Dashboard (`grafana-climate-deep-dive-dashboard.json`)
- **Purpose**: Detailed climate analysis across all 27 temperature sensors
- **Key Features**:
  - All temperature sensors real-time tracking
  - Temperature distribution heatmap
  - Humidity analysis with outdoor correlation
  - HVAC performance analysis with cooling/heating indicators
  - Room-by-room climate control table
  - Temperature variance analysis

### 3. Energy Management Dashboard (`grafana-energy-management-dashboard.json`)
- **Purpose**: Energy optimization and cost analysis
- **Key Features**:
  - Real-time power consumption monitoring
  - Climate system energy breakdown pie chart
  - Daily energy cost tracking
  - 24-hour consumption trends
  - Energy efficiency metrics
  - Individual component power tracking
  - Optimization recommendations

### 4. System Health Dashboard (`grafana-system-health-dashboard.json`)
- **Purpose**: Equipment monitoring and maintenance tracking
- **Key Features**:
  - System overview status
  - HVAC and dehumidifier health monitoring
  - Fan system performance table
  - Equipment temperature monitoring
  - Home Assistant core system health
  - Maintenance tracking and alerts
  - Performance trends over time

## Sensor Inventory (78+ Sensors Discovered)

### Temperature Sensors (27 total)
- **Aqara Room Sensors (9)**: Living Room, Kitchen, Guest Bedroom, Rowan's Room, Guest Bathroom, Master Bathroom, Master Bedroom, Laundry, Office
- **Thermostat Sensors (3)**: Current, Raw, Target readings
- **Equipment Sensors (5)**: Dehumidifier relay, Motion sensors, Water heater area
- **Calculated Sensors (10)**: House average, weighted, fan targets, pool/spa temps

### Humidity Sensors (15 total)
- **Room Sensors (9)**: All Aqara sensors provide humidity
- **Calculated Averages (3)**: House, weighted, outdoor
- **Thermostat Readings (3)**: Current, raw, system readings

### Climate Systems (3 total)
- **Main HVAC**: Thermostat with cooling/heating/auto modes
- **Pool Heat System**: Temperature control for pool
- **Spa Heat System**: Separate spa heating control

### Energy Monitoring (12 total)
- **Climate System Energy**: Total usage breakdown
- **Component Energy**: HVAC, dehumidifier, fans daily consumption
- **Device Power**: Individual smart outlets and switches
- **Cost Analytics**: Monthly projections and efficiency scores

### System Health (21 total)
- **Performance Scores**: Climate system, maintenance, efficiency
- **Equipment Health**: HVAC, dehumidifier, fan system status
- **Core System**: Home Assistant CPU, memory, uptime monitoring
- **Notification System**: Alert throttling and status tracking

## Deployment Steps

### Step 1: Configure InfluxDB Data Source

1. Access Grafana at `http://192.168.88.125:3000`
2. Go to Configuration > Data Sources > Add data source
3. Select InfluxDB
4. Import configuration from `grafana-influxdb-datasource-config.json`:
   ```json
   {
     "name": "InfluxDB-HASSBOT",
     "url": "http://localhost:8086",
     "database": "homeassistant",
     "user": "homeassistant"
   }
   ```
5. Test the connection to ensure InfluxDB add-on is accessible

### Step 2: Import Dashboard Configurations

Import each dashboard JSON file via Grafana UI:
1. Go to Dashboards > Import
2. Upload JSON file or copy/paste content
3. Configure data source mapping to "InfluxDB-HASSBOT"
4. Import in this order:
   - `grafana-home-overview-dashboard.json`
   - `grafana-climate-deep-dive-dashboard.json`
   - `grafana-energy-management-dashboard.json`
   - `grafana-system-health-dashboard.json`

### Step 3: Set Up Home Assistant Panel iFrame Integration

1. Edit your Home Assistant `configuration.yaml`
2. Add the panel_iframe configuration from `homeassistant-panel-iframe-config.yaml`:
   ```yaml
   panel_iframe:
     hassbot_overview:
       title: "HASSBOT Overview"
       icon: mdi:home-analytics
       url: "http://192.168.88.125:3000/d/home-overview/hassbot-home-overview"
       require_admin: false
   ```
3. Restart Home Assistant
4. Navigate to sidebar to see new HASSBOT dashboard panels

### Step 4: Configure Alerts and Notifications

1. In Grafana, go to Alerting > Notification channels
2. Import notification configurations from `grafana-alerts-config.json`
3. Update Home Assistant webhook URL and authentication token
4. Configure email settings for backup notifications
5. Import alert rules for critical thresholds:
   - High temperature alerts (>80°F)
   - HVAC performance degradation (<30%)
   - High energy consumption (>5 kWh)
   - Equipment overheating (>115°F)
   - Humidity out of range (<35% or >60%)
   - System uptime issues (<98%)
   - Maintenance score alerts (<50%)

### Step 5: Verification and Testing

1. **Data Flow Verification**:
   - Confirm sensor data is flowing from Home Assistant to InfluxDB
   - Check that all 78+ sensors are being logged
   - Verify time-series data is accumulating

2. **Dashboard Functionality**:
   - Test all dashboard panels load correctly
   - Verify real-time data updates
   - Check inter-dashboard navigation links work

3. **Alert Testing**:
   - Trigger test alerts to verify notification delivery
   - Confirm Home Assistant receives webhook notifications
   - Test email delivery if configured

4. **iFrame Integration**:
   - Verify dashboards load within Home Assistant UI
   - Test responsive design on different screen sizes
   - Confirm authentication passes through correctly

## Key Features Implemented

### Environmental Monitoring
- **Room-Level Granularity**: All 9 rooms monitored individually
- **Comprehensive Coverage**: 27 temperature + 15 humidity sensors
- **Trend Analysis**: Historical data with configurable time ranges
- **Variance Detection**: Temperature spread and deviation tracking

### Climate Optimization
- **HVAC Performance Tracking**: Efficiency scoring and correlation analysis
- **Target vs Actual Analysis**: Temperature control effectiveness
- **Multi-Zone Management**: Individual room climate control
- **Predictive Insights**: Performance degradation early warning

### Energy Management
- **Component-Level Tracking**: HVAC, dehumidifier, fans separated
- **Cost Analysis**: Real-time and projected monthly costs
- **Efficiency Scoring**: Performance optimization recommendations
- **Power Monitoring**: Individual device consumption tracking

### Predictive Maintenance
- **Health Scoring**: Comprehensive system performance metrics
- **Equipment Temperature Monitoring**: Overheating detection
- **Maintenance Scheduling**: Score-based recommendations
- **Alert Integration**: Proactive notification system

## Troubleshooting

### Common Issues

1. **Data Not Appearing**:
   - Verify InfluxDB add-on is running and configured
   - Check Home Assistant recorder configuration includes all entities
   - Confirm data source connection in Grafana

2. **Dashboard Import Errors**:
   - Ensure data source name matches exactly
   - Check sensor entity names haven't changed
   - Verify JSON syntax is valid

3. **iFrame Not Loading**:
   - Check Grafana allow_embedding setting
   - Verify Home Assistant can reach Grafana URL
   - Confirm panel_iframe syntax in configuration.yaml

4. **Alerts Not Firing**:
   - Verify alert rule queries return data
   - Check notification channel configuration
   - Test webhook endpoint accessibility

### Performance Optimization

- Set appropriate refresh intervals (30s-2m depending on dashboard)
- Use time range templates for better query performance
- Configure retention policies in InfluxDB for long-term storage
- Monitor Grafana resource usage with 78+ sensors

## Security Considerations

- Use Home Assistant long-lived tokens for API access
- Configure Grafana authentication integration
- Set appropriate admin permissions for sensitive dashboards
- Enable HTTPS for production deployments
- Regular backup of dashboard configurations

## Future Enhancements

- **Mobile Optimization**: Responsive dashboard layouts
- **Machine Learning Integration**: Predictive failure analysis
- **Automated Reporting**: Scheduled email summaries
- **Advanced Analytics**: Correlation analysis between sensors
- **Custom Notifications**: Context-aware alert messages

## Support and Maintenance

- Dashboard configurations are version-controlled in `.claude` directory
- Regular backup of Grafana dashboard exports recommended
- Monitor sensor availability and add new devices as needed
- Update alert thresholds based on seasonal patterns
- Review and optimize queries for performance as data grows

---

**Deployment Status**: Ready for production use
**Total Sensors Monitored**: 78+
**Dashboard Count**: 4 comprehensive dashboards
**Alert Rules**: 7 critical monitoring rules
**Integration**: Seamless Home Assistant UI integration