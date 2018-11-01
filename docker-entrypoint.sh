#!/bin/sh
set -e

CMD='mongod'
ARGS="--bind_ip_all"
USER='mongodb'
CONFIG='/etc/mongod.conf'
SUEXEC="/usr/local/bin/suexec"

function main() {
    if is_privileged; then CMD="/usr/local/bin/suexec $USER $CMD"; fi
    if is_config_presents; then ARGS="$ARGS -f $CONFIG"; fi
    
    create_folders

    if is_empty "$@"; then execute $CMD $ARGS; fi
    if is_arguments "$@"; then execute $CMD $ARGS $@; fi
    execute $@
}

function is_empty() {
    [ -z "$1" ]
}
function is_arguments() {
    [ "${1:0:1}" = '-' ]
}
function is_privileged() {
    [ "$(id -u)" = '0' ]
}
function is_config_presents() {
    [ -e "$CONFIG" ]
}

function create_folders() {
    if [ ! -d "/data/configdb" ]; then mkdir -p /data/configdb; fi
    if [ ! -d "/data/db" ]; then mkdir -p /data/db; fi

    if is_privileged; then 
        [ "$(stat -c %U /data/db)" = $USER ] || chown -R $USER /data/db
        [ "$(stat -c %U /data/configdb)" = $USER ] || chown -R $USER /data/configdb
    fi
}

function execute() {
    exec $@
    exit $?
}

main $@
