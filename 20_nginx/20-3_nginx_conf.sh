#!/bin/bash

# 사용자 입력값 확인
INPUT_DOMAIN="$1"
SSL_PATH="$2"

if [ -z "$INPUT_DOMAIN" ] || [ -z "$SSL_PATH" ]; then
  echo "입력값이 부족합니다.: $0 <INPUT_DOMAIN> <ssl_path>"
  echo "예제: $0 example.example.com /etc/letsencrypt/live"
  exit 1
fi

# Nginx conf 디렉토리 확인
NGINX_CONF_DIR="/etc/nginx/conf.d"
if [ ! -d "$NGINX_CONF_DIR" ]; then
  echo "❌ $NGINX_CONF_DIR not found. Is Nginx installed?"
  exit 1
fi

# example.conf 생성
cat > "$NGINX_CONF_DIR/example.conf" <<EOF
server {
    listen 80;
    server_name ${INPUT_DOMAIN};
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name ${INPUT_DOMAIN};

    ssl_certificate     ${SSL_PATH}/${INPUT_DOMAIN}/fullchain.pem;
    ssl_certificate_key ${SSL_PATH}/${INPUT_DOMAIN}/privkey.pem;

    location / {
        proxy_redirect off;
        proxy_http_version 1.1;
        proxy_pass_header Server;
        proxy_set_header X-Scheme \$scheme;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_pass http://localhost:5601;
    }
}
EOF

echo "✅ Nginx 설정 파일 생성 완료:"
echo "- $NGINX_CONF_DIR/example.conf"

echo "🔄 nginx 설정 적용을 위해 다음 명령 실행:"
echo "sudo nginx -t && sudo systemctl reload nginx"
