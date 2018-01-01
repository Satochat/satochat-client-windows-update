#!/bin/sh

finish() {
    echo "Stopping containers..."
    if [ ! -z "$remoteTempDir" ]; then
        rm -rf "$remoteTempDir" > /dev/null || true
    fi
}

trap finish EXIT

echo "Deploying to $DEPLOY_APPSERVER_SSH_HOST..."

remoteTempDir=$(ssh "$DEPLOY_APPSERVER_SSH_HOST" "mktemp -d") || exit 1
echo "Remote temporary directory: $remoteTempDir"

cat docker-compose.ci.prod.yml | envsubst | tee docker-compose.ci.prod.yml
scp docker-compose.yml docker-compose.ci.prod.yml Dockerfile "$DEPLOY_APPSERVER_SSH_HOST:$remoteTempDir" || exit 1

echo "Stopping containers..."
ssh "$DEPLOY_APPSERVER_SSH_HOST" "cd '$remoteTempDir' && docker-compose -p '$COMPOSE_PROJECT_NAME' -f docker-compose.yml -f docker-compose.ci.prod.yml down" || exit 1

echo "Running containers..."
ssh "$DEPLOY_APPSERVER_SSH_HOST" "cd '$remoteTempDir' && docker-compose -p '$COMPOSE_PROJECT_NAME' -f docker-compose.yml -f docker-compose.ci.prod.yml up -d" || exit 1

# TODO: Run tests
# TODO: Roll back on failure

echo 'Test succeeded.'
echo 'Deployment succeeded.'
