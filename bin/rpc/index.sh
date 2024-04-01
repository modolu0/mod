#!/bin/bash

function main() {
  if [ $# -ne 2 ]; then
    echo "Usage:: mod rpc <network> <l1 | l2>"
    exit 1
  fi

  if [ $1 == "devnet" ]; then
    L1_RPC=http://localhost:8545
    L2_RPC=http://localhost:9545
  elif [ $1 == "testnet" ] || [ $1 == "sepolia" ]; then
    L1_RPC=$ETH_SEPOLIA_URL
    L2_RPC=https://sepolia.blast.io
  elif [ $1 == "mainnet-testnet" ]; then
    L1_RPC=$ETH_MAINNET_URL
    L2_RPC=http://fork-mainnet-testnet.develop-l2.testblast.io:8545
  elif [ $1 == "mainnet" ]; then
    L1_RPC=$ETH_MAINNET_URL
    L2_RPC="https://mainnet-rpc.blast.io/$BLAST_API_KEY"
  else
    echo "Unsupported network $1"
    exit 1
  fi

  if [ $2 == "l1" ]; then
    RPC=$L1_RPC
  elif [ $2 == "l2" ]; then
    RPC=$L2_RPC
  else
    echo "Unrecognized layer $2"
    exit 1
  fi

  echo $RPC
}

main $@
