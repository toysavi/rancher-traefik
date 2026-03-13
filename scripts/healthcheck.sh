#!/bin/bash
set -e

echo "[INFO] Checking k3s cluster..."
kubectl get nodes

echo "[INFO] Checking Rancher deployment..."
kubectl rollout status deployment/rancher -n cattle-system --timeout=120s

echo "[INFO] Checking Traefik pods..."
kubectl get pods -n kube-system | grep traefik

echo "[INFO] Curl Rancher via HTTPS (443)..."
curl -k https://rancher.example.com/login || echo "Rancher not reachable"

echo "[INFO] Curl Traefik dashboard via HTTPS (443)..."
curl -k https://traefik.example.com/dashboard/ || echo "Traefik dashboard not reachable"
