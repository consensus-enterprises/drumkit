if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "This script must be sourced. Try \". ${BASH_SOURCE[0]}\"" 1>&2
  exit 1
else
  CWD=`pwd`
  if [[ -d .mk/ ]]; then
    BIN_PATH="$CWD/.mk/.local/bin"
  else
    BIN_PATH="$CWD/.local/bin"
  fi
  export PATH="$BIN_PATH:$PATH"
fi
