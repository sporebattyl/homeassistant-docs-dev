#!/bin/bash
# Phase 6C Final Validation Script
# Automated validation for Material Design 3 dashboard micro-interactions

echo "=== Phase 6C Final Validation ==="
echo ""

# Set up environment
HA_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI0MTZkMzliN2NmM2E0YTkyYjBiMzc3MmYyZWIyNGVhNyIsImlhdCI6MTc1Njg3Mjc1NiwiZXhwIjoyMDcyMjMyNzU2fQ.fWYMFxpMks3KX1Qw0ogYxECnrdaSrqBkZHxAUPa-IYY"
HA_BASE="http://192.168.88.125:8123"

# Navigate to project root
cd "$(dirname "$0")/.." || exit 1

# 1. File integrity
echo "1. Dashboard file integrity..."
if [ -f "ui-lovelace-climate-md3.yaml" ]; then
  LINES=$(wc -l < ui-lovelace-climate-md3.yaml)
  SIZE=$(ls -lh ui-lovelace-climate-md3.yaml | awk '{print $5}')
  echo "   ✓ File exists: $LINES lines, $SIZE"
else
  echo "   ✗ File not found"
  exit 1
fi

# 2. Animation counts
echo "2. Animation counts..."
PULSE_COUNT=$(grep -c "@keyframes pulse" ui-lovelace-climate-md3.yaml 2>/dev/null || echo 0)
FADE_COUNT=$(grep -c "@keyframes fadeInUp" ui-lovelace-climate-md3.yaml 2>/dev/null || echo 0)
REDUCED_MOTION=$(grep -c "@media (prefers-reduced-motion: reduce)" ui-lovelace-climate-md3.yaml 2>/dev/null || echo 0)

echo "   Pulse animations: $PULSE_COUNT (expected: 6)"
echo "   Entrance animations: $FADE_COUNT (expected: 31)"
echo "   Reduced motion queries: $REDUCED_MOTION (expected: 37)"

# 3. GPU-accelerated property check
echo "3. GPU-accelerated property validation..."
GPU_PROPS=$(grep -A 10 "@keyframes" ui-lovelace-climate-md3.yaml | grep -c -E "(transform|opacity)")
BAD_PROPS=$(grep -A 10 "@keyframes" ui-lovelace-climate-md3.yaml | grep -c -E "(width|height|top|left|margin|padding)" || echo 0)

echo "   GPU properties (transform/opacity): $GPU_PROPS"
echo "   Non-GPU properties (should be 0): $BAD_PROPS"

if [ "$BAD_PROPS" -eq 0 ]; then
  echo "   ✓ All animations GPU-accelerated"
else
  echo "   ⚠ Warning: Non-GPU properties detected"
fi

# 4. YAML syntax
echo "4. YAML syntax validation..."
if command -v yamllint >/dev/null 2>&1; then
  yamllint ui-lovelace-climate-md3.yaml 2>&1 | grep -q "error"
  if [ $? -eq 1 ]; then
    echo "   ✓ YAML syntax valid"
  else
    echo "   ✗ YAML syntax errors found"
    yamllint ui-lovelace-climate-md3.yaml | head -20
  fi
else
  echo "   ⚠ yamllint not installed, skipping"
fi

# 5. Home Assistant health
echo "5. Home Assistant API health..."
HA_STATUS=$(curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/" 2>/dev/null | jq -r '.message' 2>/dev/null || echo "ERROR")

if [ "$HA_STATUS" = "API running." ]; then
  echo "   ✓ HA API healthy"
else
  echo "   ✗ HA API error: $HA_STATUS"
fi

# 6. Equipment states (for pulse testing)
echo "6. Equipment states (for pulse animations)..."
AC_STATE=$(curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/binary_sensor.thermostat_cooling_action" 2>/dev/null | jq -r '.state' 2>/dev/null || echo "unknown")
DEHUM_STATE=$(curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE/api/states/switch.dehumidifier_outlet_switch" 2>/dev/null | jq -r '.state' 2>/dev/null || echo "unknown")

echo "   AC cooling: $AC_STATE (pulse if 'on')"
echo "   Dehumidifier: $DEHUM_STATE (pulse if 'on')"

# 7. Git state
echo "7. Git commit status..."
git log --oneline -1 | grep -q "Phase 6C"
if [ $? -eq 0 ]; then
  echo "   ✓ Phase 6C commit found"
  git log --oneline -1
else
  echo "   ✗ Phase 6C commit not found"
  echo "   Latest commit:"
  git log --oneline -1
fi

# 8. Animation timing analysis
echo "8. Animation timing validation..."
echo "   Extracting animation durations..."
grep -oP "animation:.*?\d+\.?\d*s" ui-lovelace-climate-md3.yaml 2>/dev/null | head -10 || echo "   (Unable to extract durations)"

echo ""
echo "=== Pre-validation Complete ==="
echo ""
echo "Summary:"
echo "  Dashboard: $LINES lines, $SIZE"
echo "  Animations: $PULSE_COUNT pulse + $FADE_COUNT entrance"
echo "  Accessibility: $REDUCED_MOTION reduced-motion queries"
echo "  GPU-optimized: $BAD_PROPS non-GPU properties (0 = good)"
echo "  HA Status: $HA_STATUS"
echo ""
echo "Next steps:"
echo "1. Review results above"
echo "2. If all checks pass, proceed to Playwright visual tests"
echo "3. Open dashboard: http://192.168.88.125:8123/climate-md3/home"
echo "4. Optional: Manual performance testing (see handoff document)"
echo ""
