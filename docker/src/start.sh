#!/usr/bin/env bash

THIS_DIR=`dirname "$0"`

if [[ "$1" = "help" ]]; then
    echo "Usage: $(basename "$0") (master|worker|help)"
    exit 0

elif [[ "$1" = "master" ]]; then
    ls ${THIS_DIR}/master/*.sh | xargs bash

elif [[ "$1" = "worker" ]]; then
    ls ${THIS_DIR}/worker/*.sh | xargs bash

fi

shift 1
exec "$@"
