#!/usr/bin/env bash
CWD=`pwd`
if [[ -d .mk/ ]]; then
  BIN_PATH="$CWD/.mk/.local/bin"
else
  BIN_PATH="$CWD/.local/bin"
fi
export PATH="$BIN_PATH:$PATH"
