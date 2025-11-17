# User Acceptance Testing Checklists - MD3 Tablet Dashboard

**Purpose**: Structured validation after each phase (simple checkbox format, not full BDD)
**Format**: Quick checklists for manual testing
**Duration**: 10-15 minutes per phase

---

## Phase 1 UAT: Foundation & Overview Page (End of Week 1)

**Tester**: Drew
**When**: After completing all Phase 1 tasks (before starting Phase 2)
**Duration**: 15 minutes

### Dashboard Access & Navigation
- [ ] Dashboard accessible at `http://192.168.88.125:8123/tablet-md3/0`
- [ ] Navbar displays with 10 tabs (Home, Living, Master, Rowan, Office, Guest, Security, Calendar, System, Scenes)
- [ ] Clicking navbar tabs navigates to correct views (even if views empty)
- [ ] No browser console errors on page load

### Overview Page - Weather Section
- [ ] Clock Weather Card displays current conditions
- [ ] Weather forecast shows 5-day outlook
- [ ] Animated weather icon renders
- [ ] Temperature displays in °F
- [ ] Page loads in <2 seconds

### Overview Page - Climate Summary
- [ ] Thermostat card shows current temperature
- [ ] Temperature setpoint adjustable via slider
- [ ] Average house temperature displays
- [ ] Average house humidity displays
- [ ] Equipment arbitration status chip shows current state
- [ ] Dehumidifier control visible

### Overview Page - Emergency Controls
- [ ] 3 emergency buttons display (Humidity Override, Cooling Boost, Reset All)
- [ ] Buttons arranged horizontally (not stacked)
- [ ] Tapping "HUMIDITY OVERRIDE" button triggers script
- [ ] Mobile notification received on iPhone after script activation
- [ ] Button state changes after tap (visual feedback)

### Overview Page - Status Chips
- [ ] Alarm status chip displays current state (armed/disarmed)
- [ ] Doors open count chip shows correct number
- [ ] Garage status chip displays door states
- [ ] Person presence chip shows location

### Overview Page - Room Quick Access
- [ ] 6 room navigation buttons display
- [ ] Tapping "Living" button navigates to Living view
- [ ] Tapping "Master" button navigates to Master view
- [ ] Room buttons show current temperature

### Theme & Styling
- [ ] Material You Theme active
- [ ] Color picker available in user profile
- [ ] Cards have 85% transparency (can see wallpaper behind)
- [ ] Material Symbols icons render (m3o: prefix)
- [ ] Climate colors display correctly (green/amber/red based on values)

### Performance
- [ ] Overview page loads in <2 seconds
- [ ] Navigation between views smooth (no lag)
- [ ] No memory leaks after 5 minutes use

### Mobile Notifications
- [ ] Emergency script activation sends notification to `notify.mobile_app_drews_iphone`
- [ ] Notification arrives within 5 seconds
- [ ] Notification has custom sound (high priority)

### Acceptance
- [ ] 90% of checks pass (38/42 minimum)
- [ ] All CRITICAL items pass (dashboard access, emergency controls, performance)
- [ ] No showstopper bugs

**Go/No-Go Decision**:
- ✅ GO: 38+ checks pass → Proceed to Phase 2
- ❌ NO-GO: <38 checks pass → Document issues, fix, re-test

**Issues Found** (document here):
-

**Screenshots**: (attach 2-3 screenshots of Overview page)

---

## Phase 2 UAT: Climate Room Pages (End of Week 2)

**Tester**: Drew + Cassie
**When**: After completing all 5 room pages
**Duration**: 20 minutes

### Living Area Page
- [ ] Page accessible via navbar or quick access
- [ ] Page loads in <2 seconds
- [ ] Room header displays "Living Area" title
- [ ] Occupancy chip shows motion sensor state
- [ ] 4 climate sensors display (living, dining, kitchen)
- [ ] All 4 temperature values show (not "unavailable")
- [ ] All 4 humidity values show
- [ ] ApexCharts graph displays 4-hour temperature trends
- [ ] Graph has comfort zone shading (71-75°F green band)
- [ ] Dew point card displays calculated value
- [ ] Dew point icon color matches value (green/amber/red)
- [ ] 3 light controls functional (living room, dining room, kitchen)
- [ ] Fan control displays (if fan powered on)
- [ ] Blinds control displays
- [ ] Media player cards display when TV/speaker powered on

### Master Suite Page
- [ ] 3 climate sensors display (bedroom, bathroom, closet)
- [ ] ApexCharts graph shows 3-sensor trends
- [ ] 4 light controls functional (bedroom, bathroom, closet, accent)
- [ ] Thermostat shows bedroom temperature prominently

### Rowan's Room Page
- [ ] 1 climate sensor displays
- [ ] Mini-graph-card shows trend
- [ ] Light control functional

### Office Page
- [ ] 1 climate sensor displays
- [ ] Fan control functional
- [ ] Media player controls work

### Guest Bedroom Page
- [ ] 2 climate sensors display (guest bed, guest bath)
- [ ] 2 light controls functional

### 18-Sensor Network Validation
- [ ] All 18 climate sensors showing data (not "unavailable")
- [ ] Temperature values realistic (68-78°F range)
- [ ] Humidity values realistic (40-60% range)
- [ ] Dew point values realistic (55-65°F range)

### Performance
- [ ] Each room page loads in <2 seconds
- [ ] ApexCharts graphs render in <3 seconds
- [ ] No lag when switching between room pages
- [ ] Tablet responsive after 10 minutes of use

### Acceptance
- [ ] 85% of checks pass (40/47 minimum)
- [ ] All 18 climate sensors operational
- [ ] All room pages functional

**Go/No-Go Decision**:
- ✅ GO: 40+ checks pass → Proceed to Phase 3
- ❌ NO-GO: <40 checks pass → Fix issues, re-test

**Issues Found**:
-

---

## Phase 3 UAT: Secondary Views (End of Week 3)

**Tester**: Whole family
**When**: After completing cameras, calendar, scenes views
**Duration**: 20 minutes

### Cameras & Security Page
- [ ] Page accessible via navbar
- [ ] Mushroom Alarm Control Panel displays
- [ ] Alarm status shows correct state (armed/disarmed)
- [ ] Arm Home button works
- [ ] Arm Away button works
- [ ] Disarm button works (with code entry)
- [ ] 9 cameras display in 3×3 grid
- [ ] All cameras show current feed (not broken image)
- [ ] Camera feeds refresh automatically
- [ ] Tap camera for full-screen view
- [ ] Door sensor timeline displays last 10 events
- [ ] Motion sensor timeline displays last 10 events

### Calendar & Planning Page
- [ ] Week Planner Card displays
- [ ] All 6 calendars show events
- [ ] 7-day view visible (current week)
- [ ] Events color-coded by calendar
- [ ] Calendar Card Pro shows month view
- [ ] Weather forecast displays above planner

### Scenes Page
- [ ] Scene Presets card displays (if installed)
- [ ] OR button-card grid displays scenes (if Scene Presets not compatible)
- [ ] 5+ lighting scenes display
- [ ] Tap scene activates lights correctly
- [ ] Active lights display below scene grid
- [ ] Scene category filters work (All, Living, Master, Whole Home)

### Acceptance
- [ ] 80% of checks pass (20/25 minimum)
- [ ] Alarm control functional
- [ ] All 9 cameras displaying
- [ ] Calendar shows events

**Go/No-Go Decision**:
- ✅ GO: 20+ checks pass → Proceed to Phase 4
- ❌ NO-GO: <20 checks pass → Fix issues, re-test

**Family Feedback**:
- Cassie:
- Kids:

---

## Phase 4 UAT: System View & Final Validation (End of Week 4)

**Tester**: Whole family
**When**: After completing all views + kiosk mode
**Duration**: 30 minutes

### System View
- [ ] Garage door controls display
- [ ] Garage camera feed shows
- [ ] Utility climate sensors display (laundry, half bath, foyer)
- [ ] HVAC system monitoring shows return/supply temps
- [ ] Performance gauges display (CPU, memory, disk)
- [ ] Notifications center displays recent alerts

### Kiosk Mode (Tablet)
- [ ] Dashboard loads automatically on tablet boot
- [ ] Sidebar hidden
- [ ] Header hidden
- [ ] Navbar visible (bottom navigation)
- [ ] Screensaver activates after 10 min idle
- [ ] Dashboard runs 24 hours without crash

### Performance (Tablet)
- [ ] All pages load in <2 seconds
- [ ] Camera view loads in <3 seconds (9 cameras)
- [ ] No lag after 24 hours uptime
- [ ] RAM usage acceptable (<50% of 8GB)

### Final Integration Test
- [ ] Navigate to every view (10 views) - all load
- [ ] Activate emergency script - works
- [ ] Arm/disarm alarm - works
- [ ] Adjust thermostat - works
- [ ] Activate lighting scene - works
- [ ] Check calendar - works
- [ ] View all cameras - works
- [ ] Check garage status - works

### User Acceptance (Family Survey)
Rate each aspect (1-5, where 5 = excellent):

**Drew**:
- Usability: __/5
- Speed: __/5
- Aesthetics: __/5
- Climate Control: __/5
- Overall: __/5

**Cassie**:
- Usability: __/5
- Speed: __/5
- Aesthetics: __/5
- Ease of Use: __/5
- Overall: __/5

**Kids** (if they use it):
- Can they turn on lights? Y/N
- Can they check their room temp? Y/N
- Do they prefer new dashboard? Y/N

### Final Acceptance
- [ ] 90% of checks pass (22/24 minimum)
- [ ] Average family rating ≥4.0/5.0
- [ ] Tablet runs 24+ hours without issues
- [ ] Family prefers MD3 dashboard over old dashboard

**Go/No-Go Decision**:
- ✅ GO: Launch as primary dashboard
- ❌ NO-GO: Keep old dashboard, document blockers

**Issues Found**:
-

**Final Verdict**: [ ] APPROVED FOR PRODUCTION / [ ] NEEDS WORK

---

## UAT Tips

### Efficient Testing
- Test during normal use (don't create artificial test scenarios)
- Take screenshots of each page for documentation
- Note performance issues immediately (don't wait)
- Get family involved (real users find real issues)

### When to Re-Test
- After fixing ANY issue found in UAT
- After HA version update (validate compatibility)
- After HACS component updates

### Documentation
- Save UAT results in this file (check boxes, add notes)
- Screenshot each phase completion
- Keep record of family feedback

---

**Created**: 2025-11-14
**Purpose**: Pragmatic testing without BDD overhead
**Format**: Simple checklists for real-world validation
