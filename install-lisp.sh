#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

SCRIPT_ACTION=$1
shift

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
      --lisp)
          LISP_IMPLEMENTATION=$2
          shift
          shift
          ;;
      --lisp-version)
          export LISP_VERSION=$2
          shift
          shift
          ;;
      --bin)
          LISP_BIN=$2
          shift
          shift
          ;;
      --install-prefix)
          LISP_INSTALL_PREFIX=$2
          shift
          shift
          ;;
      --id-file)
          LISP_ID_FILE=$2
          shift
          shift
          ;;
      --*)
          shift
          shift
          ;;
      *)
          shift # past argument
          ;;
  esac
done

export LISP_IMPLEMENTATION=${LISP_IMPLEMENTATION:-sbcl}
export LISP_BIN=${LISP_BIN:-$HOME/.local/bin/lisp}
export LISP_INSTALL_PREFIX=${LISP_INSTALL_PREFIX:-$HOME/.local/opt/lisp/}
export LISP_ID_FILE=${LISP_ID_FILE:-$LISP_INSTALL_PREFIX/.lispid}


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


case $SCRIPT_ACTION in

  install)
      install_$LISP_IMPLEMENTATION
    ;;

  id)
      print_lisp_id_$LISP_IMPLEMENTATION
    ;;

  *)
      exit -1
    ;;
esac
