#!/bin/bash
# ─────────────────────────────────────────────────────────────
#  Nightly backup — CommandCenter  (SANITIZED TEMPLATE)
#  Runs via a macOS LaunchAgent at 2am. Copies live data to a
#  separate physical drive so a single disk failure never wipes it.
#
#  Edit the paths below for your setup. Add Immich (library + a DB
#  dump) here before retiring any external photo backup.
# ─────────────────────────────────────────────────────────────
set -euo pipefail

STAMP="$(date +%Y-%m-%d)"
DEST="/Volumes/<EXTERNAL_DRIVE_NAME>/commandcenter-backups/${STAMP}"
mkdir -p "${DEST}"

# --- Nextcloud (data volume + database dump) ---
NC_DIR="${HOME}/nextcloud-server"
docker compose -f "${NC_DIR}/docker-compose.yml" exec -T db \
  mysqldump -u root -p"${MYSQL_ROOT_PASSWORD}" nextcloud > "${DEST}/nextcloud-db.sql"
# rsync the Nextcloud data volume / mounted files here as needed.

# --- Immich (library + database dump) ---  # enable once proven + before dropping external backup
# IMM_DIR="${HOME}/immich-server"
# rsync -a "${IMM_DIR}/library/" "${DEST}/immich-library/"
# docker compose -f "${IMM_DIR}/docker-compose.yml" exec -T database \
#   pg_dump -U postgres immich > "${DEST}/immich-db.sql"

# --- Vaultwarden (data dir) ---
# rsync -a "${HOME}/vaultwarden/data/" "${DEST}/vaultwarden/"

echo "Backup complete -> ${DEST}"
