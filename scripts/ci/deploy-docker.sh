#!/bin/sh

echo "Uploading images..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin || exit 1
docker-compose push web ftp || exit 1
