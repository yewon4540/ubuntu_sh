#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

echo "[$(date)] Cron started" >> /etc/nginx/renew/log/renew.log
echo "🔄 Starting certificate renewal..." >> /etc/nginx/renew/log/renew.log

docker run --rm \
  -v "/etc/nginx/ssl/etc/letsencrypt:/etc/letsencrypt" \
  -v "/etc/nginx/ssl/lib/letsencrypt:/var/lib/letsencrypt" \
  -e AWS_REGION=ap-northeast-2 \
  certbot/dns-route53 renew >> /etc/nginx/renew/log/renew.log 2>&1

if [ $? -eq 0 ]; then
  echo "✅ Renewal succeeded. Reloading Nginx..." >> /etc/nginx/renew/log/renew.log
  systemctl reload nginx
else
  echo "❌ Renewal failed. Skipping Nginx reload." >> /etc/nginx/renew/log/renew.log
fi

