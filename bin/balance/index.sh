#!/bin/bash

ORANGE='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

function main() {
  if [ $# -lt 3 ]; then
    echo "Usage: mod balance <network> <l1 | l2> <address>"
    exit 1
  fi

  RPC=$(mod rpc $1 $2)

  if [ $2 == "l1" ]; then
    LAYER=L1
  else
    LAYER=L2
  fi
  echo -e "$(cast balance --rpc-url $RPC $3 --ether) ${ORANGE}ETH (${LAYER})${NC}"
}

main $@
