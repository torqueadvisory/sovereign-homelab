# Gotchas & Lessons Learned

Real problems hit during the build, and the fixes. This is the part that proves the stack was actually deployed and operated, not copied from a guide.

## Docker can't pull images over SSH — "keychain cannot be accessed"

Running `docker compose up` from an SSH/Mosh session failed before pulling anything:
```
error getting credentials ... keychain cannot be accessed because the current
session does not allow user interaction. The keychain may be locked...
```
Docker Desktop on macOS stores registry credentials in the **login keychain**, which is locked in a non-interactive remote session. Unlock it first:
```bash
security -v unlock-keychain ~/Library/Keychains/login.keychain-db
```
Then the pull succeeds. (The images are public; it's the credential *helper* that trips, not auth.)

## `df -h /` never shows freed space on macOS

After deleting ~29 GB, free space didn't move. The `/` filesystem on modern macOS is a **sealed, read-only system snapshot** (`/dev/diskXsYsZ`) whose numbers never change. Check the real data volume instead:
```bash
df -h /System/Volumes/Data
```

## Deleted files still don't free space — APFS local snapshots

Even on the data volume, freed space stayed pinned. Time Machine keeps **hourly local snapshots** that hold deleted blocks as "purgeable." Thin them to actually release the space:
```bash
tmutil listlocalsnapshots /
sudo tmutil thinlocalsnapshots / 999999999999 4
```

## Nextcloud rejects dashboard widget requests — trusted domains

The Homepage Nextcloud widget failed when pointed at `host.docker.internal`. Nextcloud enforces a **trusted domains** allowlist. Fix: point the widget at an already-trusted address (the Tailscale IP), or add the host to `trusted_domains`.

## Homepage returns a host-validation error

Recent Homepage versions require `HOMEPAGE_ALLOWED_HOSTS` to list every `host:port` the board is loaded from, or it refuses to render. Set it on the container env.

## Glances in a container shows the wrong numbers

A Glances container on Docker Desktop for Mac reports the **Linux VM's** resources, not the Mac's. For real host metrics (actual disk, real network interface), Glances must run **natively on macOS** (Homebrew) and Homepage reads it over the host.

## iOS Shortcuts linkifies terminal commands into URLs

Building a one-tap launcher in the Shortcuts app, the command text kept auto-converting to a URL. Blink Shell on that version also didn't expose a "run command" action to Shortcuts at all. Resolution: Mosh + tmux keep the session alive, so simply reopening the Blink app returns to the live session — the launcher wasn't needed.

## Immich "shows photos on the phone but nowhere else"

The Immich app displays local device photos **and** server-uploaded photos together. Only uploaded photos appear elsewhere. A low count on the web/dashboard means backup never ran — select the album in the app and start it.
