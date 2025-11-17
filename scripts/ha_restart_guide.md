# Home Assistant Restart Guide

## Database Migration Status: ✅ COMPLETE

The database has been successfully moved from root to `/config/data/` directory:
- **452MB** moved to `data/home-assistant.db` (and WAL files)
- **Root directory** cleaned up
- **Configuration** already pointing to new location

## Restart Methods (Try in Order)

### Method 1: Systemctl Service
```bash
sudo systemctl start home-assistant.service
sudo systemctl status home-assistant.service
```

### Method 2: Python Module (if installed via pip)
```bash
cd /home/drewcifer/mnt/homeassistant-config
python3 -m homeassistant --config . --daemon
```

### Method 3: Direct Command
```bash
cd /home/drewcifer/mnt/homeassistant-config
hass --config . --daemon
```

### Method 4: Virtual Environment
```bash
# If HA is in a venv:
source /path/to/venv/bin/activate
hass --config /home/drewcifer/mnt/homeassistant-config --daemon
```

### Method 5: Docker (if applicable)
```bash
docker start home-assistant
```

## Verification Steps

After starting HA, verify:

1. **Check if running:**
   ```bash
   ps aux | grep hass | grep -v grep
   ```

2. **Check API:**
   ```bash
   curl -s -H "Authorization: Bearer YOUR_TOKEN" "http://192.168.88.125:8123/api/"
   ```

3. **Check climate system:**
   - Access web interface: http://192.168.88.125:8123
   - Verify 18-sensor network is online
   - Check equipment arbitration status
   - Confirm dew point control working

## If Issues Occur

### Rollback (Full)
```bash
# Stop HA
sudo systemctl stop home-assistant.service 2>/dev/null || pkill -f hass

# Move files back
mv /home/drewcifer/mnt/homeassistant-config/data/home-assistant.db* /home/drewcifer/mnt/homeassistant-config/

# Rename back to original format
mv /home/drewcifer/mnt/homeassistant-config/home-assistant.db /home/drewcifer/mnt/homeassistant-config/home-assistant_v2.db
mv /home/drewcifer/mnt/homeassistant-config/home-assistant.db-shm /home/drewcifer/mnt/homeassistant-config/home-assistant_v2.db-shm
mv /home/drewcifer/mnt/homeassistant-config/home-assistant.db-wal /home/drewcifer/mnt/homeassistant-config/home-assistant_v2.db-wal

# Start HA with original configuration
# [Use the method that worked before]
```

### Restore from Backup
```bash
# If rollback fails, use backup
cp ~/backups/database_migration_20251112_225431/home-assistant_v2.db* /home/drewcifer/mnt/homeassistant-config/
```

## Success Criteria

✅ HA starts successfully
✅ Web interface accessible at http://192.168.88.125:8123
✅ 18-sensor climate network online
✅ Equipment arbitration (AC/dehumidifier) working
✅ Dew point control operational
✅ Historical data preserved in database

## Troubleshooting

### Check Logs
```bash
tail -f /home/drewcifer/mnt/homeassistant-config/home-assistant.log
```

### Database Issues
```bash
# Check database integrity
sqlite3 /home/drewcifer/mnt/homeassistant-config/data/home-assistant.db "PRAGMA integrity_check;"
```

### Configuration Issues
```bash
# Validate configuration
hass --config /home/drewcifer/mnt/homeassistant-config --check-config
```

---

**Migration Achievement**: 452MB storage recovery, root directory compliance achieved!