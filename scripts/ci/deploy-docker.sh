#!/bin/sh

echo "Uploading image..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin || exit 1
docker-compose push web || exit 1
