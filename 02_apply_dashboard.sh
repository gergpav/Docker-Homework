#!/usr/bin/env bash
set -euo pipefail
K="minikube.exe kubectl --"

cat <<'EOF' | $K -n monitoring apply -f - --validate=false
apiVersion: v1
kind: ConfigMap
metadata:
  name: homework-dashboard
  labels:
    grafana_dashboard: "1"
data:
  homework-dashboard.json: |
    {
      "title": "Homework Monitoring Dashboard",
      "timezone": "browser",
      "schemaVersion": 38,
      "version": 1,
      "refresh": "10s",
      "panels": [
        {
          "type": "timeseries",
          "title": "CPU usage % (node)",
          "gridPos": {"x":0,"y":0,"w":12,"h":8},
          "targets": [{"expr": "100 - (avg by(instance)(rate(node_cpu_seconds_total{mode=\"idle\"}[2m])) * 100)", "refId":"A"}]
        },
        {
          "type": "timeseries",
          "title": "RAM available (GiB) (node)",
          "gridPos": {"x":12,"y":0,"w":12,"h":8},
          "targets": [{"expr": "node_memory_MemAvailable_bytes/1024/1024/1024", "refId":"A"}]
        },
        {
          "type": "timeseries",
          "title": "Disk used % (root fs)",
          "gridPos": {"x":0,"y":8,"w":12,"h":8},
          "targets": [{"expr": "100 * (1 - (node_filesystem_avail_bytes{mountpoint="/data"} / node_filesystem_size_bytes{mountpoint="/data"}))",
          "refId":"A"}]
        },
        {
          "type": "stat",
          "title": "Healthcheck: any container Ready (default ns)",
          "gridPos": {"x":12,"y":8,"w":12,"h":8},
          "targets": [{"expr": "max(kube_pod_container_status_ready{namespace=\"default\"})", "refId":"A"}],
          "options": { "reduceOptions": { "calcs": ["lastNotNull"] } }
        },
        {
          "type": "timeseries",
          "title": "Business metric: successful Jobs (default ns)",
          "gridPos": {"x":0,"y":16,"w":24,"h":8},
          "targets": [{"expr": "sum(kube_job_status_succeeded{namespace=\"default\"})", "refId":"A"}]
        }
      ]
    }
EOF

echo "Dashboard applied. Open Grafana and search: Homework Monitoring Dashboard"
