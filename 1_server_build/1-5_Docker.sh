# docker install
echo docker install...
sudo wget -qO- http://get.docker.com/ | sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

sudo usermod -aG docker ubuntu

# 재시작. 사용 시 세션이 끊기므로 자동화 할거면 빼면 된다.
# newgrp docker

# 자동화 시
sudo systemctl enable docker
sudo systemctl start docker
