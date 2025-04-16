# mediastack

This repository sets up a self-hosted media stack using Docker Compose. It includes:

- Plex Media Server
- Calibre-Web with ebook-convert support
- Sonarr, Radarr, Lidarr, Bazarr
- Jackett and Prowlarr for indexers
- qBittorrent for torrent downloads
- (Optional) Guacamole for web-based remote desktop access

## 📁 Folder Structure

```
/opt/
└── arrstack/
    ├── bazarr/
    │   ├── config/
    │   └── scripts/
    ├── jackett/
    ├── lidarr/
    ├── prowlarr/
    ├── radarr/
    ├── sonarr/
    ├── downloads/     # shared download target
    └── media/         # shared media library
/opt/calibre/
├── books/
└── config/
```

## 🛠 Usage

Clone the repo and run the bootstrap script:

```bash
git clone git@github.com:virtualtom/mediastack.git /opt/docker/mediastack
cd /opt/docker/mediastack
sudo ./bootstrap_docker_stack.sh
```

## 🔁 Environment Variables

Each service's `docker-compose.yml` uses a `.env` file in the same directory to define:

```env
PUID=120
PGID=127
TZ=America/New_York
```

These are generated automatically during bootstrap.

## 🔄 Shared Directories

- `/opt/arrstack/downloads`: Shared in-progress download target for *arr apps and qBittorrent
- `/opt/arrstack/media`: Final media library location used by apps like Plex, Sonarr, Radarr, etc.

## 📦 Repository

Your GitHub repo:

👉 [https://github.com/virtualtom/mediastack](https://github.com/virtualtom/mediastack)
