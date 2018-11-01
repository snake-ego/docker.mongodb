#!/bin/sh
set -e

USER='mongodb'
CMD='mongod --bind_ip_all'

if [ -e '/etc/mongod.conf' ]; then CMD="$CMD -f /etc/mongod.conf"; fi

if [ ! -d "/data/configdb" ]; then mkdir -p /data/configdb; fi
if [ ! -d "/data/db" ]; then mkdir -p /data/db; fi

if [ "${1:0:1}" = '-' ]; then 
    set -- $CMD "$@"; 
fi
if [ "$1" = 'mongod' ] && [ "$(id -u)" = '0' ]; then
    shift
    
    [ "$(stat -c %U /data/db)" = $USER ] || chown -R $USER /data/db
    [ "$(stat -c %U /data/configdb)" = $USER ] || chown -R $USER /data/configdb
    
    exec "/usr/local/bin/suexec" $USER $CMD "$@"
fi

exec "$@"
