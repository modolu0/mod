#!/bin/bash

function main() {
  if [ $# -ne 2 ]; then
    echo "Usage: mod script <network> <contract-name>"
    exit 1
  fi

  ADDRESS=$(cat "deployments/$1/$2.json" | jq '.address' | sed 's:^.\(.*\).$:\1:')
  echo $ADDRESS
}

main $@
