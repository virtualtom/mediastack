#!/bin/bash

echo "✅ [entrypoint.sh] Entrypoint script has started"

# Setup cron job if crontab.txt exists
if [[ -f /scripts/crontab.txt ]]; then
    echo "📅 Installing cron job..."
    crontab /scripts/crontab.txt
else
    echo "⚠️ No crontab.txt found. Skipping cron setup."
fi

# Execute the main container startup command
echo "🚀 Starting Calibre-Web..."
exec /init
