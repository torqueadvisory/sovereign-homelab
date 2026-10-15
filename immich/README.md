# Immich — Self-Hosted Photo Cloud

Replaces Google Photos / Dropbox for phone media. Multi-container (server, machine-learning, Postgres, Redis). Phones auto-back-up their camera rolls to the mini over Tailscale; nothing irreplaceable leaves hardware you own.

Immich maintains its **own** `docker-compose.yml` that changes per release, so this repo does **not** vendor a copy — pull the official one and drop the sanitized `.env` beside it.

```bash
mkdir -p ~/immich-server && cd ~/immich-server
curl -L https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml -o docker-compose.yml
curl -L https://github.com/immich-app/immich/releases/latest/download/example.env -o .env
# edit .env (TZ, strong DB_PASSWORD), then:
docker compose up -d
```

Full writeup: [`../docs/immich.md`](../docs/immich.md).

**Safety rule that shipped with this build:** the previous photo backup (and all phone originals) stayed in place until Immich ran clean for several days *and* was folded into the nightly backup. Photos are the one thing with no undo.
