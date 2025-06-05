#!/bin/bash

# Kubernetes 기본 명령어 모음
# 사용법: chmod +x k8s-basic-commands.sh && ./k8s-basic-commands.sh

echo "Nodes 확인"
kubectl get nodes

echo ""
echo "현재 네임스페이스의 Pods 확인"
kubectl get pods

echo ""
echo "모든 네임스페이스의 Pods 확인"
kubectl get pods -A

echo ""
echo "Service 목록 확인"
kubectl get svc

echo ""
echo "Deployment 목록 확인"
kubectl get deployments

echo ""
echo "네임스페이스 목록 확인"
kubectl get namespaces

echo ""
echo "현재 네임스페이스의 전체 리소스 확인"
kubectl get all

echo ""
echo "Ingress 리소스 확인"
kubectl get ingress

echo ""
echo "특정 파드 상세 확인 (예: mypod)"
# kubectl describe pod mypod

echo ""
echo "특정 노드 상세 확인 (예: mynode)"
# kubectl describe node mynode

echo ""
echo "특정 서비스 상세 확인 (예: myservice)"
# kubectl describe svc myservice

echo ""
echo "파드 로그 확인 (예: mypod)"
# kubectl logs mypod

echo ""
echo "파드 안으로 접속 (예: mypod)"
# kubectl exec -it mypod -- /bin/bash

echo ""
echo "리소스 사용량 확인 (metrics-server 필요)"
kubectl top pod

echo ""
echo "리소스 적용 (예: deployment.yaml)"
# kubectl apply -f deployment.yaml

echo ""
echo "리소스 삭제 (예: mypod)"
# kubectl delete pod mypod

