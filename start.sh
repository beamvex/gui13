#!/bin/bash

docker build -t gui13 .

docker run -it --rm --name gui13 -p 3001:3001 \
  --shm-size 1g \
  -v ./config:/config \
  -v /tmp:/tmp \
  --security-opt seccomp=unconfined \
  gui13 "/bin/bash"
