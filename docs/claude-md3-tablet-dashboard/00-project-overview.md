# Material Design 3 Tablet Dashboard - Project Overview

**Project Name**: Claude MD3 Tablet Dashboard Adaptation
**Start Date**: 2025-11-10
**Target Device**: WF2185T 21.5" Wall-Mount Tablet (RK3588S2, 8GB RAM)
**Source**: [ElementZoom/Material-Design-3-Dynamic-Tablet-Dashboard](https://github.com/ElementZoom/Material-Design-3-Dynamic-Tablet-Dashboard)
**Version**: v2.0.0 (MD3 Reference Dashboard)

---

## Executive Summary

This project adapts the ElementZoom Material Design 3 Dynamic Tablet Dashboard to create a climate-focused, Gulf Coast optimized control interface for a League City, TX smart home. The dashboard leverages an 18-sensor climate network, sophisticated HVAC equipment arbitration, and existing Home Assistant integrations to provide comprehensive whole-home control on a dedicated 21.5" wall-mounted tablet.

**Phase 0 Status**: ✅ **COMPLETE** (November 13-14, 2025)
**Current Readiness**: 10/10 - Ready for Week 1 implementation
**One-Shot Success Probability**: 95%

### Key Objectives

1. **Climate-First Design**: Showcase the 18-sensor ZG-227Z network with room-by-room temperature, humidity, and dew point visualization
2. **Material Design 3 Compliance**: Implement dynamic theming with Material You color picker for personalized aesthetics
3. **Gulf Coast Optimization**: Emphasize humidity control, dew point management, and equipment arbitration unique to coastal climate
4. **Unified Control**: Consolidate climate, lighting (Zigbee2MQTT/Z-Wave), security (Envisalink), cameras, and calendar into single tablet interface
5. **Emergency Accessibility**: Place critical climate override controls within 2 taps from any view
6. **Performance**: Achieve <2 second page load times on tablet hardware with 953 sensors, 647 automations

---

## Project Scope

### In Scope

**Core Views** (10 total):
- Overview (main hub)
- 5 Climate Room pages (Living Area, Master, Rowan, Office, Guest)
- Cameras & Security (9 cameras + Envisalink alarm + sensors)
- Calendar & Planning (Week Planner + family calendars + weather)
- System Monitoring (garage, notifications, performance metrics)
- Scenes (Zigbee2MQTT/Z-Wave lighting presets)

**Customizations**:
- Material You Theme with dynamic color picker
- 18-sensor climate network visualization
- Equipment arbitration status displays
- Emergency script controls (4 buttons: humidity override, cooling boost, system restart, reset)
- Dew point tracking and trends
- WAQI air quality integration (✅ Operational - 9 working entities via direct API access, documentation in `/temp/testing/`)
- Energy savings metrics

**Technical Deliverables**:
- New dashboard file: `ui-lovelace-tablet-md3.yaml`
- Decluttering templates for reusable components
- Material You theme configuration
- Kiosk mode setup for wall-mounted tablet
- Performance optimization (conditional loading, lazy cameras)

### Out of Scope

- Irrigation view (no sprinkler entities available)
- Alarmo integration (using Mushroom Alarm Card with Envisalink instead)
- WebRTC camera implementation (Phase 1 - evaluate standard camera cards first)
- Mobile phone optimization (tablet-only focus)
- Multi-user access control (single-home KISS approach)

---

## Success Metrics

### Technical Success Criteria

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| Page Load Time | <2 seconds | Browser DevTools Network tab |
| View Count | 9 functional views | Manual navigation test |
| Climate Sensor Coverage | 18/18 sensors displaying | Entity availability check |
| Emergency Script Access | ≤2 taps from any view | User path analysis |
| Material You Theme | Color picker functional | Theme selector test |
| Envisalink Integration | Alarm controllable via Mushroom card | Arm/disarm test |
| WAQI Integration | ✅ Working (Manual REST sensors) | 9 entities operational via direct API access (HA Bug #133919 workaround) |
| Scene Control | Zigbee2MQTT/Z-Wave scenes executable | Scene activation test |

### User Experience Success Criteria

| Criterion | Definition | Validation |
|-----------|------------|------------|
| Family Adoption | Household members prefer MD3 over current dashboard | User feedback survey |
| Emergency Accessibility | Climate overrides reachable in <5 seconds | Timed user test |
| Visual Consistency | All views follow MD3 design language | Design review |
| Information Density | Climate data visible without scrolling | Screen capture review |
| Touch Responsiveness | All controls respond within 300ms | Interaction testing |
| Tablet Stability | Dashboard runs 7+ days without restart | Uptime monitoring |

### Project Success Criteria

- ✅ **Phase 1 Complete** (Week 1): Overview page functional with weather, climate, emergency controls
- ✅ **Phase 2 Complete** (Week 2): All 5 climate room pages operational with 18-sensor network
- ✅ **Phase 3 Complete** (Week 3): Cameras, security, calendar, scenes views functional
- ✅ **Phase 4 Complete** (Week 4): Tablet kiosk mode configured, performance optimized, documentation complete
- ✅ **User Acceptance**: Family prefers MD3 dashboard as primary control interface

---

## Stakeholders

**Primary User**: Drew (homeowner, power user, climate system administrator)
**Secondary Users**: Family members (Cassie, children)
**Technical Contact**: Drew
**Project Lead**: Claude (AI assistant)

---

## Project Constraints

### Technical Constraints

1. **KISS Principles**: Single-home design, no enterprise features (per CLAUDE.md)
2. **Equipment Safety**: Must preserve AC/dehumidifier mutual exclusion arbitration
3. **Git Workflow**: All changes via git commit (post-commit hook auto-deploys)
4. **Validation Required**: `ha-validate` must pass before all commits
5. **Theme Compatibility**: Must work with existing `md3_enhanced_climate.yaml` theme
6. **Entity Availability**: Cannot add entities not present in current HA installation

### Hardware Constraints

1. **Tablet Specifications**: WF2185T (RK3588S2, 8GB RAM, likely 1920x1080 resolution)
2. **Wall-Mounted**: Kiosk mode required, always-on operation
3. **Network Dependency**: Requires stable Wi-Fi to HA server (192.168.88.125:8123)
4. **Screen Burn-In**: Must implement screensaver or rotation to prevent static image damage

### Time Constraints

1. **Target Completion**: 4 weeks (2025-11-11 to 2025-12-09)
2. **Weekly Milestones**: Phased delivery with functional increments
3. **Non-Disruptive**: Existing `gulf-coast-climate-optimized.yaml` remains operational as fallback

---

## Risk Assessment

### High Priority Risks

| Risk | Probability | Impact | Mitigation Strategy |
|------|------------|--------|---------------------|
| Material Symbols HACS unavailable | Low | High | Use MDI icon fallbacks (mdi: prefix instead of m3o:) |
| Material You Theme breaks existing theme | Medium | High | Create separate theme file, test before switching |
| Tablet performance degradation (953 sensors) | Medium | Medium | Implement conditional loading, lazy camera rendering |
| Kiosk mode configuration errors | Medium | Low | Test in standard browser first, document rollback steps |

### Medium Priority Risks

| Risk | Probability | Impact | Mitigation Strategy |
|------|------------|--------|---------------------|
| WAQI API rate limiting | Low | Low | Manual REST sensors: 30min scan interval = 1,440/month (under 1,000/month free tier) |
| Scene Presets incompatible with Zigbee2MQTT | Medium | Low | Verify compatibility before installation, use button-card alternative |
| Envisalink entity changes breaking Mushroom card | Low | Medium | Document entity dependencies, test after HA updates |
| Family resistance to new interface | Medium | Medium | Keep old dashboard accessible during transition period |

### Low Priority Risks

| Risk | Probability | Impact | Mitigation Strategy |
|------|------------|--------|---------------------|
| HACS component update incompatibilities | Low | Low | Pin component versions in HACS |
| Tablet hardware failure | Low | High | Document tablet setup for replacement |
| Network outage during deployment | Low | Low | Deploy during low-usage hours, keep fallback dashboard |

---

## Dependencies

### External Dependencies

1. **HACS Components** (5 new installations required):
   - Material You Theme (CRITICAL)
   - Material Symbols (CRITICAL)
   - Lovelace Material Components (CRITICAL)
   - Paper Buttons Row (HIGH)
   - Scene Presets (MEDIUM)

2. **Home Assistant Integrations** (already installed):
   - Envisalink (alarm_control_panel.home_alarm)
   - WAQI (✅ Manual REST sensors - 9 entities operational: AQI=15, PM2.5=10, O3=18.4, NO2=1.7, temp=77.7°F, humidity=89%, attribution=TCEQ, category=Good)
   - Zigbee2MQTT (18 climate sensors, lights)
   - Z-Wave (switches, sensors)
   - Weather integration (weather.forecast_home)
   - Calendar integration (6 calendars)

3. **GitHub Repository**:
   - ElementZoom/Material-Design-3-Dynamic-Tablet-Dashboard (reference source)

### Internal Dependencies

1. **Existing Climate System** (must not disrupt):
   - `packages/climate_fresh_start.yaml` (1,836 lines, primary control logic)
   - `packages/emergency_scripts_redesigned.yaml` (398 lines, override controls)
   - Equipment arbitration automations
   - Dew point calculation sensors

2. **Existing Dashboards** (preserve during development):
   - `dashboards/gulf-coast-climate-optimized.yaml` (current primary dashboard)
   - `dashboards/md3-dashboard-enhanced.yaml` (previous MD3 attempt)

3. **Theme System**:
   - `themes/md3_enhanced_climate.yaml` (current MD3-compliant theme)

4. **Git Hooks**:
   - `.git/hooks/post-commit` (auto-deployment to live system)
   - `.git/hooks/pre-commit` (root directory clutter prevention)

---

## Project Timeline

### Phase 1: Foundation (Week 1 - Nov 11-17, 2025)
- Install Material Symbols (CRITICAL - only missing component)
- Create `ui-lovelace-tablet-md3.yaml` base structure
- Configure Material You Theme (copy-and-modify approach)
- Create template sensors (occupancy, comfort scores)
- Build Overview page with weather, climate summary, emergency controls

**Deliverable**: Functional Overview page with all required template sensors

### Phase 2: Climate Rooms (Week 2 - Nov 18-24, 2025)
- Build 5 climate room pages
- Integrate 18-sensor network visualizations
- Add room-specific controls (lights, fans, media)
- Implement dew point displays

**Deliverable**: All 5 climate room pages operational

### Phase 3: Secondary Views (Week 3 - Nov 25-Dec 1, 2025)
- Install Scene Presets
- Build Cameras & Security page (Mushroom Alarm Card)
- Build Calendar page (WAQI available via manual REST sensors)
- Create Scenes view

**Deliverable**: Cameras, security, calendar, scenes views functional

### Phase 4: Refinement & Launch (Week 4 - Dec 2-9, 2025)
- Build System view (garage, notifications, performance)
- Configure tablet kiosk mode
- Performance optimization
- Mobile responsive testing
- Documentation handoff

**Deliverable**: Production-ready dashboard deployed on wall-mounted tablet

---

## Budget

### Development Time

- **Planning & Research**: 8 hours (completed 2025-11-10)
- **Implementation**: 32 hours estimated (8 hours/week × 4 weeks)
- **Testing & Refinement**: 8 hours
- **Documentation**: 4 hours
- **Total**: ~52 hours

### Hardware Costs

- **Tablet**: WF2185T 21.5" (already purchased, $0 incremental)
- **Wall Mount**: (assumed already installed, $0 incremental)
- **Power**: Continuous operation (~$2/month estimated, $0.50 for 1-week testing)

### Software Costs

- **Home Assistant**: Free (self-hosted)
- **HACS Components**: Free (open source)
- **Material You Theme**: Free (open source)
- **Total Software**: $0

### Total Project Cost

- **Incremental Cost**: ~$0.50 (electricity during testing)
- **Opportunity Cost**: 52 hours development time

---

## Communication Plan

### Status Updates

- **Frequency**: End of each phase (weekly)
- **Format**: Markdown summary with screenshots
- **Distribution**: Session handoff documentation in `temp/sessions/`

### Issue Escalation

- **Blocker Issues**: Immediate notification to user
- **Technical Decisions**: AskUserQuestion tool for clarification
- **Component Failures**: Document in session notes, propose alternatives

### Documentation

- **Planning Docs**: `docs/claude-md3-tablet-dashboard/` (this directory)
- **Session Handoffs**: `temp/sessions/md3-tablet-dashboard-*.md`
- **Implementation Notes**: Inline YAML comments in dashboard file
- **Git Commit Messages**: Descriptive, follow existing repository conventions

---

## Project Approval

**Plan Approved**: 2025-11-10
**Approved By**: Drew (homeowner)
**Claude Agent**: Sonnet 4.5 (claude-sonnet-4-5-20250929)
**Session**: MD3 Tablet Dashboard Planning

**Next Action**: Proceed with Phase 1 implementation (HACS component installations, Overview page creation)

---

## Reference Documents

1. [ElementZoom MD3 Dashboard Repository](https://github.com/ElementZoom/Material-Design-3-Dynamic-Tablet-Dashboard)
2. Home Assistant Entity Inventory (see `02-entity-mapping.md`)
3. Component Requirements (see `01-component-requirements.md`)
4. View Architecture (see `03-view-architecture.md`)
5. Customization Strategy (see `04-customization-strategy.md`)
6. Implementation Phases (see `05-implementation-phases.md`)
7. Tablet Configuration (see `06-tablet-configuration.md`)
8. Project CLAUDE.md (`/home/drewcifer/homeassistant-config/.claude/CLAUDE.md`)
9. Global CLAUDE.md (`/home/drewcifer/.claude/CLAUDE.md`)

---

**Document Version**: 1.0
**Last Updated**: 2025-11-10
**Status**: Active
