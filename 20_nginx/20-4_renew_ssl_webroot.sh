#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

LOG_FILE="/etc/nginx/renew/log/renew_webroot.log"
WEBROOT_PATH="/usr/share/nginx/html"

echo "[$(date)] Cron started (webroot)" >> "$LOG_FILE"
echo "🔄 Starting certificate renewal (webroot)..." >> "$LOG_FILE"

docker run --rm \
  -v "/etc/nginx/ssl/etc/letsencrypt:/etc/letsencrypt" \
  -v "/etc/nginx/ssl/lib/letsencrypt:/var/lib/letsencrypt" \
  -v "$WEBROOT_PATH:$WEBROOT_PATH" \
  certbot/certbot renew >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
  echo "✅ Renewal succeeded (webroot). Reloading Nginx..." >> "$LOG_FILE"
  systemctl reload nginx
else
  echo "❌ Renewal failed (webroot). Skipping Nginx reload." >> "$LOG_FILE"
fi

