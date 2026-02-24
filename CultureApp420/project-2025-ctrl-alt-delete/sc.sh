#!/bin/bash

HOST_PORT="$1"

echo "pulling newest git version"
git pull
echo "running now"
sudo docker run --rm -p $HOST_PORT:8000 ../project-2025-ctrl-alt-delete/Ctrl_Alt_Dlt/pamphlet-maker