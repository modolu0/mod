#!/bin/bash

main() {
  INSTALL_STATUS=0

  # 1. Check if golang is installed
  which go > /dev/null
  if [ $? -ne 0 ]; then
    echo "Error: Golang is not installed."
    INSTALL_STATUS=1
  fi

  # 2. Check if nodejs is installed
  which node > /dev/null
  if [ $? -ne 0 ]; then
    echo "Error: Node.js is not installed."
    INSTALL_STATUS=1
  fi

  # If either Golang or Node.js isn't installed, stop execution
  if [ $INSTALL_STATUS -ne 0 ]; then
    echo "Both Golang and Node.js must be installed to continue."
    exit 1
  fi

  # 3. Run npm install
  npm install -s

  # 4. Check if mod is accessible in user's path
  if [ "${_MOD_CLI_INIT:-0}" -ne 1 ]; then
    # Determine the user's shell and append to the appropriate rc file
    CURRENT_SHELL=$(basename $SHELL)
    _MOD_CLI_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    if [ "$CURRENT_SHELL" == "bash" ]; then
      echo -e "\nsource ${_MOD_CLI_PATH}/shell.sh" >> ~/.bashrc
      echo "Added mod to .bashrc. Don't forget to source ~/.bashrc"
    elif [ "$CURRENT_SHELL" == "zsh" ]; then
      echo -e "\nsource ${_MOD_CLI_PATH}/shell.sh" >> ~/.zshrc
      echo "Added mod to .zshrc. Don't forget to source ~/.zshrc"
    else
      echo "Unsupported shell. Please add mod to your shell rc manually:"
      echo "source ${_MOD_CLI_PATH}/shell.sh"
      exit 1
    fi
  else
    echo "The mod-cli has already been initialized."
  fi
}

main
