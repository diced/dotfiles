#!/usr/bin/env bash

set -e

HOSTS=("nixos-sjc" "nixos-phx" "nixos-hp")
USER="diced"
REPO_DIR="~/nix"

deploy_host() {
    local host=$1

    echo "Deploying to $host..."

    local cmd="cd $REPO_DIR && git pull && switch n"

    if [[ "$(hostname)" == "$host" ]]; then
        eval "$cmd"
    else
        ssh -t "$USER@$host" "$cmd"
    fi
}

if [ -n "$1" ]; then
    deploy_host "$1"
else
    for host in "${HOSTS[@]}"; do
        deploy_host "$host"
    done
fi

