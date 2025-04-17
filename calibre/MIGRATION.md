# Calibre Migration to Docker

This document guides you through migrating an existing local install of Calibre-Web to the Docker container provided in this repo. The container includes Calibre utilities like `ebook-convert` and `calibredb` for full functionality.

## 🧭 Assumptions

- You've already cloned this repo: `git clone git@github.com:<your-username>/mediastack.git`
- You're running on a Linux host.
- You have an existing Calibre library and database (e.g., `/plexmedia/books/Library`).
- You will run the container using the same user who owns the Calibre data to avoid permission issues.
- You understand this is a custom Docker image built from `lscr.io/linuxserver/calibre-web:latest`.

## 📂 Folder Expectations

- Existing Calibre library: `/your/path/to/books/Library`
- Calibre config folder (existing app.db): `/opt/calibre/config`
- Script-monitored drop folder: `/mnt/calibre/newbooks`

Make sure these paths are readable/writable by the user the container will run as.

## 📦 Deploy the Container

```bash
cd /opt/docker/mediastack/calibre
docker compose build
docker compose up -d
```

This builds a custom image with Calibre installed and sets up cron support for the watch script.

## 🔁 Migrate the Database

Copy your `app.db` file into the config volume:

```bash
cp /your/local/path/to/app.db /opt/calibre/config/
```

Then restart the container:

```bash
docker compose restart
```

## 📜 Confirm Cron and Scripts

- `scripts/calibre_watch.sh` – runs every 5 minutes via `crontab.txt`
- The script looks for new EPUB or MOBI files in `/mnt/calibre/newbooks`
- Converts EPUB to MOBI (Kindle-compatible) using output profile `kindle_pw3`
- Uses `calibredb add` to import into `/plexmedia/books/Library`

## 🧪 Test the Setup

```bash
docker exec -it calibre-web which ebook-convert
docker exec -it calibre-web crontab -l
docker exec -it calibre-web bash -c "/scripts/calibre_watch.sh"
```

## ✅ Success Checklist

- [ ] Container builds successfully
- [ ] Web UI works on port 8083
- [ ] `ebook-convert` and `calibredb` are available
- [ ] Cron is installed and running
- [ ] `/newbooks` is correctly mounted
- [ ] Metadata and format conversion works
