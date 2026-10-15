# Homepage — Live Operations Dashboard

The "NOC wall." A single screen showing every self-hosted service with live status, plus host system metrics (CPU, memory, network throughput, disk usage, disk I/O) streamed from Glances. Each service tile is both a live status light and a one-click link into that service.

See [`../docs/dashboard.md`](../docs/dashboard.md) for the full build writeup.

## Run it

```bash
docker run -d \
  --name homepage \
  --restart unless-stopped \
  -p 3000:3000 \
  -e HOMEPAGE_ALLOWED_HOSTS=<MINI_TS_IP>:3000,command-center.<TAILNET>:3000,localhost:3000 \
  -v ~/homepage/config:/app/config \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  ghcr.io/gethomepage/homepage:latest
```

## Config files (`config/`)

| File | Purpose |
|---|---|
| `settings.yaml` | title, theme, grid layout |
| `services.yaml` | the tiles — services + system metric panels (copy from `.example`) |
| `widgets.yaml` | header strip — clock, weather, search |
| `docker.yaml` | Docker socket connection for live status |

> The real `services.yaml` holds API keys/tokens and is `.gitignore`'d. Use `services.yaml.example` as the template.

## Live host metrics require Glances

The System panels read from [Glances](https://nicolargo.github.io/glances/) running **natively on the host** (not in a container — a container would only see the Docker VM, not the real hardware). See [`../glances/`](../glances/) for the auto-start LaunchAgent.
