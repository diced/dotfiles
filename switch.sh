#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Usage: $0 [darwin|d|nixos|n] [nh options...]"
}

case "${1:-}" in
  --help|-h)
    usage
    exit 0
    ;;
  darwin|d)
    target=darwin
    shift
    ;;
  nixos|n)
    target=os
    shift
    ;;
  ""|-*)
    case "$(uname -s)" in
      Darwin) target=darwin ;;
      Linux) target=os ;;
      *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
    esac
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac

config_name="${CONFIG_NAME:-$(hostname -s)}"
flake="${NH_FLAKE:-path:$HOME/nix}"

exec nh "$target" switch "$flake" -H "$config_name" "$@"
