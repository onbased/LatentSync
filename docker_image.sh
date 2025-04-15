#!/usr/bin/env bash


if git status --porcelain | grep -q .; then
    echo "Please commit your changes before building the docker image."
    exit 1
fi

commit=$(git rev-parse HEAD)

set -ex

docker build --target latentsync --tag blacksalt/bytedance-latentsync:1.5 --label git-commit=$commit .
docker build --target runpod --tag blacksalt/bytedance-latentsync-runpod:1.5 --label git-commit=$commit .

docker push blacksalt/bytedance-latentsync:1.5
docker push blacksalt/bytedance-latentsync-runpod:1.5
