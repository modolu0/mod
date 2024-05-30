#!/bin/bash

function main() {
  if [ $# -lt 2 ]; then
    echo "Usage: mod address <network> <contract-name>"
    exit 1
  fi

  ADDRESS=$(cat "deployments/$1/$2.json" | jq '.address' | sed 's:^.\(.*\).$:\1:')
  echo $ADDRESS
}

main $@
