if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "This script must be sourced. Try \". ${BASH_SOURCE[0]}\"" 1>&2
  exit 1
fi

if [[ "$DRUMKIT" -gt 0 ]]; then
  echo "Drumkit is already bootstrapped."
  return
fi

CWD=`pwd`
if [[ -d .mk/ ]]; then
  BIN_PATH="$CWD/.mk/.local/bin"
else
  BIN_PATH="$CWD/.local/bin"
fi
export PATH="$BIN_PATH:$PATH"

export $(cat .env | xargs)

export DRUMKIT=1
