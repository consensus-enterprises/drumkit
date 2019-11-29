CWD=`pwd`
if [[ -d .mk/ ]]; then
  PYTHONPATH="$CWD/.mk/.local/src/ansible/ansible-latest/lib"
else
  PYTHONPATH="$CWD/.local/src/ansible/ansible-latest/lib"
fi
export PYTHONPATH
