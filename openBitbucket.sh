#!/bin/bash

source ~/.config/waybar/prs/.env

open_bitbucket_url() {
  if [ -z "$BITBUCKET_URL" ]; then
    return 1
  fi

  if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$BITBUCKET_URL"
  elif command -v open >/dev/null 2>&1; then
    open "$BITBUCKET_URL"
  else
    return 1
  fi
}

open_bitbucket_url
