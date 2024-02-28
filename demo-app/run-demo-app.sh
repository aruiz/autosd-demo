#!/bin/bash
set -e

podman build -f Containerfile -t localhost/autosd-demo-app:latest

TMP_CONTAINER_HOME=$(mktemp -d)

podman run --security-opt label=disable                     \
       -v /run/user/$(id -u):/run/user/1020                 \
       -v $TMP_CONTAINER_HOME:/var/lib/digital-cockpit      \
       --device /dev/dri/renderD128                         \
       -e WAYLAND_DISPLAY=wayland-0                         \
       -e XDG_RUNTIME_DIR=/run/user/1020                    \
       -e NO_AT_BRIDGE=1                                    \
       --user 1020 --userns=keep-id:uid=1020,gid=1020       \
       -it localhost/autosd-demo-app:latest demo-app

rm -fr $TMP_CONTAINER_HOME