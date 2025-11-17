# Git Hooks Documentation

## Post-Commit Hook

**Purpose**: Auto-deploy changes to live Home Assistant server after committing

**Location**: `.git/hooks/post-commit`

**Last Updated**: 2025-11-06

---

## Auto-Synced Directories/Files

The post-commit hook automatically syncs these files to `/home/drewcifer/mnt/homeassistant-config/`:

1. **packages/** - Climate configuration packages
2. **ui-lovelace-climate-control-center-v2.yaml** - V2 dashboard
3. **ui-lovelace-climate-md3.yaml** - MD3 dashboard
4. **themes/** - HA themes (added 2025-11-06)
5. **emergency_scripts_redesigned.yaml** - Emergency scripts
6. **consolidation_phases_2025_10_17/** - Project documentation

---

## Recent Changes

### 2025-11-06: Added themes/ Directory Sync

**Why**: MD3 enhancement project uses custom themes (`md3_climate.yaml`, `md3_enhanced_climate.yaml`)

**Change**:
```bash
rsync -av --exclude='.git' \
    "$REPO/themes/" "$LIVE/themes/" 2>/dev/null
```

**Location**: After `ui-lovelace-climate-md3.yaml`, before `emergency_scripts_redesigned.yaml`

**Impact**: Themes now deploy automatically with dashboard changes

---

## Hook Workflow

```
1. User commits changes (git commit)
2. Pre-commit hook runs (checks for .md clutter)
3. Commit completes
4. Post-commit hook runs (auto-deploys to live)
5. Live HA server updated
```

**Note**: Changes are LIVE immediately after commit. Test on feature branches before merging to main.

---

## Manual Theme Reload (if needed)

If themes don't appear after auto-sync:

```bash
curl -X POST \
  -H "Authorization: Bearer $HA_TOKEN" \
  http://192.168.88.125:8123/api/services/frontend/reload_themes
```

---

## Troubleshooting

### Issue: Hook not running
**Check**: Hook is executable
```bash
chmod +x .git/hooks/post-commit
```

### Issue: Sync failed
**Check**: Mount point accessible
```bash
ls /home/drewcifer/mnt/homeassistant-config/
```

### Issue: Themes not loading
**Check**: Theme file exists
```bash
ls /home/drewcifer/mnt/homeassistant-config/themes/
```
