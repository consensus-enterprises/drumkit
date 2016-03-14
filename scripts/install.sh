#!/bin/bash

echoerr() { echo "$@" 1>&2; }

if [[ ! -d .git ]]; then
  echoerr "ERROR: This script must be run at the root of a git repository."
  exit 1
fi

git submodule add https://github.com/ergonlogic/drumkit .mk
echo "include .mk/Makefile" > Makefile
