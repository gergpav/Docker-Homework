#!/usr/bin/env bash
set -euo pipefail

APP_NAME="docker-homework"
IMAGE_NAME="my-app-image:latest"

K="minikube.exe kubectl --"

echo "=== Hostname ==="
hostname
echo

echo "=== Starting Minikube ==="
minikube.exe start
echo

echo "=== Loading image into Minikube ==="
minikube.exe image load "$IMAGE_NAME"
echo

echo "=== Recreate Job ==="
$K delete job "${APP_NAME}" --ignore-not-found=true
$K delete deployment "${APP_NAME}" --ignore-not-found=true

cat <<EOF | $K apply -f - --validate=false
apiVersion: batch/v1
kind: Job
metadata:
  name: ${APP_NAME}
spec:
  backoffLimit: 0
  template:
    metadata:
      labels:
        app: ${APP_NAME}
    spec:
      restartPolicy: Never
      containers:
      - name: ${APP_NAME}
        image: ${IMAGE_NAME}
        imagePullPolicy: IfNotPresent
EOF

echo "=== Waiting Job complete ==="
$K wait --for=condition=complete job/${APP_NAME} --timeout=120s || true
echo

echo "=== Job / Pod status ==="
$K get job ${APP_NAME} -o wide
$K get pods -l app=${APP_NAME} -o wide
echo

echo "=== Done ==="

echo "=== ======= RESULT / CHECK ======= ==="
echo

echo "=== Hostname ==="
hostname
echo

echo "=== Minikube status ==="
minikube.exe status
echo

echo "=== Job status ==="
$K get job "${APP_NAME}" -o wide
echo

echo "=== Pod status ==="
$K get pods -l "app=${APP_NAME}" -o wide
echo

echo "=== Application output ==="
echo
$K logs "job/${APP_NAME}" || true
echo

echo "=== ======= END ======= ==="





