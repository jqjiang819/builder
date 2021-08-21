#!/bin/sh

set -e

/docker-entrypoint.sh nginx >/dev/null &

echo "{\"host\": \"$ENV_REGISTRY_HOST\", \"port\": $ENV_REGISTRY_PORT}" > /usr/share/nginx/html/registry-host.json

case "$1" in
    *.yaml|*.yml) set -- registry serve "$@" ;;
    serve|garbage-collect|help|-*) set -- registry "$@" ;;
esac

exec "$@"