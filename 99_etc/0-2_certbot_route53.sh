#!/bin/bash

usage() {
  cat <<EOM
Usage: $0 [-h] <-d DOMAIN> <-o PATH>

Options
  -h               Print this help message
  -d DOMAIN        Base domain (e.g. osstem.x2bee.com) — will also generate *.DOMAIN
  -o OUTPUT_PATH   Directory to store certs (e.g. ./ssl)
EOM
}

issue_cert_dns_route53() {
  docker run -it --rm --name certbot \
    -v "$1/etc/letsencrypt:/etc/letsencrypt" \
    -v "$1/lib/letsencrypt:/var/lib/letsencrypt" \
    -e AWS_REGION=ap-northeast-2 \
    certbot/dns-route53 certonly \
    -d "$2" -d "*.$2"
}

# Root 권한 확인
if [ "$EUID" -ne 0 ]; then
  echo "This script requires root privileges. Re-running with sudo..."
  chmod +x "$0"
  exec sudo -E "$0" "$@"
  exit $?
fi

while getopts "d:o:h" opt; do
  case "$opt" in
    d) domain=$OPTARG ;;
    o) output=$OPTARG ;;
    h)
      usage
      exit 0
      ;;
    \?)
      usage >&2
      exit 64
      ;;
  esac
done

shift $((OPTIND - 1))

if [ -z "$domain" ]; then
  echo "-d DOMAIN is required" >&2
  usage >&2
  exit 64
fi

if [ -z "$output" ]; then
  echo "-o OUTPUT_PATH is required" >&2
  usage >&2
  exit 64
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker command not found" >&2
  exit 64
fi

echo "🔐 Issuing certificate for: $domain and *.$domain"
issue_cert_dns_route53 "$output" "$domain"

live_path="$output/etc/letsencrypt/live/$domain"
if [ -d "$live_path" ]; then
  echo ""
  echo "✅ Certificate successfully issued."
  echo "📁 Certificate location:"
  echo "  - Full chain:      $live_path/fullchain.pem"
  echo "  - Private key:     $live_path/privkey.pem"
  echo "  - Certificate:     $live_path/cert.pem"
  echo "  - Chain:           $live_path/chain.pem"
else
  echo "❌ Certificate issuing failed or folder not found: $live_path"
fi

