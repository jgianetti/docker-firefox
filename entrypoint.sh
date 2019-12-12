#!/bin/bash
set -e

if [ "$1" = 'firefox' ]; then
    if [ -d $HOME/extensions ]; then
        exec "$@" $(ls $HOME/extensions/*.xpi)
    fi
fi

exec "$@"
