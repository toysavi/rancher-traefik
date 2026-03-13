# Load environment variables from config/.env
include config/.env
export $(shell sed 's/=.*//' config/.env)

.PHONY: install uninstall ssl health

install:
    @echo "[INFO] Installing Rancher + Traefik stack..."
    ./scripts/install.sh

uninstall:
    @echo "[INFO] Uninstalling Rancher + Traefik stack..."
    ./scripts/uninstall.sh

ssl:
ifeq ($(SSL_MODE),custom)
    @echo "[INFO] Creating custom TLS secret..."
    kubectl create secret tls custom-tls \
        --cert=$(CUSTOM_SSL_CERT) \
        --key=$(CUSTOM_SSL_KEY) \
        -n kube-system
else
    @echo "[INFO] SSL_MODE is set to 'letsencrypt'. No manual secret needed."
endif

health:
    @echo "[INFO] Running health checks..."
    ./scripts/healthcheck.sh
