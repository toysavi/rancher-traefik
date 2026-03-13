#!/bin/bash
set -e

echo "[INFO] Uninstalling Rancher..."
helm uninstall rancher -n cattle-system || true
kubectl delete ns cattle-system || true

echo "[INFO] Removing Traefik configs..."
kubectl delete -f /rancher-traefik/k8s/traefik/traefik-config.yaml || true
kubectl delete -f /rancher-traefik/k8s/traefik/ingress-rancher.yaml || true
kubectl delete -f /rancher-traefik/k8s/traefik/ingress-traefik.yaml || true
kubectl delete -f /rancher-traefik/k8s/traefik/middleware.yaml || true

echo "[INFO] Uninstalling cert-manager..."
helm uninstall cert-manager -n cert-manager || true
kubectl delete ns cert-manager || true

echo "[INFO] Rancher + Traefik stack removed."
