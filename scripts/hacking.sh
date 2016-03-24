if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "This script must be sourced. Try \". /path/to/hacking.sh\"" 1>&2
  exit 1
else
  CWD=`pwd`
  export PATH="$CWD/.local/bin:$PATH"
fi
