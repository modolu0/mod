#!/bin/bash

main() {
  # The directory of the script
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

  if [[ $MOD_INIT -ne "1" ]]; then 
    # Check if the env has been loaded properly
    source "${DIR}/.env"

    export MOD_INIT=1

    export MOD="${DIR}/mod.sh"
    mod() {
      $MOD $@
    }
    export -f mod

    # Check if the argument is provided
    if [ "$#" -lt 1 ]; then
      echo "Usage: mod <cmd-name>"
      exit 1
    fi
  fi

  call $@
}

call() {
  # Apply aliases for convenience
  CMD="${1}"
  case $CMD in
    b) CMD=balance ;;
    t) CMD=trace ;;
    ve) CMD=verify ;;
    wa) CMD=wallet ;;
    s) CMD=script ;;
    a) CMD=address ;;
    pk) CMD=pk ;;
    e) CMD=e2e ;;
    c) CMD=cast ;;
    s) CMD=send ;;
    r) CMD=rpc ;;
  esac

  # Execute the command
  shift
  if [ -f "${DIR}/bin/${CMD}/index.js" ]; then
    node "${DIR}/bin/${CMD}/index.js" $@
  elif [ -f "${DIR}/bin/${CMD}/index.sh" ]; then
    "${DIR}/bin/${CMD}/index.sh" "$@"
  else
    echo "Error: Command not found!"
    exit 2
  fi
}

main $@
