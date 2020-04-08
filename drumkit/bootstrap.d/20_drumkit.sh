#!/usr/bin/env bash
if [[ "$DRUMKIT" -gt 0 ]]; then
  echo "Drumkit is already bootstrapped."
  return 10
fi
