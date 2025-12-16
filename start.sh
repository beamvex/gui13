#!/bin/bash

docker build -t gui13 .

docker run -it --rm --name gui13 -p 5901:5901 -p 3001:3001 --shm-size 1g -v ./config:/config gui13 /bin/bash
