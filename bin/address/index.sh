#!/bin/bash

function main() {
  ADDRESS=$(cat "deployments/$1/$2.json" | jq '.address' | sed 's:^.\(.*\).$:\1:')
  echo $ADDRESS
}

main $@
