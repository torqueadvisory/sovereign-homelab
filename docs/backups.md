# Backups

The thing that turns a toy into real infrastructure.

## Strategy

- **Live data on the internal SSD, a second copy on a separate physical drive.** Two disks, two copies — a single drive failure never loses anything.
- **Nightly, automated.** A `backup.sh` script runs at 2am via a macOS LaunchAgent (`launchd`), so it happens whether or not anyone remembers.
- **Covers:** Nextcloud (data + a MariaDB dump), Vaultwarden (data dir), and Immich (library + a Postgres dump) once it's folded in.

## Toward 3-2-1

The standard: **3** copies, **2** media types, **1** offsite. Current state is two copies on two local disks. The next hardening step is an offsite copy of the irreplaceable data (photos, vault) — the one gap left before fully retiring any external photo backup.

## Script

See [`../scripts/backup.sh`](../scripts/backup.sh) (sanitized template). Fill in the destination drive and database passwords (from `.env`, never committed), and enable the Immich block once Immich is proven stable.

## The rule that governs new services

A new service does not become the *only* copy of anything until it has run clean for several days **and** is included in the nightly backup. Only then is the previous solution retired.
