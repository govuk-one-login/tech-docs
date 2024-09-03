#! /bin/bash
set -e

# generate the build directory of static content and run the html-proofer
./build-with-docker.sh

# build nginx container with build content
docker build -f DockerfileAWS --tag tech-docs-nginx .

# run nginx
docker run -p 80:80 -it tech-docs-nginx
