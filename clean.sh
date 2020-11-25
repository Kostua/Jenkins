#!/usr/bin/env sh
# docker kill $(docker ps -q)
# docker system prune --all --volumes -f
docker container rm jenkins && 
docker volume rm jenkins_jenkins-data &&
docker-compose up --build