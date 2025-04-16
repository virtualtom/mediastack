#!/bin/bash

# Create standard shared directories
mkdir -p /opt/arrstack/{downloads,media}

# Create per-container config and scripts directories
for service in bazarr jackett lidarr prowlarr radarr sonarr; do
  mkdir -p /opt/arrstack/$service/{config,scripts}
done
