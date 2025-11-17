#!/bin/bash

# Gulf Coast Unified Dashboard Validation Script
# Validates all components and integrations for the unified dashboard

set -e

echo "🏠 Gulf Coast Unified Dashboard Validation"
echo "=========================================="
echo

# Configuration
HA_BASE_URL="http://192.168.88.125:8123"
HA_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI0MTZkMzliN2NmM2E0YTkyYjBiMzc3MmYyZWIyNGVhNyIsImlhdCI6MTc1Njg3Mjc1NiwiZXhwIjoyMDcyMjMyNzU2fQ.fWYMFxpMks3KX1Qw0ogYxECnrdaSrqBkZHxAUPa-IYY"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validation functions
validate_entity() {
    local entity_id="$1"
    local description="$2"

    echo -n "  Checking $description... "

    if curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE_URL/api/states/$entity_id" | jq -e '.entity_id' > /dev/null 2>&1; then
        echo -e "${GREEN}✅ OK${NC}"
        return 0
    else
        echo -e "${RED}❌ MISSING${NC}"
        echo -e "    Entity '$entity_id' not found"
        return 1
    fi
}

validate_calendar() {
    local entity_id="$1"
    local description="$2"

    echo -n "  Checking $description... "

    if curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE_URL/api/states/$entity_id" | jq -e '.attributes.friendly_name' > /dev/null 2>&1; then
        echo -e "${GREEN}✅ OK${NC}"
        return 0
    else
        echo -e "${RED}❌ MISSING${NC}"
        echo -e "    Calendar '$entity_id' not found"
        return 1
    fi
}

echo "📋 Step 1: Validating Required Files"
echo "-------------------------------------"

# Check main dashboard file
if [ -f "dashboards/gulf-coast-unified-v4.yaml" ]; then
    echo -e "${GREEN}✅ Main dashboard file exists${NC}"
else
    echo -e "${RED}❌ Main dashboard file missing${NC}"
    exit 1
fi

# Check control package file
if [ -f "packages/dashboard_controls.yaml" ]; then
    echo -e "${GREEN}✅ Dashboard controls package exists${NC}"
else
    echo -e "${RED}❌ Dashboard controls package missing${NC}"
    exit 1
fi

echo
echo "🔍 Step 2: Validating YAML Syntax"
echo "---------------------------------"

# Check YAML syntax
echo "  Checking main dashboard YAML syntax..."
if yamllint dashboards/gulf-coast-unified-v4.yaml > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Main dashboard YAML valid${NC}"
else
    echo -e "${RED}❌ Main dashboard YAML errors:${NC}"
    yamllint dashboards/gulf-coast-unified-v4.yaml | head -3
fi

echo "  Checking controls package YAML syntax..."
if yamllint packages/dashboard_controls.yaml > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Controls package YAML valid${NC}"
else
    echo -e "${RED}❌ Controls package YAML errors:${NC}"
    yamllint packages/dashboard_controls.yaml | head -3
fi

echo
echo "🌐 Step 3: Validating Home Assistant Connection"
echo "-------------------------------------------------"

# Test HA connection
echo -n "  Testing Home Assistant connection... "
if curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE_URL/api/" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Connected${NC}"
else
    echo -e "${RED}❌ Connection failed${NC}"
    echo "  Please check Home Assistant is running and token is valid"
    exit 1
fi

echo
echo "🏠 Step 4: Validating Climate Entities"
echo "---------------------------------------"

climate_validations=0
climate_total=5

validate_entity "sensor.average_house_temperature_enhanced_15_sensor" "Average Temperature Sensor" && ((climate_validations++))
validate_entity "sensor.average_house_humidity_enhanced" "Average Humidity Sensor" && ((climate_validations++))
validate_entity "sensor.dew_point_average" "Dew Point Average" && ((climate_validations++))
validate_entity "climate.ml14xc1" "Lennox AC System" && ((climate_validations++))
validate_entity "switch.e130_dehumidifier_control" "Aprilaire Dehumidifier" && ((climate_validations++))

echo -e "Climate entities: ${climate_validations}/${climate_total} valid"

echo
echo "🔒 Step 5: Validating Security Entities"
echo "----------------------------------------"

security_validations=0
security_total=7

validate_entity "person.drews_iphone" "Person Tracking" && ((security_validations++))
validate_entity "binary_sensor.motion_follow_me_focus" "Motion Focus" && ((security_validations++))
validate_entity "camera.front_yard_fluent" "Front Yard Camera" && ((security_validations++))
validate_entity "camera.side_yard_fluent" "Side Yard Camera" && ((security_validations++))
validate_entity "camera.driveway_fluent_lens_0" "Driveway Camera Wide" && ((security_validations++))
validate_entity "cover.garage_door_1" "Garage Door 1" && ((security_validations++))
validate_entity "binary_sensor.living_room_motion_enhanced" "Living Room Motion" && ((security_validations++))

echo -e "Security entities: ${security_validations}/${security_total} valid"

echo
echo "🎵 Step 6: Validating Media Entities"
echo "--------------------------------------"

media_validations=0
media_total=6

validate_entity "media_player.living_room_1" "Den Sonos" && ((media_validations++))
validate_entity "media_player.kitchen" "Kitchen AirPlay" && ((media_validations++))
validate_entity "media_player.bedroom_homepod" "Bedroom HomePod" && ((media_validations++))
validate_entity "media_player.75_the_frame_2" "The Frame TV" && ((media_validations++))
validate_entity "switch.sonos_alarm_1" "Sonos Alarm" && ((media_validations++))
validate_entity "input_number.sonos_den_volume" "Den Sonos Volume" && ((media_validations++))

echo -e "Media entities: ${media_validations}/${media_total} valid"

echo
echo "⚙️ Step 7: Validating System Entities"
echo "--------------------------------------"

system_validations=0
system_total=4

validate_entity "sensor.home_assistant_v2_db_size" "Database Size" && ((system_validations++))
validate_entity "sensor.processor_use" "CPU Usage" && ((system_validations++))
validate_entity "sensor.memory_use_percent" "Memory Usage" && ((system_validations++))
validate_entity "sensor.home_assistant_uptime" "System Uptime" && ((system_validations++))

echo -e "System entities: ${system_validations}/${system_total} valid"

echo
echo "📊 Step 8: Validating Energy Entities"
echo "--------------------------------------"

energy_validations=0
energy_total=6

validate_entity "sensor.energy_cost_daily_projection" "Daily Cost Projection" && ((energy_validations++))
validate_entity "sensor.energy_savings_estimate" "Daily Savings" && ((energy_validations++))
validate_entity "sensor.energy_efficiency_percentage" "Energy Efficiency" && ((energy_validations++))
validate_entity "sensor.energy_aware_hvac_efficiency" "HVAC Efficiency" && ((energy_validations++))
validate_entity "sensor.energy_efficiency_percentage_7d_mean" "7-Day Efficiency" && ((energy_validations++))
validate_entity "sensor.energy_savings_annual_progress" "Annual Progress" && ((energy_validations++))

echo -e "Energy entities: ${energy_validations}/${energy_total} valid"

echo
echo "📅 Step 9: Validating Calendar Integration"
echo "------------------------------------------"

calendar_validations=0
calendar_total=1

validate_calendar "calendar.family" "Family Calendar" && ((calendar_validations++))

echo -e "Calendar entities: ${calendar_validations}/${calendar_total} valid"

echo
echo "🎛️ Step 10: Validating Dashboard Controls"
echo "-----------------------------------------"

control_validations=0
control_total=2

validate_entity "input_select.dashboard_tab" "Dashboard Tab Selector" && ((control_validations++))
validate_entity "input_boolean.gulf_coast_energy_saver" "Gulf Coast Energy Saver" && ((control_validations++))

echo -e "Control entities: ${control_validations}/${control_total} valid"

echo
echo "📋 Step 11: Validating Custom Components"
echo "----------------------------------------"

# Check for custom components
custom_components=(
    "custom:button-card"
    "custom:calendar-card-pro"
    "custom:auto-entities"
    "custom:apexcharts-card"
)

echo "  Checking for required custom components..."
for component in "${custom_components[@]}"; do
    echo -n "    $component: "
    if grep -q "$component" dashboards/gulf-coast-unified-v4.yaml; then
        echo -e "${GREEN}✅ Used${NC}"
    else
        echo -e "${YELLOW}⚠️ Not used${NC}"
    fi
done

echo
echo "📊 VALIDATION SUMMARY"
echo "====================="
echo
echo -e "Climate:      ${climate_validations}/${climate_total} entities"
echo -e "Security:     ${security_validations}/${security_total} entities"
echo -e "Media:        ${media_validations}/${media_total} entities"
echo -e "System:       ${system_validations}/${system_total} entities"
echo -e "Energy:       ${energy_validations}/${energy_total} entities"
echo -e "Calendar:     ${calendar_validations}/${calendar_total} entities"
echo -e "Controls:     ${control_validations}/${control_total} entities"
echo

total_valid=$((climate_validations + security_validations + media_validations + system_validations + energy_validations + calendar_validations + control_validations))
total_possible=$((climate_total + security_total + media_total + system_total + energy_total + calendar_total + control_total))

percentage=$((total_valid * 100 / total_possible))

if [ $percentage -ge 90 ]; then
    echo -e "${GREEN}🎉 EXCELLENT: $total_valid/$total_possible entities validated ($percentage%)${NC}"
    echo -e "${GREEN}✅ Dashboard is ready for deployment!${NC}"
elif [ $percentage -ge 75 ]; then
    echo -e "${YELLOW}⚠️ GOOD: $total_valid/$total_possible entities validated ($percentage%)${NC}"
    echo -e "${YELLOW}⚠️ Dashboard mostly ready, some features may be limited${NC}"
else
    echo -e "${RED}❌ NEEDS WORK: $total_valid/$total_possible entities validated ($percentage%)${NC}"
    echo -e "${RED}❌ Please resolve missing entities before deployment${NC}"
fi

echo
echo "🚀 DEPLOYMENT INSTRUCTIONS"
echo "=========================="
echo "1. Add this to your configuration.yaml:"
echo "   dashboard:"
echo "     title: Gulf Coast Smart Home"
echo "     icon: mdi:home-automation"
echo "     require_admin: false"
echo
echo "2. Ensure these HACS custom components are installed:"
echo "   - Button Card"
echo "   - Calendar Card Pro"
echo "   - ApexCharts Card"
echo
echo "3. Add the dashboard controls package to your configuration"
echo
echo "4. Access the dashboard at: http://192.168.88.125:8123/gulf-coast-unified-v4"
echo

exit 0