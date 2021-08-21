#!/bin/sh

GITHUB_REPO=$1
DOCKERHUB_REPO=$2

# Fetch latest version from Github Releases
LATEST_VER=$(curl -sI -o /dev/null -w "%{redirect_url}" https://github.com/$GITHUB_REPO/releases/latest | sed -r "s/.*\/tag\/(.*)/\1/g")
# Check if the version tag exists in Dockerhub repo
HTTP_CODE=$(curl -sflSL -o /dev/null -w "%{http_code}" "https://index.docker.io/v1/repositories/$DOCKERHUB_REPO/tags/$LATEST_VER" 2>/dev/null)

if [ "$HTTP_CODE" -eq "404" ]; then
    
    echo "$LATEST_VER"
else 
    echo "false"
fi