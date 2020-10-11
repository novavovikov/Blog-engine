#!/bin/sh
set -e

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)

#settings
NETWORK="blog_net"
PROXY_DOCKERFILE="$PWD/proxy/Dockerfile"
PROXY_DOCKERFILE_TAG="proxy_nginx"

docker-compose -f docker-compose.yml -f docker-compose.prod.yml build
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

#run proxy
docker rm -f "$PROXY_DOCKERFILE_TAG" || true
docker build --no-cache \
  --force-rm \
  -f "$PROXY_DOCKERFILE" \
  -t "$PROXY_DOCKERFILE_TAG" .

docker run --network "$NETWORK" \
  --name "$PROXY_DOCKERFILE_TAG" \
  -p 80:80 -p 443:443 \
  -d "$PROXY_DOCKERFILE_TAG"
