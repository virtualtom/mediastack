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

---

## 🧼 Cleanup & Redeployment Instructions

If you need to **start fresh** but want to preserve data/configs for specific containers like `calibre`, follow these steps:

### 🔄 Redeploying with Preserved Configs

1. **Stop all containers**:
   ```bash
   docker compose down
   ```

2. **Remove container folders but keep config/data folders**:
   ```bash
   sudo rm -rf /opt/docker/mediastack/*
   ```

   > Keep specific folders you want to preserve, such as:
   > ```
   > /opt/docker/calibre/books
   > /opt/docker/calibre/config
   > ```

3. **Ensure ownership is preserved**:
   ```bash
   sudo chown -R dockeruser:docker /opt/docker
   ```

4. **Clone the repository again**:
   ```bash
   sudo -u dockeruser git clone git@github.com:virtualtom/mediastack.git /opt/docker/mediastack
   ```

5. **Run the bootstrap script**:
   ```bash
   cd /opt/docker/mediastack
   sudo bash bootstrap_docker_stack.sh
   ```

---


## 🧠 Deployment Notes

### 🧰 If Cloning the Repo Manually First

Before running the bootstrap script, ensure `/opt/docker` is owned by `dockeruser:docker`:

```bash
sudo mkdir -p /opt/docker
sudo chown dockeruser:docker /opt/docker
```

Clone the repository as `dockeruser`:
```bash
sudo -u dockeruser git clone git@github.com:virtualtom/mediastack.git /opt/docker/mediastack
```

### 📄 .env Files and Permissions

The `bootstrap_docker_stack.sh` script will:
- Pull or clone the repository
- Run the directory setup script
- Generate a `.env` file in each container directory (next to its `docker-compose.yml`)
- Populate each with correct values using `dockeruser`'s UID/GID
- Set correct ownership on everything to `dockeruser:docker`

### 🚀 Running the Bootstrap Script Properly

1. Make the script executable:
   ```bash
   chmod +x bootstrap_docker_stack.sh
   ```

2. Run the script **as dockeruser**:
   ```bash
   sudo -u dockeruser ./bootstrap_docker_stack.sh
   ```

✅ This ensures all folders and files are created with the correct ownership.

🚫 Do not run:
```bash
sudo bash bootstrap_docker_stack.sh
```
> That runs the script as `root` and causes folder ownership issues that will break container access to volumes.

### 🧰 If Cloning the Repo Manually First

- Make sure `/opt/docker` is owned by `dockeruser:docker` before cloning:
  ```bash
  sudo mkdir -p /opt/docker
  sudo chown dockeruser:docker /opt/docker
  ```

- Clone as `dockeruser`:
  ```bash
  sudo -u dockeruser git clone git@github.com:virtualtom/mediastack.git /opt/docker/mediastack
  ```

### 📄 .env Files and Permissions

- The bootstrap script will:
  - Clone the repo or pull latest
  - Run the directory setup script
  - Generate `.env` files for each service using `dockeruser` UID/GID
  - Set all ownership to `dockeruser:docker`

---

## 🧠 Preserving Configs Between Deployments

All containers store persistent data in a `config` folder. To retain settings such as logins, SMTP, UI settings:

- **Do not delete the container's config folder**
- **Ensure correct permissions:**
  ```bash
  sudo chown -R dockeruser:docker /opt/docker/[container]/config
  ```

This applies to:
- `calibre` → `/opt/docker/calibre/config`
- `plex` → `/opt/docker/mediastack/plex/config`
- `sonarr`, `radarr`, `lidarr`, etc → their respective config folders
