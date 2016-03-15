#!/bin/bash

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

git submodule add https://github.com/ergonlogic/drumkit .mk
echo "include .mk/Makefile" > Makefile
