#!/bin/bash
set -euxo pipefail  # 에러 발생 시 즉시 종료 + 디버깅 출력

### 1. Swap 비활성화 (Kubernetes는 swap이 비활성화되어야 작동함)
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

### 2. containerd 설치 및 구성 (K8s에서 권장하는 컨테이너 런타임)

# 필수 패키지 설치
apt-get update && apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https

# Docker GPG 키 추가
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Docker 저장소 등록
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# containerd 설치
apt-get update && apt-get install -y containerd.io

# 기본 config 생성 및 systemd cgroup 사용 설정
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# containerd 서비스 재시작 및 부팅 시 자동 시작 설정
systemctl restart containerd
systemctl enable containerd

# IP 포워딩 활성화 (반드시 kubeadm 명령 이전에 실행)
# sudo sysctl -w net.ipv4.ip_forward=1
# sudo sysctl -p
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p


### 3. Kubernetes 바이너리 설치 (kubelet, kubeadm, kubectl)

# 공식 키 등록
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# 저장소 등록
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /" > /etc/apt/sources.list.d/kubernetes.list

# 설치 및 버전 고정
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

### 4. Kubernetes 마스터 노드 초기화

# --pod-network-cidr는 CNI 플러그인과 맞춰줘야 함 (Calico = 10.10.0.0/16)
kubeadm init --pod-network-cidr=10.10.0.0/16 | tee /root/kubeadm-init.log

### 5. 일반 사용자(ubuntu)에게 kubectl 권한 부여

mkdir -p /home/ubuntu/.kube
cp /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
chown ubuntu:ubuntu /home/ubuntu/.kube/config

### 6. CNI 플러그인 설치 (Calico 설치)

# 클러스터가 Ready 상태가 되려면 CNI는 필수
sudo -u ubuntu kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

### 7. 워커 노드 조인 명령 생성 및 저장

# 워커 노드에서 붙을 때 필요한 명령을 스크립트 파일로 저장
kubeadm token create --print-join-command > /home/ubuntu/kubeadm-join-command.sh
chmod +x /home/ubuntu/kubeadm-join-command.sh

