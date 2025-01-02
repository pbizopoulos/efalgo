#!/usr/bin/env bash
set -e

cd "$(dirname "$(realpath "$0")")"
nix run nixpkgs#http-server
cd -
