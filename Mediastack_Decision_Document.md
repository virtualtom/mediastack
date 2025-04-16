# Decision Document: MediaStack Dockerized Home Media Platform

## Purpose
To design and implement a new, standardized, and maintainable self-hosted media stack using Docker Compose. This project combines services for media acquisition, management, and streaming, including Calibre-Web, Plex, and the *arr suite.

## Project Overview
MediaStack is a fresh initiative to consolidate home media services into a unified, container-based environment. It leverages modern DevOps practices to support easy updates, scripting, volume management, and repeatable deployments across machines.

## Goals
- Deliver a fully containerized home media stack
- Ensure persistent configuration and media storage
- Centralize scripts and scheduled automation with per-container cron support
- Simplify redeployment with bootstrap automation
- Clearly separate and document shared vs. container-specific data

## Key Design Decisions

### 1. **Repository Name and Scope**
- **Name:** `mediastack`
- **Scope:** Includes media management (*arr), downloaders, Plex server, Calibre-Web for ebooks, and optional Guacamole for remote access
- **Rationale:** Reflects the broader role of the stack beyond *arr apps alone

### 2. **Directory Layout**
```
/opt/
├── arrstack/
│   ├── bazarr/
│   ├── jackett/
│   ├── lidarr/
│   ├── prowlarr/
│   ├── radarr/
│   ├── sonarr/
│   ├── downloads/     # shared download target
│   └── media/         # final media destination
└── calibre/
    ├── books/
    └── config/
```
- Shared folders (`downloads`, `media`) enable cross-container file access
- Each container has its own `config/` and `scripts/` directory

### 3. **Bootstrap Automation**
- Script: `bootstrap_docker_stack.sh`
- Handles Docker installation, repo clone, directory setup
- Auto-generates `.env` files for each container using correct PUID/PGID
- Ensures per-container isolation while allowing shared volumes

### 4. **Container Configuration**
- Each container has its own `docker-compose.yml` and local `.env`
- Uses common environment variables:
  ```
  PUID=120
  PGID=127
  TZ=America/New_York
  ```
- Volumes mount container-specific `config/`, `scripts/`, and shared `downloads`/`media` as needed

### 5. **Scheduled Task Support**
- Each container mounts a `/scripts` volume
- If needed, a `crontab.txt` file defines tasks inside the container
- Currently, only Calibre uses this feature (e.g., `calibre_watch.sh`)

### 6. **Calibre Enhancements**
- Uses `lscr.io/linuxserver/calibre-web:latest`
- Persistent `/opt/calibre/config/` for `app.db` and SMTP/auth settings
- `ebook-convert` binary included in the image

### 7. **Readme and Repo Docs**
- `README.md` details full stack structure, usage, and volume roles
- Setup scripts and `.env` generation included for reproducibility

## Deliverables
- Bootstrap and directory setup scripts
- Per-service folders and configuration volumes
- Docker Compose files and `.env` variables scoped per container
- Scripted automation framework via cron support
- Central README and decision document for maintainability

## Future Enhancements
- Expand cron tasks to other services
- Add monitoring or health check scripts
- Optional UI-based management (e.g., Portainer, Homer)

---
Project Owner: Tom Cronin  
Created: April 15, 2025
