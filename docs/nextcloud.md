# Nextcloud

Self-hosted files and sync — the owned replacement for Dropbox/Google Drive. Nextcloud app + MariaDB database, both in Docker.

## Deploy

```bash
cd ~/nextcloud-server
cp .env.example .env          # fill in strong random values
docker compose up -d
```

## Access

- Web/sync clients point at `https://command-center.<TAILNET>` (HTTPS via Tailscale Serve).
- Every device in the fleet runs the Nextcloud client (desktop sync, or mobile app) over Tailscale.
- **Trusted domains** must include every address you reach it by (localhost, LAN IP, Tailscale IP, MagicDNS name) — otherwise Nextcloud rejects the request. Set via `NEXTCLOUD_TRUSTED_DOMAINS` or:

```bash
docker compose exec --user www-data app \
  php occ config:system:set trusted_domains N --value=ADDRESS
```

## Notes

- Mobile apps don't render `.md` files — reference docs are kept as PDFs for phone reading.
- Device authorization: after adding a client, authorize it in the Nextcloud app on the server for immediate sync.
- Everything moved to HTTPS (`https://...`), not the old plain `:8080`, across the whole fleet for uniformity.
