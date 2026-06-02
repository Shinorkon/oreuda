#!/bin/bash
# Oreuda Database Backup Script
# Run via cron: 0 3 * * * /path/to/backup-db.sh

set -e

BACKUP_DIR="/var/backups/oreuda"
RETENTION_DAYS=30
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/oreuda_backup_$TIMESTAMP.sql"

# Load environment
if [ -f /root/.oreuda_env ]; then
    source /root/.oreuda_env
elif [ -f ../.env ]; then
    source ../.env
fi

mkdir -p "$BACKUP_DIR"

echo "[$(date)] Starting backup..."

# Extract DB name from DATABASE_URL
DB_NAME=$(echo "$DATABASE_URL" | sed 's/.*\/\([^\/]*\)$/\1/')

# pg_dump via docker
docker exec oreuda-db pg_dump -U postgres "$DB_NAME" > "$BACKUP_FILE"

gzip "$BACKUP_FILE"

# Cleanup old backups
find "$BACKUP_DIR" -name "oreuda_backup_*.sql.gz" -mtime +$RETENTION_DAYS -delete

echo "[$(date)] Backup complete: ${BACKUP_FILE}.gz"
