#!/bin/bash

sudo docker exec -it skt4cmp sh ./scripts/build_deb_pkg.sh
mkdir ./pkg/
rm ./pkg/*
sudo docker cp skt4cmp:/root/pkg/ ./
echo "Check ./pkg directory"
