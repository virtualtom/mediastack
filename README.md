
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
