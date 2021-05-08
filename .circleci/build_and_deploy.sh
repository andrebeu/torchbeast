#!/usr/bin/env bash

set -e
set -x


if [ $# -eq 0 ]
then
    tag='latest'
else
    tag=$1
fi

docker build -t torchbeast/ci-polybeast-cpu37:$tag -f .circleci/docker/polybeast/Dockerfile_cpu37 .
docker push torchbeast/ci-polybeast-cpu37:$tag
