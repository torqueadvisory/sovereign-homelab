# Remote Access

## Tailscale mesh

Every device runs Tailscale signed into the same account, joining one private tailnet. The server gets a stable `100.x` IP and a MagicDNS name. No port forwarding, no dynamic DNS, no public exposure. Device authorization is required before a new device can join.

- Server reachable at `https://command-center.<TAILNET>` (and `:8443`, `:9443`, `:2283` for the other services).
- **Tailscale off = server invisible.** Verified by test: with Tailscale disabled, every address is unreachable; enabled, access is instant.

## One-tap terminal (Mosh + tmux)

A single tap on any device drops straight into a persistent shell on the server.

- **[Mosh](https://mosh.org/)** — survives network drops and roaming (phone changing Wi-Fi/cell), unlike raw SSH.
- **[tmux](https://github.com/tmux/tmux)** — a persistent session named `main` on the server. Detach, disconnect, reconnect from a different device — same live session.
- **ed25519 SSH keys** — keyless auth; the public key is added to the server's `~/.ssh/authorized_keys`.

The reconnect command (also what the one-tap launchers run):
```bash
mosh <user>@<MINI_TS_IP> -- tmux new -A -s main
```
`tmux new -A -s main` attaches to `main` if it exists, else creates it.

### Per-platform launchers

| Device | How |
|---|---|
| Android (S26, Fold, A16) | Termux + Termux:Widget → a one-tap home-screen script running the Mosh+tmux command |
| iPad | [Blink Shell](https://blink.sh) with a saved host; the Blink app icon reopens straight into the live session (Mosh keeps it alive). Keyless after adding the iPad's public key to the server. |
| Macs | Terminal / iTerm with the same command |

> **macOS keychain note:** running `docker` over an SSH/Mosh session can fail to pull images because the login keychain (where Docker stores registry creds) is locked in a non-interactive session. Unlock it first — see [`gotchas.md`](gotchas.md).
