#!/bin/bash
# Creates initial config/scripts directories for all containers

containers=(plex sonarr radarr jackett qbittorrent guacamole)

for name in "${containers[@]}"; do
  mkdir -p "/opt/docker/arrstack/$name/config"
  mkdir -p "/opt/docker/arrstack/$name/scripts"
done

mkdir -p "/opt/docker/calibre/config"
mkdir -p "/opt/docker/calibre/scripts"
