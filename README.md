mod-cli
==

Tools for working on mod projects.

## Dependencies

Install node 18 and go 1.20.

TODO add these steps to the installation script.

## Installation

```bash
# set up your secrets
$ cp .env.config .env

# run the install script
$ ./install.sh

# or similar, if not using zsh
$ source ~/.zshrc
```

## Usage

## Adding a new command

1. Create a new subfolder under `bin` with your command name, exactly as you want people to type it.
2. If you can write your command as a shell script, create a new index.sh file in that subfolder. Otherwise make it an index.js file.
3. Edit shell.sh and add your command/subcommands to the level 1/level 2 completion cases.
4. (optional) Edit mod.sh and add an alias for your command to make it easier to type in.
5. (optional) Add your command to the usage section of README.md.
