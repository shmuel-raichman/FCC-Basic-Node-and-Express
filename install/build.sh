#!/bin/bash
# B"H

cd ..
REPOSITORY_NAME=smuel770/fcc-basic-node-and-express
TAG="${1:-latest}"

docker build -t $REPOSITORY_NAME:$TAG .
# docker push $REPOSITORY_NAME:$TAG

exit $?   # In this case, exit code = 99, since that is function return.