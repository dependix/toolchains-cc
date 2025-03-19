#!/bin/bash

docker build -t ctng .

docker run --rm -it --user "$(id -u):$(id -g)" -v ${PWD}:/workspace ctng:latest /bin/bash -c "cd /workspace && GCC=12 ./build.sh"
docker run --rm -it --user "$(id -u):$(id -g)" -v ${PWD}:/workspace ctng:latest /bin/bash -c "cd /workspace && GCC=13 ./build.sh"
docker run --rm -it --user "$(id -u):$(id -g)" -v ${PWD}:/workspace ctng:latest /bin/bash -c "cd /workspace && GCC=14 ./build.sh"

