#!/bin/bash
set -e

IMAGE="${1:-aksarsr/swiggy-app:latest}"
CONTAINER_NAME="swiggy-app"

echo "Pulling image: $IMAGE"
docker pull "$IMAGE"

echo "Stopping old container (if any)..."
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

echo "Starting new container..."
# map host port 80 to container port (change 3000 if your container listens on 3000)
docker run -d --restart unless-stopped -p 80:80 --name $CONTAINER_NAME "$IMAGE"

echo "Waiting 5s for health..."
sleep 5

# Simple health check (change path/port if needed)
if curl -sSf http://localhost/ >/dev/null; then
  echo "App responded OK"
else
  echo "Health check failed!"
  exit 1
fi

echo "Deployment finished successfully"
