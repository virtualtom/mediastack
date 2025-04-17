# MediaStack: Self-Hosted Media Automation Suite

This project provides a modular, containerized stack for automating media acquisition, management, and remote access using Docker Compose.

## Included Services

- **Plex**: Media server for streaming movies, TV, music, and photos
- **Calibre-Web**: Web-based interface for Calibre eBook library with conversion tools
- **Sonarr**: TV series collection manager
- **Radarr**: Movie collection manager
- **Lidarr**: Music collection manager
- **Readarr**: Audiobooks and eBooks management (optional)
- **Jackett**: Torrent indexer aggregator
- **qBittorrent**: Torrent client
- **Bazarr**: Subtitle management
- **Prowlarr**: Indexer manager and proxy
- **Apache Guacamole**: Web-based remote desktop gateway (optional)

All services are defined in individual Docker Compose files under `/opt/docker/mediastack/`.

## Folder Structure

```
/opt/docker/mediastack/
├── calibre/
│   ├── docker-compose.yml
│   ├── scripts/
│   └── MIGRATION.md
├── plex/
├── sonarr/
├── radarr/
├── lidarr/
├── jackett/
├── bazarr/
├── prowlarr/
├── qbittorrent/
├── guacamole/
└── setup_docker_dirs.sh
```

## Deployment

### 1. Install Docker and Docker Compose

Make sure your system has Docker and Docker Compose (v2) installed.

### 2. Clone This Repository

```bash
git clone git@github.com:youruser/mediastack.git /opt/docker/mediastack
```

> ⚠️ You may need to ensure `/opt/docker` is owned by the correct user/group (e.g., `sudo chown -R youruser:docker /opt/docker`).

### 3. Run the Bootstrap Script

```bash
cd /opt/docker/mediastack
sudo ./bootstrap_docker_stack.sh
```

This will:
- Create folder structures
- Generate per-container `.env` files
- Set permissions
- Optionally deploy containers

### 4. Start the Stack

Use Docker Compose in each service directory to build and run individual containers:

```bash
cd /opt/docker/mediastack/calibre
docker compose up -d --build
```

## Usage Notes

- `.env` files are located **within each container’s directory**
- Container ownership defaults to UID/GID of the user running the script
- Calibre-Web includes `ebook-convert` and `calibredb` support using a custom image built from [linuxserver/calibre-web](https://hub.docker.com/r/linuxserver/calibre-web)

## Custom Scripts and Cron Jobs

Each container includes:
- A `/scripts` volume for automation scripts
- Optional `crontab.txt` for scheduling

## Migrating Existing Calibre Library

See `calibre/MIGRATION.md` for migration steps.

## Notes on Local User vs `dockeruser`

You can choose to run containers as your local user (e.g., the user who owns `/plexmedia/books/Library`) or a dedicated `dockeruser`. If using your own user, ensure `.env` files reflect the correct UID and GID.

## Cleanup and Redeployment

See “Deployment” above to start fresh. You may retain `/opt/calibre/config` and `/opt/calibre/books` if you don’t want to lose your library.


## SSH Key Setup for GitHub (Optional)

If cloning via SSH, generate an SSH key and add it to your GitHub account:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub  # copy this to GitHub → Settings → SSH Keys
```

Then clone:

```bash
git clone git@github.com:youruser/mediastack.git
```
