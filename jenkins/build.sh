#!/usr/bin/env bash
set -e

IMAGE_NAME="my-app-image"
GIT_SHA=$(git rev-parse --short HEAD)

echo "Building Docker image: $IMAGE_NAME:$GIT_SHA"
docker build -t $IMAGE_NAME:$GIT_SHA .
docker tag $IMAGE_NAME:$GIT_SHA $IMAGE_NAME:latest

echo "Build complete."
