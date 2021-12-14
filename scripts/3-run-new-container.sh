#!/bin/bash

sudo docker run -d -p 2222:22 --name skt4cmp sengkyaut/t4cmp
sudo docker ps
