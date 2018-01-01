#!/bin/sh

echo "Uploading images..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin || exit 1
docker-compose -f docker-compose.yml -f docker-compose.ci.prod.yml push web ftp || exit 1
