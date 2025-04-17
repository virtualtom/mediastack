# Mediastack Deployment

A containerized media automation stack including:
- **Calibre-Web** for ebook management
- Plex, Sonarr, Radarr, Jackett, qBittorrent, etc. (scaffolding included but untested)
- Cron/script support in every container
- Centralized directory structure with dynamic bootstrap setup

> ✅ **Calibre container has been fully tested and is production ready. The others are scaffolded and untested.**

---

## Project Structure

```
/opt/docker/mediastack/
├── calibre/             # Calibre-Web container
│   ├── config/          # Calibre config including app.db
│   ├── books/           # Library of ebooks (persistent)
│   ├── scripts/         # Custom cron-enabled scripts
│   └── docker-compose.yml
├── arrstack/            # Other media containers (scaffolded)
│   ├── plex/
│   ├── sonarr/
│   ├── radarr/
│   ├── jackett/
│   ├── lidarr/
│   ├── prowlarr/
│   ├── qbittorrent/
│   └── ... (each has docker-compose.yml and optional scripts)
├── bootstrap_docker_stack.sh
├── setup_docker_dirs.sh
└── .gitignore
```

---

## Deployment Instructions

### Requirements

- Docker & Docker Compose
- Git (SSH preferred)

---

### 1. Prepare `/opt/docker`

```bash
sudo mkdir -p /opt/docker
sudo chown <your-local-user>:<your-local-group> /opt/docker
cd /opt/docker
```

### 2. Clone the Repository via SSH

```bash
git clone git@github.com:yourusername/mediastack.git
```

> 💡 If you use SSH keys:
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

---

### 3. Bootstrap the Stack

```bash
cd mediastack
chmod +x bootstrap_docker_stack.sh
sudo ./bootstrap_docker_stack.sh
```

- Creates directory structure
- Populates `.env` in each service folder
- Preps empty cron schedules (except Calibre)

---

## Clean Deployment (Re-deploy)

To fully clean your test/dev machine before a redeploy:

```bash
docker compose down -v  # From each docker-compose directory
sudo rm -rf /opt/docker/mediastack
sudo rm -rf /opt/arrstack
```

To preserve only Calibre's config and books:
```bash
# Remove everything except:
sudo rm -rf /opt/docker/mediastack/arrstack
```

Then redeploy using the standard bootstrap and compose instructions.

---

## Notes on Local User vs `dockeruser`

This stack is configured to allow flexible UID/GID via `.env` files in each service directory.

- You may run the stack as your local user if your media folders are owned by it.
- Or, you can create a dedicated `dockeruser` and use `chown` to transfer ownership of `/opt/docker`.

---

## Making Repo Public

This README is now ready for use in a public GitHub repo. All secrets (e.g. app passwords) should be provided via environment variables or `.env` files and **not committed to source control**.

---

## GitHub SSH Setup (Reusable Snippet)

```bash
# Generate SSH key if you haven't
ssh-keygen -t ed25519 -C "your_email@example.com"

# Start ssh-agent and add your key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Add public key to GitHub:
cat ~/.ssh/id_ed25519.pub
```
