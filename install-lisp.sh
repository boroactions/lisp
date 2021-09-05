#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

LISP_BIN=${1:=$HOME/.local/bin/lisp}
LISP_IMPLEMENTATION=${2:=sbcl}
LISP_INSTALL_PREFIX=${3:=$HOME/.local/opt/lisp/}
LISP_VERSION=$4
LISP_ID_FILE=$HOME/.local/share/lisp/lisp_identifier.txt

mkdir -p $(dirname $LISP_BIN)

function lisp_id_exists() {
    provided_id=$1
    if [ ! -f "$LISP_ID_FILE" ]; then
        return 1
    fi

    current_id=$(cat $LISP_ID_FILE)

    if [ "$current_id" = "$provided_id" ]; then
        return 0
    fi

    return 1
}

function write_lisp_id() {
    provided_id=$1

    echo "Writing Lisp ID: $provided_id"

    mkdir -p $(dirname $LISP_ID_FILE)
    echo "$provided_id" > $LISP_ID_FILE
}

. $SCRIPT_DIR/impl/sbcl.sh

install_$LISP_IMPLEMENTATION
