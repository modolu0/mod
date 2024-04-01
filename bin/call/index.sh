#!/bin/bash

function main() {
  if [ $# -lt 4 ]; then
    echo "Usage: mod call <network> <l1 | l2> <address> <function-selector> <args>"
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

  RPC=$(mod rpc $NETWORK $LAYER)

  cast call --rpc-url $RPC $ADDRESS "$SELECTOR" $PARAMS --keystore ~/.foundry/keystores
}

main $@
