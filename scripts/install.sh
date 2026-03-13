#!/bin/bash
set -e
source config/.env

# Install k3s
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode=644" sh -
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install cert-manager
./k8s/cert-manager/install-cert-manager.sh

# Install Rancher
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --create-namespace \
  --set hostname=rancher.${BASE_DOMAIN} \
  --set bootstrapPassword=${RANCHER_BOOTSTRAP_PASSWORD} \
  --set ingress.tls.source=secret \
  --set replicas=1

# SSL mode handling
if [ "$SSL_MODE" = "custom" ]; then
  echo "[INFO] Using custom SSL cert..."
  kubectl create secret tls custom-tls \
    --cert=${CUSTOM_SSL_CERT} \
    --key=${CUSTOM_SSL_KEY} \
    -n kube-system
fi

# Apply Traefik configs with env substitution
envsubst < k8s/traefik/traefik-config.yaml | kubectl apply -f -
envsubst < k8s/traefik/ingress-rancher.yaml | kubectl apply -f -
envsubst < k8s/traefik/ingress-traefik.yaml | kubectl apply -f -
envsubst < k8s/traefik/middleware.yaml | kubectl apply -f -
