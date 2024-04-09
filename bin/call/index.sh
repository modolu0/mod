#!/bin/bash

function main() {
  if [ $# -lt 2 ]; then
    echo "Usage: mod call <network> <l1 | l2 | null> <address> <function-selector> <args>"
    exit 1
  fi

  ADDRESS=$3
  if [[ $5 == "returns" ]]; then
    SELECTOR="$4 $5 $6"
    PARAMS=${@:7}
  else
    SELECTOR=$4
    PARAMS=${@:5}
  fi

  cast call --rpc-url $RPC $ADDRESS "$SELECTOR" $PARAMS --keystore ~/.foundry/keystores
}

main $@
