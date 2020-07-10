#!/usr/bin/env bash
CWD=`pwd`
if [[ -f "$CWD/.mk/.local/bin/activate" ]]; then
  source "$CWD/.mk/.local/bin/activate"
fi
