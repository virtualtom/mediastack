# 📚 mediastack

This repository contains a modular, Docker Compose-based media stack built for self-hosted environments. It includes containerized applications for media management, streaming, and ebook library handling.

## ✅ Status

Only the **Calibre-Web** container is fully tested and confirmed to support:

- Scheduled import of ebooks
- Conversion of `.epub` to `.mobi`
- Integration with the Calibre database via `calibredb`
- Kindle-compatible workflows

## 🧰 Stack Layout

```
/opt/docker/mediastack/
├── calibre/           # Calibre-Web with cron-based import and conversion
├── plex/              # Plex Media Server
├── sonarr/            # TV show automation
├── radarr/            # Movie automation
├── jackett/           # Torrent indexer proxy
├── qbittorrent/       # BitTorrent client
├── guacamole/         # (Optional) Web-based remote desktop
├── scripts/           # (Optional) Shared rsync or cron scripts
└── setup_docker_dirs.sh  # Bootstrap script to set up structure
```

## 🕒 Calibre Watch Script

The `calibre_watch.sh` script, located in `calibre/scripts/`, monitors a directory named `/newbooks` **inside the container**, which is mounted to a host path defined in `docker-compose.yml`.

### Features:

- Watches `/newbooks` for `.epub` and `.mobi` files.
- Converts `.epub` files to `.mobi` using `ebook-convert` with Kindle Paperwhite 3 output profile.
- Adds `.mobi` books to the Calibre database using `calibredb`.
- Cleans up all processed files after conversion and import.

This ensures Kindle compatibility and prevents UTF-8 issues when emailing ebooks to Kindle devices.

> 🔧 Ensure the script is marked as executable:
```bash
chmod +x calibre/scripts/calibre_watch.sh
```

## 🧪 Testing Status

Only the **calibre** container is considered production-ready. All other containers are present and structured with consistent cron/script volume support but are pending validation.

## 📄 Project Documentation

- [Migration Instructions](calibre/MIGRATION.md) — How to migrate from a local Calibre-Web installation.
- [LICENSE](LICENSE) — MIT License.

## 🔐 Security Setup

Use SSH authentication for GitHub cloning to avoid credential prompts. If you're not already using SSH:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

Add the output to GitHub under **Settings → SSH and GPG Keys**.

## 🔒 Notes on Local User vs `dockeruser`

This stack supports running under any non-root user for permission and security reasons. You can customize the `.env` file per container to use your local user account (e.g., UID/GID for a service user).

> 🔁 If you're not using `dockeruser`, ensure that the user account running Docker has full read/write access to mounted config and library paths.

## 📜 License

This project is licensed under the MIT License.