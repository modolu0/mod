#!/bin/bash

function main() {
  cd "${OPTIMISM_MONOREPO_ROOT}"

  # Apply aliases for convenience
  CMD="${1}"
  case $CMD in
    a) CMD=add ;;
    c) CMD=create ;;
    addr) CMD=address ;;
    l) CMD=list ;;
  esac

  $CMD ${@:2}
}

function add() {
  if [ ! -z "$1" ]; then
    if [ -f $ETH_KEYSTORE_DIR/$1 ]; then
      echo "Named account already exists"
      exit 1
    fi
  fi

  output=$(cast wallet import -k $ETH_KEYSTORE_DIR --private-key $1 $2)
  address=$(echo $output | sed 's/^.*Address: //')
  cp $ETH_KEYSTORE_DIR/$2 $ETH_KEYSTORE_DIR/$address
  echo $output
}

function create() {
  DIR="$(dirname "$(realpath "$0")")"

  if [ ! -d $ETH_KEYSTORE_DIR ]; then
    mkdir $ETH_KEYSTORE_DIR
  fi

  if [ ! -z "$1" ]; then
    if [ -f $ETH_KEYSTORE_DIR/$1 ]; then
      echo "Named account already exists"
      exit 1
    fi
  fi

  output=$(cast wallet new $ETH_KEYSTORE_DIR)
  file=$(echo $output | sed 's/Created new encrypted keystore file: //' | sed 's/ Address:.*//')
  address=$(echo $output | sed 's/^.*Address: //')
  if [ ! -z "$1" ]; then
    cp $file $ETH_KEYSTORE_DIR/$1
  fi
  mv $file $ETH_KEYSTORE_DIR/$address
  echo "Created new wallet: $1"
  echo "Address: $address"
}

function address() {
  cast wallet address --account $1
}

function list() {
  cast wallet list
}

main $@
