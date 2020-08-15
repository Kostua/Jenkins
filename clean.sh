#!/usr/bin/env sh
docker kill $(docker ps -q)
docker system prune --all --volumes -f
