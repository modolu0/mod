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

  get_config

  cd $PROJECT_DIR

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
    c) CMD=call ;;
    s) CMD=send ;;
    r) CMD=rpc ;;
  esac

  if [[ $CMD == "balance" || $CMD == "script" || $CMD == "call" || $CMD == "send" ]]; then
    if [[ $FORK == "true" ]]; then
      if [[ $3 == "l1" || $3 == "l2" ]]; then
        export DEPLOYMENT_ENVIRONMENT=$2
        export DEPLOYMENT_LAYER=$3
        export FORK_ID=$(mod tenderly $2 $3)
        export RPC=https://rpc.tenderly.co/fork/$FORK_ID
        shift 2
      else
        export DEPLOYMENT_ENVIRONMENT=$2
        export FORK_ID=$(mod tenderly $2)
        export RPC=https://rpc.tenderly.co/fork/$FORK_ID
        shift 1
      fi
      echo
      echo https://dashboard.tenderly.co/$TENDERLY_ORG/$TENDERLY_PROJECT/fork/$FORK_ID
      echo
    else
      export VERIFY=$(cat ${PROJECT_DIR}/mod.config.json | jq -r ".envs.\"${2}\".verify")
      if [[ $3 == "l1" || $3 == "l2" ]]; then
        export DEPLOYMENT_ENVIRONMENT=$2
        export DEPLOYMENT_LAYER=$3
        export RPC=$(mod rpc $2 $3)
        shift 2
      else
        export DEPLOYMENT_ENVIRONMENT=$2
        export RPC=$(mod rpc $2)
        shift 1
      fi
    fi
  fi

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

get_config() {
  dir=$(pwd -P)
  while [ -n "$dir" -a ! -f "$dir/mod.config.json" ]; do
      dir=${dir%/*}
  done
  if [[ $dir != "" ]]; then
    export PROJECT_DIR=$dir
  fi
}

main $@
