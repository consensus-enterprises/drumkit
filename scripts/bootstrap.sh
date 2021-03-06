#!/usr/bin/env bash
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "This script must be sourced. Try \". ${BASH_SOURCE[0]}\"" 1>&2
  exit 1
fi

if [[ -d ./drumkit/bootstrap.d/ ]]; then
  for file in `ls ./drumkit/bootstrap.d/*.sh`; do
    source $file
    if  [[ $? > 0 ]]; then return; fi
  done
fi
