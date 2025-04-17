# mediastack

A modular Docker-based media server stack. This repo includes individual containers for apps like Plex, Calibre-Web, Sonarr, Radarr, and more. Each container is configured with optional cron job support and script automation.

## 📦 Included Services

- **Plex** – Media streaming server
- **Calibre-Web** – eBook server with conversion support
- **Sonarr** – TV series management
- **Radarr** – Movie management
- **Lidarr** – Music management
- **Bazarr** – Subtitles
- **qBittorrent** – Torrent client
- **Jackett** – Torrent indexer proxy
- **Prowlarr** – Indexer management
- **Guacamole** – (Optional) web-based remote desktop gateway

## 🧰 Deployment

```bash
git clone git@github.com:<your-username>/mediastack.git /opt/docker/mediastack
cd /opt/docker/mediastack
sudo chown -R <local-user>:docker /opt/docker
sudo chmod +x bootstrap_docker_stack.sh
sudo ./bootstrap_docker_stack.sh
```

For details about using a local user vs creating a dedicated `dockeruser`, see the section below.

## 📄 Migration Guides

- [Calibre Migration Guide](calibre/MIGRATION.md)

## 🔐 SSH Key Setup (Optional for Private Repos)

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub
# Add this key to GitHub SSH settings
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

## 👤 Notes on Local User vs `dockeruser`

This repo defaults to using a local user (e.g., the one who owns `/plexmedia/books/Library`) to simplify permissions when accessing existing data. If using a `dockeruser`, update `.env` and file ownerships accordingly.

## 🧹 Cleanup for Redeployment

To reset your environment while keeping config or media files:

```bash
docker compose down
sudo rm -rf /opt/docker/mediastack/*
sudo chown -R <local-user>:docker /opt/docker
```

If you want to preserve Calibre configs and books:

- Do NOT delete `/opt/calibre/config` or `/plexmedia/books/Library`

Then re-run the bootstrap:

```bash
cd /opt/docker/mediastack
sudo ./bootstrap_docker_stack.sh
```

## 📄 License

MIT – see LICENSE
