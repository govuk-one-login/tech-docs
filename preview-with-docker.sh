#! /bin/bash
set -e

docker build . --tag tech-docs

docker run -p 4567:4567 -p 35729:35729 -v $(pwd):/usr/src/docs -it tech-docs
