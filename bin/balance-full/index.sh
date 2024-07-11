#!/bin/bash

ORANGE='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

function main() {
  if [ $# -lt 1 ]; then
    echo "Usage: mod balance-full <address>"
    exit 1
  fi
  rpcs_string=$(cat mod.config.json | jq -r ".rpc" | jq -r "keys[]")
  read -a rpcs <<< $rpcs_string

  for rpc in ${rpcs[@]}; do
    if [[ "$rpc" != "devnet-l1" && "$rpc" != "devnet-l2" ]]; then
      echo $rpc $(mod balance $rpc $1)
    fi
  done
}

main $@
