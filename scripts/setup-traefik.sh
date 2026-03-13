#!/bin/bash
set -e

echo "[INFO] Applying Traefik HelmChartConfig..."
kubectl apply -f k8s/traefik/traefik-config.yaml

echo "[INFO] Applying Rancher ingress..."
kubectl apply -f k8s/traefik/ingress-rancher.yaml

echo "[INFO] Applying Traefik dashboard ingress..."
kubectl apply -f k8s/traefik/ingress-traefik.yaml

echo "[INFO] Applying middleware security headers..."
kubectl apply -f k8s/traefik/middleware.yaml

echo "[INFO] Traefik setup complete. All services exposed via port 443."
