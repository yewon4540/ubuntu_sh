# 4. Certbot 발급 스크립트 (별도 실행 파일로 저장을 추천)
cat <<'EOF' > 33_issue_cert.sh
#!/bin/bash

usage() {
  cat <<EOM
Usage: \$0 [-h] <-d DOMAIN> <-o PATH>

Options
  -h Print this help
  -o Output path (e.g. \${PWD}/certs)
  -d Domain certificate is issued for (e.g. mm.example.com)
EOM
}

issue_cert_standalone() {
  docker run -it --rm --name certbot -p 80:80 \
    -v "\${1}/etc/letsencrypt:/etc/letsencrypt" \
    -v "\${1}/lib/letsencrypt:/var/lib/letsencrypt" \
    certbot/certbot certonly --standalone -d "\${2}"
}

authenticator_to_webroot() {
  sed -i 's/standalone/webroot/' "\${1}"/etc/letsencrypt/renewal/"\${2}".conf
  tee -a "\${1}"/etc/letsencrypt/renewal/"\${2}".conf >/dev/null <<EOM
webroot_path = /usr/share/nginx/html,
[[webroot_map]]
EOM
}

# root 권한 확인
if [ \$EUID != 0 ]; then
  chmod +x "\$0"
  sudo -E ./\$0 "\$@"
  exit \$?
fi

while getopts d:o:h opt; do
  case "\$opt" in
    d) domain=\$OPTARG ;;
    o) output=\$OPTARG ;;
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

shift \$((OPTIND - 1))

if [ -z "\$domain" ]; then
  echo "-d is required" >&2
  usage >&2
  exit 64
fi

if [ -z "\$output" ]; then
  echo "-o is required" >&2
  usage >&2
  exit 64
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Can't find Docker command" >&2
  exit 64
fi

issue_cert_standalone "\$output" "\$domain"
authenticator_to_webroot "\$output" "\$domain"
EOF

chmod +x issue_cert.sh
echo "SSL 인증서 발급 스크립트 'issue_cert.sh' 생성 완료"
