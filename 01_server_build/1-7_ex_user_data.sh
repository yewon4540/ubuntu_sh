# update
echo "apt update..."
sudo apt update
sudo apt upgrade -y

# network 조회 관련 tool
sudo apt install net-tools -y

# directory tree 조회
sudo apt install tree -y

# docker install
echo "docker install..."
sudo wget -qO- http://get.docker.com/ | sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

sudo usermod -aG docker ubuntu

# newgrp docker
sudo systemctl enable docker
sudo systemctl start docker
