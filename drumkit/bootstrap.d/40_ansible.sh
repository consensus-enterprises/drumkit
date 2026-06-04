#!/usr/bin/env bash
CWD=`pwd`
if [[ -d .mk/ ]]; then
  PYTHONPATH="$CWD/.mk/.local/src/ansible/ansible-latest/lib"
else
  PYTHONPATH="$CWD/.local/src/ansible/ansible-latest/lib"
fi
export PYTHONPATH

ENV_SETUP_PATH=.mk/.local/src/ansible/ansible-latest/hacking/env-setup
if [[ -f $ENV_SETUP_PATH ]]; then
  source $ENV_SETUP_PATH > /dev/null
fi
