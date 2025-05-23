#!/bin/bash
set -euxo pipefail

### 1. Swap 비활성화
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

### 2. containerd 설치 및 구성

apt-get update && apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

apt-get update && apt-get install -y containerd.io

mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

systemctl restart containerd
systemctl enable containerd

# IP 포워딩 활성화 (반드시 kubeadm 명령 이전에 실행)
# sudo sysctl -w net.ipv4.ip_forward=1
# sudo sysctl -p
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

### 3. Kubernetes 설치

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /" > /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

### 4. 주의: 워커는 여기까지 설정만 진행됨

# 워커 노드는 마스터에서 생성한 join 명령을 직접 받아 실행해야 함
# ex)
# sudo kubeadm join <master-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:...
# sudo kubeadm join 172.31.32.243:6443 --token 80p2pg.kjzxdtsjlu73cnas --discovery-token-ca-cert-hash sha256:7e8254a995b3814a1b3c6a432a0e9f67c1acba1f05adfa0cdbd30fcc56326d7e

