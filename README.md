# 📦 MediaStack

A modular and automated Docker stack to manage all your media — including Plex, *arr apps (Sonarr, Radarr, Lidarr, etc.), and Calibre-Web — using persistent volumes, custom scripts, and cron jobs. Built for flexibility, easy redeployment, and consistent file permissions using `dockeruser`.

---

## 📁 Directory Structure

```
/opt/docker/mediastack/
├── calibre/                 # Calibre-Web container with ebook-convert support
├── arrstack/                # All *arr services + shared media + downloads
│   ├── jackett/
│   ├── sonarr/
│   ├── radarr/
│   ├── lidarr/
│   ├── prowlarr/
│   ├── qbittorrent/
│   ├── plex/
│   ├── bazarr/
│   ├── config/              # Shared config volume
│   ├── downloads/           # Shared download volume
│   └── media/               # Shared media (tv/movies)
├── setup_docker_dirs.sh     # Creates required directories + permissions
└── bootstrap_docker_stack.sh # Installs Docker, clones repo, runs setup
```

---

## 🚀 Deployment

> 💡 **Note:** The deployment assumes a user named `dockeruser` with group `docker` exists.  
> You can create one using:
> ```bash
> sudo useradd -m -s /bin/bash -G docker dockeruser
> ```

> 💡 **Tip:** Set the primary group for `dockeruser` to `docker` so that files cloned or created default to correct ownership:
> ```bash
> sudo usermod -g docker dockeruser
> ```

### Step-by-Step

1. **Log in as root** or a user with sudo access.

2. **Clone the repo to `/opt/docker/mediastack`**:
   ```bash
   sudo git clone git@github.com:virtualtom/mediastack.git /opt/docker/mediastack
   cd /opt/docker/mediastack
   ```

3. **Make the bootstrap script executable**:
   ```bash
   sudo chmod +x bootstrap_docker_stack.sh
   ```

4. **Run the bootstrap script** (this installs Docker if needed, pulls the repo, sets up .env files):
   ```bash
   sudo ./bootstrap_docker_stack.sh
   ```

5. **Start the containers**:
   ```bash
   cd /opt/docker/mediastack/calibre
   docker compose up -d

   cd /opt/docker/mediastack/arrstack
   docker compose up -d
   ```

---

## 🛠 Cleanup for Redeployment

To wipe a deployment clean while preserving Calibre:

```bash
# Optional: Save Calibre library and config
mv /opt/calibre /opt/calibre_backup

# Remove all stack data
sudo rm -rf /opt/docker/mediastack
sudo rm -rf /opt/arrstack

# Restore Calibre if needed
sudo mv /opt/calibre_backup /opt/calibre
```

Then see [Deployment](#-deployment) above to start fresh.

---

## ⚙️ Notes

- Each container has:
  - A `scripts/` folder for your automation
  - A `crontab.txt` for scheduled tasks
  - A shared `.env` file (copied per container) with `PUID`, `PGID`, and `TZ`

- Only the Calibre container includes an active cron job by default. Others have `crontab.txt` placeholders.

- You can schedule custom scripts by placing them in a container’s `scripts/` folder and editing its `crontab.txt`.

---

## 📄 License

MIT © 2025 VirtualTom
