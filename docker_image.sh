#!/usr/bin/env bash

docker build -t blacksalt/bytedance-latentsync:1.5 --label git-commit=$(git rev-parse HEAD) .
docker push blacksalt/bytedance-latentsync:1.5
