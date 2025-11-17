# Tablet Configuration - MD3 Dashboard

**Last Updated**: 2025-11-10
**Status**: Planning Phase
**Target Device**: WF2185T 21.5" Wall-Mount Tablet (RK3588S2, 8GB RAM)

---

## Overview

This document provides comprehensive configuration guidance for the WF2185T tablet, including kiosk mode setup, performance optimization, screen burn-in prevention, and ongoing maintenance procedures.

---

## Hardware Specifications

### WF2185T Tablet Details

| Specification | Value | Notes |
|---------------|-------|-------|
| **Screen Size** | 21.5" diagonal | Wall-mount optimized |
| **Resolution** | 1920×1080 (assumed) | Standard FHD for 21.5" |
| **Processor** | RK3588S2 | Rockchip ARM64, 8-core |
| **RAM** | 8GB | Sufficient for complex dashboards |
| **Operating System** | Android 12+ (assumed) | Check actual OS version |
| **Touch** | Capacitive multi-touch | 10-point touch support typical |
| **Connectivity** | Wi-Fi 6, Bluetooth 5.0 | Verify Wi-Fi band (2.4GHz/5GHz) |
| **Power** | 24/7 AC powered | Wall-mount with power adapter |

### Performance Expectations

**CPU**: RK3588S2 is high-performance (comparable to mid-range tablet from 2023)
**RAM**: 8GB allows multiple HA dashboards, background apps
**Storage**: Likely 64GB+ eMMC (verify available storage)
**Browser**: Chromium-based (HA Companion App or Fully Kiosk Browser recommended)

---

## Kiosk Mode Configuration

### Option 1: Home Assistant Companion App (Recommended)

**Pros**:
- Native HA integration
- Push notifications support
- Free, official app
- Auto-restart on crash

**Cons**:
- Limited kiosk features vs Fully Kiosk Browser
- Requires Android settings tweaks for full kiosk mode

#### Installation Steps

**Step 1**: Install HA Companion App
```bash
# On tablet:
# Google Play Store > Search "Home Assistant" > Install official app
# Or sideload APK from: https://github.com/home-assistant/android/releases
```

**Step 2**: Configure Companion App
1. Open HA Companion App
2. Enter HA URL: `http://192.168.88.125:8123`
3. Login with credentials (drewcifer / Minds63qq!)
4. Settings > Display > Set default dashboard: `/tablet-md3/overview`
5. Settings > Display > Enable "Keep Screen On"
6. Settings > Display > Disable "Show App Bar"

**Step 3**: Android System Settings
1. Settings > Display > Sleep: "Never"
2. Settings > Display > Brightness: 80% (adjust for room lighting)
3. Settings > Display > Auto-rotate screen: OFF (lock landscape)
4. Settings > Apps > Home Assistant > Permissions: Allow all
5. Settings > Apps > Home Assistant > Set as default launcher (optional)

**Step 4**: Configure Lovelace Kiosk Mode (HACS Component)

**⚠️ IMPORTANT**: Kiosk Mode is configured via **Home Assistant UI**, NOT dashboard YAML

**Method 1: User Profile Settings** (Simplest):
1. Open Home Assistant on tablet browser
2. Click user profile (bottom left)
3. Scroll to "Kiosk Mode" section (if installed via HACS)
4. Enable "Kiosk Mode" toggle
5. Select options:
   - ✅ Hide header
   - ✅ Hide sidebar
   - ✅ Hide menu button
6. Refresh page

**Method 2: URL Parameters** (Per-Dashboard):
```
http://192.168.88.125:8123/tablet-md3/0?kiosk
# OR with specific options:
http://192.168.88.125:8123/tablet-md3/0?hide_header&hide_sidebar
```

**Method 3: Configuration.yaml** (Global Settings):
```yaml
# Add to configuration.yaml (if using kiosk-mode integration)
kiosk_mode:
  kiosk: true
  hide_header: true
  hide_sidebar: true
  entity_settings:
    - entity:
        user: drewcifer
      kiosk: true
```

**⚠️ DO NOT** add `kiosk_mode:` to `ui-lovelace-tablet-md3.yaml` - this is NOT valid Lovelace YAML syntax

**Validation**:
- Dashboard displays fullscreen (no sidebar/header)
- Navbar card visible at bottom (only navigation)
- Screen stays on 24/7

---

### Option 2: Fully Kiosk Browser (Advanced)

**Pros**:
- True kiosk mode (locks device completely)
- Screensaver support
- Motion detection (wake on approach)
- Scheduled screen on/off
- Remote management via web interface

**Cons**:
- Paid license ($16 for Plus features)
- Requires Android settings tweaks
- More complex configuration

#### Installation Steps

**Step 1**: Install Fully Kiosk Browser
```bash
# Google Play Store > "Fully Kiosk Browser" > Install
# Or download from: https://www.fully-kiosk.com/
```

**Step 2**: Configure Fully Kiosk Browser

**Basic Settings**:
1. Set Start URL: `http://192.168.88.125:8123/tablet-md3/overview`
2. Enable "Kiosk Mode" (locks device to app)
3. Set "Screensaver URL": Black screen or clock display
4. Enable "Keep Screen On"
5. Set "Screen Brightness": 80%

**Advanced Settings**:
1. **Motion Detection**:
   - Enable "Use Camera for Motion Detection"
   - Action: "Wake screen on motion" (optional)
   - Sensitivity: Medium

2. **Scheduled Actions**:
   - Screen Off: 11:00 PM (bedtime)
   - Screen On: 6:00 AM (wake-up)
   - (Adjust to family schedule)

3. **Screensaver**:
   - Start after: 10 minutes idle
   - Screensaver: Digital clock or black screen
   - Prevents burn-in on static dashboard elements

4. **Auto-Restart**:
   - Enable "Restart Device Daily" at 3:00 AM
   - Prevents memory leaks, ensures fresh dashboard load

5. **Remote Admin**:
   - Enable "Remote Administration"
   - Access via: `http://[tablet-ip]:2323`
   - Password-protect admin interface

**Validation**:
- Dashboard loads on tablet boot
- Kiosk mode prevents access to Android system
- Screensaver activates after 10 min idle
- Tablet restarts daily at 3 AM

---

## Network Configuration

### Wi-Fi Optimization

**Recommended Settings** (on router):

**Band**: 5GHz preferred (less interference, higher speed)
**Channel**: DFS channels (52-144) if supported by router
**Security**: WPA3 or WPA2-Personal
**DHCP Reservation**: Assign static IP to tablet (e.g., `192.168.88.200`)

**Tablet Wi-Fi Settings**:
1. Settings > Network > Wi-Fi > [Your Network] > Advanced
2. Enable "Keep Wi-Fi on during sleep: Always"
3. Disable "Switch to mobile data automatically" (if tablet has cellular)
4. Set DNS: Google DNS (8.8.8.8, 8.8.4.4) or Cloudflare (1.1.1.1)

**Network Performance Test**:
```bash
# On tablet browser, navigate to:
http://192.168.88.125:8123/config/network

# Verify:
# - Ping to HA server: <10ms
# - Dashboard load time: <2 seconds
```

### Firewall Exceptions

**If using network segmentation** (IoT VLAN):
- Allow tablet IP → HA server (192.168.88.125) on port 8123
- Allow HA server → tablet for Companion App notifications (if using)

---

## Performance Optimization

### Dashboard Performance Settings

**Camera Loading Strategy** (REVISED 2025-11-11):

**RECOMMENDATION**: Option A - Accept Always-Loaded Cameras with Slow Refresh

**Rationale**: Home Assistant has no native way to detect active dashboard view. Creating helper entities and automations adds complexity with minimal performance benefit for tablet hardware (RK3588S2, 8GB RAM).

**Option A - Slow Refresh (Recommended for Phase 1)**:
```yaml
# Cameras & Security view - Always loaded, accept default refresh
- type: custom:swipe-card
  cards:
    - type: picture-entity
      entity: camera.front_door
      camera_image: camera.front_door
      show_state: false
      show_name: true
      camera_view: live
      aspect_ratio: 16x9
      # Cameras use default refresh (10-30 seconds typical)
      # Tablet hardware can handle 11 cameras always-loaded
```

**Option B - Manual Toggle** (If performance issues arise post-launch):
```yaml
# Add toggle button on Security view header
- type: custom:mushroom-chips-card
  chips:
    - type: template
      icon: mdi:cctv
      content: "{{ 'Hide' if is_state('input_boolean.show_cameras', 'on') else 'Show' }} Cameras"
      tap_action:
        action: call-service
        service: input_boolean.toggle
        service_data:
          entity_id: input_boolean.show_cameras

# Wrap cameras in conditional
- type: conditional
  conditions:
    - condition: state
      entity: input_boolean.show_cameras
      state: "on"
  card:
    type: custom:swipe-card
    cards:
      # ... 11 camera entities
```

**Option C - Browser Mod** (Advanced, defer to Phase 2):
- Requires `browser_mod` custom component
- Automation detects view navigation
- Complex, not worth effort for Phase 1

**Auto-Entities Result Limits**:
```yaml
# Limit auto-entities to prevent rendering 289 binary sensors
- type: custom:auto-entities
  filter:
    include:
      - device_class: door
        state: "on"  # Only show open doors
    exclude: []
  card:
    type: entities
  show_empty: false
  sort:
    method: last_changed
    reverse: true
  head:
    count: 10  # Limit to 10 most recent
```

**ApexCharts Data Reduction** (⚠️ OPTIMIZED for efficiency):
```yaml
# Optimized configuration - match update interval to aggregation duration
- type: custom:apexcharts-card
  graph_span: 4h       # Limit to 4 hours (not 24h)
  span:
    start: hour        # Start at current hour
  update_interval: 5min # ✅ CORRECTED: Match aggregation duration (was 60s - wasteful)
  # NOTE: 5min update interval matches group_by duration (no redundant re-renders)
  series:
    - entity: sensor.climate_living_temperature
      group_by:
        func: avg
        duration: 5min # Aggregate to 5-minute buckets (48 data points over 4h)
```

**Why 5min not 60s?**
- With `duration: 5min` aggregation, new data only appears every 5 minutes
- `update_interval: 60s` causes 5 redundant graph re-renders per data point
- `update_interval: 5min` renders graph only when new data is available
- Reduces CPU usage and prevents unnecessary DOM updates

### Browser Cache Settings

**Clear Cache Schedule** (Fully Kiosk Browser):
- Settings > Advanced Web Settings > "Clear Cache Daily" at 3:00 AM
- Prevents dashboard sluggishness from cache buildup

**HA Companion App**:
- Settings > Companion App > Advanced > "Clear Cache" (manual, monthly)

### Memory Management

**Monitor RAM Usage**:
```bash
# Via ADB (if enabled on tablet):
adb shell dumpsys meminfo com.android.chrome  # If using Chrome
adb shell dumpsys meminfo io.homeassistant.companion.android  # If using Companion App

# Expected: <500MB RAM for single dashboard
```

**Auto-Restart if High Memory** (Fully Kiosk Browser):
- Settings > Advanced > "Restart Browser if Memory Usage > 1GB"

---

## Screen Burn-In Prevention

### Risk Assessment

**High Risk Elements** (static, always visible):
- Navbar icons (bottom of screen)
- Status chips (Overview page header)
- Weather widget icon

**Low Risk Elements** (dynamic, changing):
- Temperature sensors (values change)
- Graphs (animated)
- Camera feeds (motion)

### Mitigation Strategies

#### Strategy 1: Screensaver (Recommended)

**Fully Kiosk Browser**:
- Screensaver: Digital clock (moving, not static)
- Start after: 10 minutes idle
- Wake on touch or motion

**HA Companion App**:
- Use Android Daydream feature
- Settings > Display > Screen Saver: "Clock" or "Colors"
- Start when idle

#### Strategy 2: Automatic Brightness Reduction

**Fully Kiosk Browser**:
```
Scheduled Actions:
- 11:00 PM: Brightness 10%, Screen Off
- 6:00 AM: Brightness 80%, Screen On
- 10:00 PM: Brightness 50% (pre-bedtime dimming)
```

#### Strategy 3: Navbar Rotation (Advanced)

**Not recommended** - Complex to implement, low ROI

Alternative: Accept minor navbar burn-in as acceptable trade-off for usability

#### Strategy 4: OLED vs LCD

**WF2185T Screen Type**: Likely LCD (not OLED)
- **LCD**: Lower burn-in risk than OLED
- **OLED**: Would require aggressive burn-in prevention

**If OLED**: Implement all strategies + pixel shift feature (if available in Fully Kiosk)

---

## Power Management

### Always-On Configuration

**Goal**: Tablet remains powered 24/7, dashboard always visible (except scheduled screen-off)

**Android Settings**:
1. Settings > Display > Sleep: "Never"
2. Settings > Battery > Battery Saver: OFF
3. Settings > Apps > Home Assistant (or Fully Kiosk) > Battery > "Unrestricted"

**Power Adapter**:
- Use included 12V/2A+ adapter (check tablet specs)
- Ensure secure connection (wall-mount cable management)
- Consider UPS backup for HA server (ensures tablet dashboard functional during power blip)

### Thermal Management

**Monitoring**:
- Normal operating temp: 30-45°C (86-113°F)
- Warning temp: 50°C+ (122°F+)

**If Overheating**:
1. Reduce screen brightness (50% instead of 80%)
2. Improve ventilation around wall-mount (ensure airflow behind tablet)
3. Disable screensaver (ironically, animated screensaver can generate heat)
4. Scheduled screen-off during hottest part of day (2-5 PM in Texas summer)

**Temperature Sensor** (optional):
- Create HA automation: If tablet overheating sensor > 50°C, send mobile notification

---

## Maintenance Procedures

### Daily (Automated)

**3:00 AM**:
- Tablet restarts (Fully Kiosk setting)
- Browser cache cleared (Fully Kiosk setting)
- Dashboard reloads fresh

### Weekly (Manual)

**Check**:
- Dashboard performance (page load times)
- Screen for dust/smudges (clean with microfiber cloth)
- Wi-Fi signal strength (HA Companion App > About > Network)

### Monthly (Manual)

**Tasks**:
1. Clear HA Companion App cache (if not using Fully Kiosk)
2. Check for Android OS updates (Settings > System > System Update)
3. Check for HA Companion App updates (Google Play Store)
4. Check for Fully Kiosk Browser updates (if using)
5. Review tablet storage (delete old downloads, APKs)

### Quarterly (Manual)

**Tasks**:
1. Factory reset consideration (if performance degraded)
2. Review dashboard performance metrics
3. Check for screen burn-in (display solid white screen, inspect for shadows)

---

## Troubleshooting Guide

### Issue: Dashboard Not Loading

**Symptoms**: Blank screen, loading spinner, or error message

**Diagnosis**:
1. Check tablet Wi-Fi connection (Settings > Network)
2. Ping HA server: `http://192.168.88.125:8123/` in browser
3. Check HA server status (on desktop: http://192.168.88.125:8123/)

**Solution**:
- Restart tablet
- Restart HA server (if unresponsive)
- Check router/network
- Verify HA Companion App logged in

---

### Issue: Sluggish Performance

**Symptoms**: Slow page transitions, lag when tapping buttons, camera feed stuttering

**Diagnosis**:
1. Check tablet RAM usage (Settings > Apps > Running Services)
2. Check HA server CPU (HA > Settings > System > Hardware)

**Solution**:
- Clear browser cache (Fully Kiosk: Settings > Clear Cache)
- Restart tablet (Fully Kiosk: Remote Admin > Restart Device)
- Optimize dashboard (reduce camera refresh rate, limit auto-entities results)

---

### Issue: Screen Burn-In Visible

**Symptoms**: Faint static outlines of navbar icons, status chips

**Diagnosis**:
1. Display solid white screen (use browser: `https://www.solid.com/white`)
2. Inspect for gray shadows

**Solution** (Prevention, not reversal):
- Enable screensaver (10 min idle timeout)
- Reduce brightness (50% instead of 80%)
- Scheduled screen-off during sleep hours
- Accept minor burn-in as acceptable (navbar is critical for navigation)

**Note**: LCD burn-in is rare and usually reversible (unlike OLED)

---

### Issue: Kiosk Mode Exited

**Symptoms**: User can access Android home screen, settings

**Diagnosis**:
- Kiosk Mode disabled in Fully Kiosk settings
- Android launcher changed

**Solution**:
- Fully Kiosk: Settings > Kiosk Mode > Enable "Kiosk Mode (Lock Device)"
- Set Fully Kiosk as default launcher: Settings > Apps > Default Apps > Home App > Fully Kiosk Browser

---

### Issue: Tablet Not Auto-Starting Dashboard on Boot

**Symptoms**: Tablet boots to Android home screen instead of HA dashboard

**Diagnosis**:
- Companion App or Fully Kiosk not set as default launcher
- Auto-start disabled

**Solution**:

**HA Companion App**:
1. Settings > Apps > Home Assistant > Set as Default > Home App

**Fully Kiosk Browser**:
1. Settings > Start URL: `http://192.168.88.125:8123/tablet-md3/overview`
2. Settings > Kiosk Mode > "Launch on Boot": ON

---

## Security Considerations

### Kiosk Mode Security

**Risk**: Anyone with physical access to tablet can interact with HA dashboard

**Mitigation**:
1. **PIN Protection for Critical Actions**:
   - Configure HA to require PIN for:
     - Alarm disarm
     - Garage door control
     - Climate override scripts

   ```yaml
   # configuration.yaml
   homeassistant:
     auth_providers:
       - type: homeassistant
       - type: legacy_api_password
         api_password: !secret alarm_pin
   ```

2. **User-Specific Dashboards** (optional):
   - Family members see different dashboards based on login
   - Not recommended for wall-mount (defeats kiosk purpose)

3. **Physical Security**:
   - Wall-mount in controlled access area (not visible from windows)
   - Consider screensaver timeout to hide dashboard when not in use

### Network Security

**Tablet Isolation** (optional, advanced):
- Place tablet on IoT VLAN
- Restrict tablet to HA server communication only (no internet access)
- Prevents potential malware from tablet affecting home network

**HA Authentication**:
- Keep HA login credentials secure
- Enable 2FA for HA user accounts (desktop access)
- Tablet uses long-lived access token (no password stored)

---

## Backup & Recovery

### Tablet Configuration Backup

**Document Settings** (manual documentation):
1. Screenshot all Fully Kiosk settings pages
2. Export HA Companion App settings (if supported)
3. Save this document (`06-tablet-configuration.md`) for reference

**Android Backup** (optional):
1. Settings > System > Backup
2. Ensure "Back up to Google Drive" enabled
3. Includes app data (Fully Kiosk settings)

### Recovery Procedure (Factory Reset Scenario)

**If tablet requires factory reset**:

**Step 1**: Factory Reset
- Settings > System > Reset Options > Erase All Data (Factory Reset)

**Step 2**: Initial Setup
- Connect to Wi-Fi
- Sign in to Google account (optional, for Play Store access)

**Step 3**: Install Apps
- HA Companion App OR Fully Kiosk Browser

**Step 4**: Restore Configuration
- Follow "Kiosk Mode Configuration" section above
- Restore settings from screenshots/documentation

**Step 5**: Test Dashboard
- Navigate to `http://192.168.88.125:8123/tablet-md3/overview`
- Verify all views load correctly

---

## Advanced Features (Optional)

### Tablet as HA Presence Sensor

**Use Case**: Detect if anyone is in room with wall-mounted tablet (via front camera)

**Implementation**:
- Fully Kiosk Browser: Enable "Motion Detection"
- Create HA automation: If motion detected, set `input_boolean.living_room_occupied` to ON
- Use in climate automations (adjust setpoints based on occupancy)

**Privacy Note**: Camera motion detection is local (doesn't send images to cloud)

---

### Voice Control Integration

**Use Case**: Voice commands to tablet ("Hey Google, turn on living room lights")

**Implementation**:
1. Install Google Assistant on tablet (if not pre-installed)
2. Configure HA Google Assistant integration
3. Enable "OK Google" hotword detection
4. Place tablet in central location for voice pickup

**Limitation**: May interfere with kiosk mode (Assistant requires permissions)

---

### Tablet Screen as Clock (Screensaver Mode)

**Use Case**: When idle, display full-screen digital clock instead of dashboard

**Implementation**:

**Fully Kiosk Browser**:
- Settings > Screensaver > Screensaver URL: `http://192.168.88.125:8123/lovelace-clock` (create separate clock dashboard)
- Or use built-in clock: Settings > Screensaver > "Digital Clock"

**HA Companion App**:
- Use Android Daydream with custom HA clock dashboard

---

## Performance Benchmarks

### Target Performance Metrics

| Metric | Target | Acceptable | Unacceptable |
|--------|--------|------------|--------------|
| Overview Page Load | <2s | <3s | >3s |
| Room Page Navigation | <1s | <2s | >2s |
| Camera View Load (9 cameras) | <3s | <5s | >5s |
| ApexCharts Render | <2s | <3s | >3s |
| Button Tap Response | <300ms | <500ms | >500ms |
| Tablet RAM Usage | <1GB | <1.5GB | >2GB |

### Benchmark Testing Procedure

**Step 1**: Clear cache, restart tablet
**Step 2**: Load Overview page, record time (DevTools Network tab)
**Step 3**: Navigate to all 10 views, record transition times
**Step 4**: Check RAM usage (Settings > Apps > Running Services)
**Step 5**: Document results in implementation log

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2025-11-10 | Initial tablet configuration documentation | Claude |

---

## Related Documents

- `00-project-overview.md` - Project goals
- `05-implementation-phases.md` - Kiosk configuration timeline (Week 4)

---

**Next Steps**: After dashboard implementation complete (Week 3), configure kiosk mode and test on actual WF2185T tablet hardware
