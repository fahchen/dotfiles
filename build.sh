#!/bin/sh

set -eux

docker build . --tag=vim-runner
docker run -it vim-runner bash
