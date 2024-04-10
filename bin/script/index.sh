#!/bin/bash

function checkStatus {
  if [ ! $? -eq 0 ]; then
    exit 1
  fi
}

function main() {
  if [ $1 = "fork" ]; then
    shift
    FORK_ID=$(mod tenderly $1 $2)
    RPC=https://rpc.tenderly.co/fork/$FORK_ID
  fi

  if [ $# -lt 2 ]; then
    echo "Usage: mod script <network> <l1 | l2 | null> <script-contract> <function-selector> <args>"
    exit 1
  fi

  SCRIPT_CONTRACT=$1
  FUNCTION_NAME=$2
  ARGS=${@:3}

  if [ -z $ACCOUNT ]; then
    SENDER=""
  else
    SENDER="--sender $(cast wallet address --account $ACCOUNT) --account $ACCOUNT"
  fi

  COMMAND="forge script --rpc-url $RPC $SENDER $SCRIPT_CONTRACT --sig $FUNCTION_NAME $ARGS"
  echo $COMMAND
  STRICT_DEPLOYMENT=false $COMMAND
  checkStatus

  echo "Syncing transactions"
  export SIG=$(echo $FUNCTION_NAME | cut -d "(" -f 1)
  forge script $SENDER --rpc-url $RPC $SCRIPT_CONTRACT --sig 'sync()'

  if [ ! -z $FORK_ID ]; then
    echo https://dashboard.tenderly.co/$TENDERLY_ORG/$TENDERLY_PROJECT/fork/$FORK_ID
  fi
}

main $@
