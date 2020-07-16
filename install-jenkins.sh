#!/bin/bash

# Install Jenkins in docker container

# Create a bridge network in Docker
docker network inspect jenkins >/dev/null 2>&1 || \
    docker network create --driver bridge jenkins

# Create the following volumes to share the Docker client TLS certificates
# needed to connect to the Docker daemon and persist the Jenkins data
docker volume inspect jenkins-docker-certs >/dev/null 2>&1 || \
	docker volume create jenkins-docker-certs
docker volume inspect jenkins-data >/dev/null 2>&1 || \
	docker volume create jenkins-data

# Build docker image from Dockerfile

docker build . -t kostua/jenkins:alpine


# Download the jenkinsci/blueocean image and run it as a container in Docker



docker container run --name jenkins --rm --detach \
	  --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
	    --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
	      --volume jenkins-data:/var/jenkins_home \
	        --volume jenkins-docker-certs:/certs/client:ro \
		  --publish 8080:8080 --publish 50000:50000 kostua/jenkins:alpine 

