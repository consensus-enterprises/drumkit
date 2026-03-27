#!/usr/bin/env bash
# This file reads the contents of a local .env file and exports
# its variables into the shell environment. Prints a colourful
# warning if it's not found, with info about how to create it.

ENVFILE="${ENVFILE:=.env}"

YELLOW="\033[1m\033[38;5;11m"
WHITE="\033[38;5;255m"
RESET="\033[0m"

if [[ -f "$ENVFILE" ]]; then
  export $(cat ${ENVFILE} | xargs)
else
  echo -e "${YELLOW}No ${ENVFILE} file found. Consider copying .env.tmpl and adding GitLab credentials.${RESET}"
  echo -e "${WHITE}Generate a Personal Access Token here: https://gitlab.com/-/user_settings/personal_access_tokens${RESET}"
fi
