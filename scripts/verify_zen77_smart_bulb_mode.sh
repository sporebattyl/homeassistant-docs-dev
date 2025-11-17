#!/bin/bash
# ZEN77 Smart Bulb Mode Verification Script
# File: /home/drewcifer/homeassistant-config/scripts/verify_zen77_smart_bulb_mode.sh

echo "=== ZEN77 Smart Bulb Mode Verification ==="
echo "Device ID: 7f4707b631beab74c0abd3f829f750d4"
echo "Target Entity: light.kitchen_under_cabinet"
echo ""

# Home Assistant API Configuration
HA_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI0MTZkMzliN2NmM2E0YTkyYjBiMzc3MmYyZWIyNGVhNyIsImlhdCI6MTc1Njg3Mjc1NiwiZXhwIjoyMDcyMjMyNzU2fQ.fWYMFxpMks3KX1Qw0ogYxECnrdaSrqBkZHxAUPa-IYY"
HA_BASE="http://192.168.88.125:8123"

echo "Step 1: Checking ZEN77 device status..."
ZEN77_STATUS=$(curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/light.under_cabinet_lights" | jq -r '.state // "unknown"')
echo "ZEN77 Status: $ZEN77_STATUS"

echo ""
echo "Step 2: Checking target smart LED strips status..."
LED_STATUS=$(curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/light.kitchen_under_cabinet" | jq -r '.state // "unknown"')
echo "LED Strips Status: $LED_STATUS"

echo ""
echo "Step 3: Checking automation status..."
AUTOMATION_STATUS=$(curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/automation.zen77_smart_bulb_mode_under_cabinet" | jq -r '.state // "unknown"')
echo "Automation Status: $AUTOMATION_STATUS"

echo ""
echo "=== Verification Steps Required ==="
echo "1. Physical Test:"
echo "   - Press ZEN77 up paddle once → LED strips should toggle"
echo "   - Press ZEN77 down paddle once → LED strips should toggle"
echo "   - Hold up paddle → LED strips should brighten smoothly"
echo "   - Hold down paddle → LED strips should dim smoothly"
echo "   - Double press up → LED strips should go to 100%"
echo "   - Double press down → LED strips should go to 20% warm white"
echo ""

echo "2. Smart Bulb Mode Verification:"
echo "   - LED strips should NEVER lose power (no flicker when pressing ZEN77)"
echo "   - ZEN77 should act only as scene controller"
echo "   - Physical load should remain ON continuously"
echo ""

echo "3. Check Home Assistant Logs:"
echo "   - Look for 'ZEN77 Smart Bulb Debug' log entries"
echo "   - Verify zwave_js_value_notification events are being received"
echo ""

echo "4. Z-Wave Node Configuration Check:"
echo "   Go to Settings → Devices & Services → Z-Wave JS → Configure"
echo "   Verify these parameters are set:"
echo "   - Parameter 15 (Load Control): Value = 2 (Smart Bulb Mode)"
echo "   - Parameter 20 (Multilevel Reports): Value = 0"
echo "   - Parameter 16 (Dimming Speed): Value = 3 (or preference)"
echo ""

echo "=== Troubleshooting Commands ==="
echo "Monitor Z-Wave events:"
echo "curl -H \"Authorization: Bearer \$HA_TOKEN\" \"\$HA_BASE/api/events\" | jq 'select(.event_type == \"zwave_js_value_notification\")'"
echo ""
echo "Check device info:"
echo "curl -H \"Authorization: Bearer \$HA_TOKEN\" \"\$HA_BASE/api/states/light.under_cabinet_lights\""
echo ""

echo "=== Next Steps ==="
echo "1. Set ZEN77 parameters in Z-Wave JS configuration"
echo "2. Replace old automation with new optimized version"
echo "3. Test all button press combinations"
echo "4. Verify continuous power to LED strips"
echo "5. Monitor logs for proper event handling"