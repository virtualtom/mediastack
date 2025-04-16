# arrstack

A modular, containerized media server stack powered by Docker Compose — featuring Plex, Calibre-Web, and all your favorite *arr* apps.

This setup includes optional cron script support per container, automatic directory structure creation, and environment-based configuration.

---

## 🧱 Directory Structure

```
arrstack/
├── plex/
├── sonarr/
├── radarr/
├── jackett/
├── qbittorrent/
├── guacamole/
│   └── docker-compose.yml
│   └── scripts/
│       └── crontab.txt
├── setup_docker_dirs.sh
calibre/
├── docker-compose.yml
├── scripts/
│   ├── calibre_watch.sh
│   └── crontab.txt
bootstrap_docker_stack.sh
.env
README.md
```

---

## 🚀 Getting Started

### 1. Clone the repo (or unpack it)

```bash
git clone git@github.com:virtualtom/arrstack.git
cd arrstack
```

### 2. Create your `.env` file

Set your runtime user, group, and timezone:

```env
PUID=120
PGID=127
TZ=America/New_York
```

### 3. Bootstrap folder structure (optional)

```bash
sudo ./bootstrap_docker_stack.sh
```

This will:
- Install Docker and Compose (if needed)
- Clone the repo (if not already done)
- Run `setup_docker_dirs.sh` to make all necessary folders

---

## 🐳 Containers

| App          | Purpose                     | Port   |
|--------------|-----------------------------|--------|
| **Plex**     | Media streaming             | 32400  |
| **Sonarr**   | TV automation               | 8989   |
| **Radarr**   | Movie automation            | 7878   |
| **Jackett**  | Torrent indexer proxy       | 9117   |
| **qBittorrent** | BitTorrent client        | 8080   |
| **Guacamole** | Remote desktop via browser | 8081   |
| **Calibre-Web** | Ebook library & convert support | 8083   |

---

## 🕒 Cron and Script Support

Each container includes a `scripts/` directory with an optional `crontab.txt` file.

- Cron jobs will be loaded when the container starts
- You can add shell scripts to `scripts/` and reference them in the `crontab.txt`

Example `calibre/scripts/crontab.txt`:
```cron
*/5 * * * * /scripts/calibre_watch.sh >> /config/cron.log 2>&1
```

---

## 📚 Calibre Support

The `calibre-web` container has ebook conversion support via `ebook-convert` and mounts `/books` as its media library.

To import new books, drop them in a watched folder or automate with the provided script:
```bash
calibre/scripts/calibre_watch.sh
```

---

## 🙌 Credits

- Based on community-maintained `lscr.io/linuxserver/*` images
- Structure inspired by best practices for modular Docker deployments
- Customized by [@virtualtom](https://github.com/virtualtom)

---

## 🛟 Need Help?

Feel free to open issues or request enhancements — this stack is designed to be modular and extensible.
