#!/usr/bin/env bash
set -e

if [ -z "${DEBUG}" ]; then
  cd "$(dirname "$(realpath "$0")")"
  nix run nixpkgs#http-server
  cd -
fi
