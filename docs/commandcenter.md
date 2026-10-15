# CommandCenter — Server Reference

The operating manual for the server. **No secrets here** — credentials live in the password manager only.

## The server

- **Name:** CommandCenter (Mac mini, 24 GB RAM, 512 GB SSD, on 24/7)
- **Stack:** Docker + Docker Compose
- **Services:** Nextcloud + MariaDB, Immich (+ Postgres + Redis), Vaultwarden, Homepage, Glances, a static job-tracker dashboard

## How to reach it

| From | Address |
|---|---|
| On the mini itself | `http://localhost:<port>` |
| On home Wi-Fi | `http://<lan-ip>:<port>` |
| Anywhere (Tailscale) | `https://command-center.<TAILNET>` (HTTPS via Tailscale Serve) |

Rule of thumb: use the Tailscale address on every device except the mini — it works at home and away. Tailscale must be ON.

## Ports

| Service | Internal port | Tailscale Serve (HTTPS) |
|---|---|---|
| Nextcloud | 8080 | 443 |
| Vaultwarden | 8081 | 8443 |
| Job Dashboard | 8082 | 9443 |
| Immich | 2283 | 2283 |
| Homepage | 3000 | (dashboard, local display) |
| Glances | 61208 | (internal metrics feed) |

## Common commands

```bash
# What's running
docker ps --format '{{.Names}}\t{{.Ports}}'

# Start / stop a stack (from its compose dir)
docker compose up -d
docker compose down

# Logs
docker compose logs <service>

# Tailscale Serve (HTTPS reverse proxy for a service)
/opt/homebrew/bin/tailscale serve --bg --https=<PORT> http://localhost:<INTERNAL_PORT>
```

## Credentials — where they live (not the values)

All stored in the self-hosted Vaultwarden vault:
- Nextcloud admin login
- MariaDB root password, Nextcloud DB password
- Immich admin login, Immich DB password, Immich API key
- Nextcloud app password (for the dashboard widget)
- Mac host login password
- Tailscale account

## Security status

- Server hidden behind Tailscale — no public exposure, perimeter tested (off = invisible)
- Strong random database passwords
- HTTPS on browser-facing services via Tailscale Serve
- Nightly backups to a separate physical drive
