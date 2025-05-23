# 노드 상태 확인
kubectl get nodes

# 파드 상태 확인
kubectl get pods -A

# calico 설치 여부 확인
kubectl get pods -n kube-system | grep calico

# metrics-server 설치 여부
kubectl top nodes

# 테스트 파드 확인
kubectl get pods -n default
