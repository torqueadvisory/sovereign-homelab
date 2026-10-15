# Architecture

## The idea

One always-on server holds the data and runs the services. Every device reaches it over a private mesh VPN. Nothing is exposed to the public internet — the server is invisible unless you're on the mesh. This gives cloud-like access from anywhere with none of the rented infrastructure or third-party custody.

## Layers

**1. Hardware** — a Mac mini (24 GB RAM, 512 GB internal SSD, large external drive for backups) running 24/7. Low power, silent, enough headroom to host everything a household needs for years.

**2. Containers** — every service runs in Docker, so each is isolated, reproducible, and restarts on reboot (`--restart unless-stopped`). The whole stack is defined in config, not clicked together by hand.

**3. Network** — [Tailscale](https://tailscale.com), a WireGuard-based mesh. Each device authenticates once and gets a stable private IP on the tailnet. MagicDNS gives the server a friendly name. There are **no port forwards and no public exposure** — the only way to reach a service is to be an authenticated device on the mesh. Tailscale off ⇒ the server does not exist to the outside world.

**4. Encryption** — Tailscale encrypts all transport (WireGuard). On top of that, services that front a browser get HTTPS via **Tailscale Serve**, so there's a real padlock end to end.

**5. Observability** — a [Homepage](https://gethomepage.dev) dashboard reads live container status from the Docker socket and host metrics from [Glances](https://nicolargo.github.io/glances/), presenting the whole stack on one screen.

## Data flow (photo backup example)

```
Phone camera roll
      │  (Immich app, auto-backup, over Tailscale)
      ▼
Immich server on the mini  ──writes──►  internal SSD (library)
      │                                      │
      │                               nightly backup (2am)
      ▼                                      ▼
Homepage dashboard tile              external drive (second copy)
(live photo count)
```

## Design principles

- **Own the data.** If it's irreplaceable, it lives on hardware I control, with a second copy.
- **Private by default.** No public attack surface. Access is an authenticated mesh, not an open port.
- **Reproducible.** Configs in version control (secrets excluded). A dead disk means a rebuild, not a loss.
- **Prove before you trust.** New services run alongside the old solution until verified and backed up — only then is the old one retired.
