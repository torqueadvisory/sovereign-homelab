# Operations Dashboard (Homepage + Glances)

A single-screen "NOC wall" showing the whole stack live: every service with a status light and one-click link, plus host system metrics as live graphs. Designed from a hand sketch of a mission-control grid.

## Components

- **[Homepage](https://gethomepage.dev)** — the dashboard UI, in Docker. Reads container status from the Docker socket and pulls service data (Immich photo counts, Nextcloud free space) and host metrics (from Glances) into tiles.
- **[Glances](https://nicolargo.github.io/glances/)** — a system monitor running **natively on the macOS host** (via Homebrew), serving metrics on `:61208`. It must run on the host, not in a container: a container would only report the Docker VM's resources, not the real Mac hardware.

## The grid

- **Services row:** Nextcloud, Immich, Vaultwarden, Job Dashboard — live status + data
- **System grid (square):** CPU · Memory · Network ↑↓ · Internal SSD · External Drive · Disk I/O — live graphs
- **Header:** clock, local weather, search

## Build

1. **Glances** on the host:
   ```bash
   brew install glances
   ```
   Keep it alive across reboots with the LaunchAgent in [`../glances/`](../glances/):
   ```bash
   cp glances/com.user.glances.plist ~/Library/LaunchAgents/
   launchctl load ~/Library/LaunchAgents/com.user.glances.plist
   ```

2. **Homepage** container — see [`../homepage/README.md`](../homepage/README.md). Config files in [`../homepage/config/`](../homepage/config/).

## Config notes

- Container names for the status dots come from `docker ps` (e.g. `nextcloud-server-app-1`, `immich_server`).
- Widget URLs reach the host from inside the container via `host.docker.internal`; the Nextcloud widget uses the Tailscale IP instead to satisfy Nextcloud's trusted-domain check.
- The Glances widgets use `version: 4` (Glances 4.x API). The network metric needs the host's active interface — find it with `route get default | awk '/interface/{print $2}'`.
- `HOMEPAGE_ALLOWED_HOSTS` must list every host:port you load the board from, or Homepage returns a host-validation error.
