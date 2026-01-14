#!/usr/bin/env bash
set -euo pipefail

echo "==> Start minikube"
minikube.exe start

echo "==> Prepare WSL-compatible kubeconfig for Helm"
KCFG="$(mktemp)"
minikube.exe kubectl -- config view --raw > "$KCFG"

sed -i -E 's#([A-Z]):\\#/mnt/\L\1/#g; s#\\#/#g' "$KCFG"

echo "==> Install kube-prometheus-stack (Prometheus + Grafana + node-exporter + kube-state-metrics)"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null
helm repo update >/dev/null

helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --kubeconfig "$KCFG" \
  -n monitoring --create-namespace \
  --set grafana.adminPassword=admin \
  --set grafana.service.type=NodePort \
  --set grafana.sidecar.dashboards.enabled=true \
  --set grafana.sidecar.dashboards.label=grafana_dashboard

echo "==> Wait for Grafana"
minikube.exe kubectl -- -n monitoring rollout status deploy/monitoring-grafana --timeout=300s

echo "==> Done"
echo "Grafana URL:"
minikube.exe service -n monitoring monitoring-grafana --url
echo "Login: admin / Password: admin"


