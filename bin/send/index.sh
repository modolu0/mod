#!/bin/bash

function main() {
  if [ $# -lt 4 ]; then
    echo "Usage: mod send <network> <l1 | l2> <address> <function-selector> <args>"
    exit 1
  fi

  cd "${OPTIMISM_MONOREPO_ROOT}"

  NETWORK=$1
  LAYER=$2
  ADDRESS=$3
  if [[ $5 == "returns" ]]; then
    SELECTOR="$4 $5 $6"
    PARAMS=${@:7}
  else
    SELECTOR=$4
    PARAMS=${@:5}
  fi
  echo $SELECTOR

  RPC=$(mod rpc $NETWORK $LAYER)

  if [ -z $ACCOUNT ]; then
    SENDER=""
  else
    SENDER="--account $ACCOUNT"
  fi

  cast send --rpc-url $RPC $SENDER $ADDRESS "$SELECTOR" $PARAMS
}

main $@
