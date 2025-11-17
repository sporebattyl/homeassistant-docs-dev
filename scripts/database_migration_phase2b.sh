#!/bin/bash

# Home Assistant Database Migration Script
# Moves database from root to /config/data/ directory
# Phase 2B of comprehensive cleanup

set -e  # Exit on any error

echo "=== HOME ASSISTANT DATABASE MIGRATION ==="
echo "Phase 2B: Database Cleanup"
echo "Estimated downtime: 2-3 minutes"
echo

# Configuration
DB_BACKUP_DIR="$HOME/backups/database_migration_$(date +%Y%m%d_%H%M%S)"
LIVE_CONFIG="/home/drewcifer/mnt/homeassistant-config"
DB_FILES="home-assistant_v2.db home-assistant_v2.db-shm home-assistant_v2.db-wal"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}WARNING: This will temporarily stop Home Assistant${NC}"
echo -e "${YELLOW}Make sure you have a maintenance window approved${NC}"
echo

read -p "Continue with database migration? (yes/no): " -r
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Migration cancelled."
    exit 1
fi

echo
echo "=== STEP 1: PRE-MIGRATION BACKUP ==="
mkdir -p "$DB_BACKUP_DIR"
echo "Creating backup in: $DB_BACKUP_DIR"

cd "$LIVE_CONFIG"
for db_file in $DB_FILES; do
    if [[ -f "$db_file" ]]; then
        cp "$db_file" "$DB_BACKUP_DIR/"
        echo "Backed up: $db_file ($(du -h "$db_file" | cut -f1))"
    fi
done

echo
echo "=== STEP 2: STOP HOME ASSISTANT ==="
echo "Stopping Home Assistant service..."
pkill -f "hass" || echo "HA process not found"

# Wait for HA to fully stop
echo "Waiting for Home Assistant to stop..."
sleep 10

# Verify HA is stopped
if pgrep -f "hass" > /dev/null; then
    echo -e "${RED}ERROR: Home Assistant is still running${NC}"
    echo "Please stop it manually and rerun this script"
    exit 1
fi

echo -e "${GREEN}✓ Home Assistant stopped successfully${NC}"

echo
echo "=== STEP 3: MIGRATE DATABASE FILES ==="
mkdir -p data

for db_file in $DB_FILES; do
    if [[ -f "$db_file" ]]; then
        size=$(du -h "$db_file" | cut -f1)
        echo "Moving $db_file ($size) to data/home-assistant.db"

        case "$db_file" in
            "home-assistant_v2.db")
                mv "$db_file" "data/home-assistant.db"
                ;;
            "home-assistant_v2.db-shm")
                mv "$db_file" "data/home-assistant.db-shm"
                ;;
            "home-assistant_v2.db-wal")
                mv "$db_file" "data/home-assistant.db-wal"
                ;;
        esac
    fi
done

echo -e "${GREEN}✓ Database files moved successfully${NC}"

echo
echo "=== STEP 4: VERIFY MIGRATION ==="
echo "Files in data directory:"
ls -lh data/ | grep -E "home-assistant"

echo
echo "Root directory cleanup:"
echo "Remaining database files in root: $(ls home-assistant_v2.db* 2>/dev/null | wc -l)"

echo
echo "=== STEP 5: START HOME ASSISTANT ==="
echo "Starting Home Assistant with new database location..."
cd "$LIVE_CONFIG"
hass --config "$LIVE_CONFIG" --daemon

echo "Waiting for Home Assistant to start..."
sleep 30

# Check if HA started successfully
if pgrep -f "hass" > /dev/null; then
    echo -e "${GREEN}✓ Home Assistant started successfully${NC}"
else
    echo -e "${RED}ERROR: Home Assistant failed to start${NC}"
    echo "Check logs: $LIVE_CONFIG/home-assistant.log"
    echo ""
    echo "To rollback:"
    echo "1. Stop Home Assistant"
    echo "2. Move files from $DB_BACKUP_DIR back to $LIVE_CONFIG"
    echo "3. Revert configuration changes"
    exit 1
fi

echo
echo "=== MIGRATION COMPLETE ==="
echo -e "${GREEN}✓ Database successfully moved to data/ directory${NC}"
echo -e "${GREEN}✓ Home Assistant is running${NC}"
echo -e "${GREEN}✓ Root directory cleanup: $(du -sh $DB_BACKUP_DIR | cut -f1) recovered${NC}"
echo
echo "Backup location: $DB_BACKUP_DIR"
echo "If issues occur, stop HA and restore from backup"
echo
echo "To verify everything is working:"
echo "1. Check Home Assistant web interface"
echo "2. Verify entity history is available"
echo "3. Check climate system functionality"