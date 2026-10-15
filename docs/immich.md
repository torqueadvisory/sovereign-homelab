# Immich — Photo Cloud

Self-hosted photo & video backup for the phones. Server + machine-learning + Postgres + Redis.

## Deploy

```bash
mkdir -p ~/immich-server && cd ~/immich-server
curl -L https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml -o docker-compose.yml
curl -L https://github.com/immich-app/immich/releases/latest/download/example.env -o .env
# set TZ + a strong DB_PASSWORD in .env, then:
docker compose up -d
```

Photo storage lives on the internal SSD (`./library`), backed up nightly to the external drive. Chosen over the external drive for *primary* storage specifically so the photos and their backup sit on two different physical disks.

## Create the admin account

Open `http://<MINI_TS_IP>:2283` and complete setup. Save the admin login to the vault.

## Phone backup (the real goal)

In the Immich mobile app → **Backup** → select the camera album(s) → enable background backup → **Start Backup**. Keep the app foregrounded on Wi-Fi for the first large push (Android throttles background uploads).

> **Gotcha:** the Immich app shows *local* device photos **and** *uploaded* photos together. Only uploaded ones appear on other devices / the web / the dashboard count. If the count is low, the backup hasn't actually run — select the album and start it. (The ops dashboard caught exactly this.)

## Safety rule

The prior photo backup and all phone originals stayed in place until Immich ran clean for several days **and** was in the nightly backup. Photos have no undo.
