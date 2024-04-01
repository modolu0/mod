#!/bin/bash

function _mod_complete() {
  local cur prev options

  # The current word being typed.
  cur="${COMP_WORDS[COMP_CWORD]}"

  # The previous word.
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  if [[ ${COMP_CWORD} -eq 1 ]]; then
    options="balance script send call address verify pk wallet rpc"
  elif [[ ${prev} == "balance" ||  ${prev} == "script" || ${prev} == "send" || ${prev} == "call" || ${prev} == "rpc" ]]; then
    options="mainnet sepolia"
  elif [[ ${prev} == "mainnet" || ${prev} == "sepolia" ]]; then
    options="l1 l2"
  elif [[ ${prev} == "verify" ]]; then
    options="etherscan blastscan tenderly"
  elif [[ ${prev} == "wallet" ]]; then
    options="create add address list"
  fi

  # Use compgen to generate possible matches and assign to COMPREPLY.
  COMPREPLY=($(compgen -W "${options}" -- ${cur}))
  return 0
}

# Indicate that mod-cli has been initialized to other scripts
export _MOD_CLI_INIT=1

# Figure out where the mod-cli was installed
_MOD_CLI_PATH=""
if [[ "$0" == *bash* ]]; then
    # For bash
    _MOD_CLI_PATH="$(dirname "${BASH_SOURCE[0]}")"
elif [[ "$ZSH_VERSION" != "" ]]; then
    # For zsh
    _MOD_CLI_PATH="$(dirname "$0")"
else
    echo "Unsupported shell. Could not determine mod cli path."
    return 1
fi

# register the shell completions for all the mod-cli aliases
# (zsh does this automatically but bash doesn't)
complete -F _mod_complete "${_MOD_CLI_PATH}/mod.sh"
complete -F _mod_complete mod 
complete -F _mod_complete m

# convenient aliases
alias mod="${_MOD_CLI_PATH}/mod.sh"
alias m=mod

# cleanup
unset _MOD_CLI_PATH
