#!/usr/bin/env bash
# Install drumkit in .mk for development purposes as a submodule using SSH 

echoerr() { echo "$@" 1>&2; }

which git > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echoerr "ERROR: This script requires git to be installed."
  exit 1
fi

if [[ ! -d .git ]]; then
  echoerr "ERROR: This script must be run at the root of a git repository."
  exit 1
fi

git submodule add git@gitlab.com:consensus.enterprises/drumkit.git .mk
git submodule update --recursive --init
echo "include .mk/GNUmakefile" >> Makefile

make init-drumkit

