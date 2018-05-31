#!/bin/sh
set -e

if [ ! -d "/data/configdb" ]; then mkdir -p /data/configdb; fi
if [ ! -d "/data/db" ]; then mkdir -p /data/db; fi
 
if [ "${1:0:1}" = '-' ]; then
    set -- mongod "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'mongod' -a "$(id -u)" = '0' ]; then
    [ "$(stat -c %U /data/db)" = mongodb ] || chown -R mongodb /data/db
    [ "$(stat -c %U /data/configdb)" = mongodb ] || chown -R mongodb /data/configdb
    exec "/usr/local/bin/suexec" mongodb "$@"
fi

exec "$@"
