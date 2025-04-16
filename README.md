# arrstack

Containerized media stack with Calibre-Web, Plex, and all your favorite *arrs.

## Structure

```
/opt/docker/
├── arrstack/
│   ├── plex/
│   ├── sonarr/
│   ├── radarr/
│   ├── jackett/
│   ├── qbittorrent/
│   ├── guacamole/
│   └── setup_docker_dirs.sh
├── calibre/
│   ├── docker-compose.yml
│   └── scripts/
│       ├── calibre_watch.sh
│       └── crontab.txt
```

## Setup

- Set `PUID`, `PGID`, and `TZ` in your `.env` file.
- Run `setup_docker_dirs.sh` to create needed folders.
- Start with `docker-compose up -d`.
