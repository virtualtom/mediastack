#!/bin/bash

DOCKER_USER="dockeruser"
DOCKER_GROUP="docker"

# Create media directories shared by multiple containers
mkdir -p /opt/arrstack/media/movies
mkdir -p /opt/arrstack/media/tv
mkdir -p /opt/arrstack/downloads
mkdir -p /opt/arrstack/config

# Create container-specific directories
for service in jackett sonarr radarr lidarr prowlarr qbittorrent plex bazarr; do
  mkdir -p /opt/arrstack/$service/config
  mkdir -p /opt/arrstack/$service/scripts
  mkdir -p /opt/arrstack/$service/logs
done

# Fix ownership recursively
chown -R $DOCKER_USER:$DOCKER_GROUP /opt/arrstack
