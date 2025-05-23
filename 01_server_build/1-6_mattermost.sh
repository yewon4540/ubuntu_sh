# directory make
echo mattermost pull...
git clone https://github.com/mattermost/docker
cd docker
cp env.example .env
mkdir -p ./volumes/app/mattermost/config
mkdir -p ./volumes/app/mattermost/data
mkdir -p ./volumes/app/mattermost/logs
mkdir -p ./volumes/app/mattermost/plugins
mkdir -p ./volumes/app/mattermost/client/plugins
mkdir -p ./volumes/app/mattermost/bleve-indexes
sudo chown -R ubuntu:ubuntu ./volumes
sudo chown -R 2000:2000 ./volumes/app/mattermost

# variable
echo variable setting...
export IP=$(curl -s ifconfig.me)
echo IP = $IP
export TZ=Asia/Seoul
echo TZ = $TZ
export MMNAME=mattermost-enterprise-edition
echo Image name = $MMNAME
export MMVERSION=9.3
echo Mattermost version = $MMVERSION
export HOSTPORT=80
echo Hosting Port = $HOSTPORT

# exchange
echo Enviroment setting...
sed -i "s/^DOMAIN=.*$/DOMAIN=$IP/" .env
sed -i "s/^TZ=.*$/TZ=$TZ/" .env
sed -i "s/^MATTERMOST_IMAGE=.*$/MATTERMOST_IMAGE=$MMNAME/" .env
sed -i "s/^MATTERMOST_IMAGE_TAG=.*$/MATTERMOST_IMAGE_TAG=$MMVERSION/" .env
sed -i "s/\${APP_PORT}/$HOSTPORT/" docker-compose.without-nginx.yml

# start
echo 초기 실행...
docker compose -f docker-compose.yml -f docker-compose.without-nginx.yml up -d

echo "1분 대기"
sleep 60

# 위 sleep 부분에서 세선 초기화 시 아래 부분은 따로 작성하여 실행
echo Mattermost Config...
cd docker
sudo sed -i "s|\"SiteURL\": \".*\"|\"SiteURL\": \"http://$IP:$HOSTPORT\"|" ./volumes/app/mattermost/config/config.json
sudo sed -i "s|\"WebsocketURL\": \".*\"|\"WebsocketURL\": \"ws://$IP:$HOSTPORT\"|" ./volumes/app/mattermost/config/config.json

echo complete. docker restart...
docker compose -f docker-compose.yml -f docker-compose.without-nginx.yml down
sleep 5

docker compose -f docker-compose.yml -f docker-compose.without-nginx.yml up -d

echo End!
