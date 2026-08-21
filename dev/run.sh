#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/Eng-ADAL/experimental_linux.git"
WORKDIR="${WORKDIR:-/opt/eng-workstation}"
LOG_DIR="/var/log/eng-workstation"
LOG_FILE="$LOG_DIR/eng-workstation.log"

main() {
    echo "[eng-workstation] preparing environment"

    if [[ ! -f /etc/debian_version ]]; then
        echo "[eng-workstation] Debian only. Aborting." >&2
        exit 1
    fi

    if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
        if command -v sudo >/dev/null 2>&1; then
            exec sudo -E bash -c "$(declare -f main); main" -- "$@"
        fi

        echo "[eng-workstation] root privileges required."
        echo "[eng-workstation] Run 'su -' and execute the command again." >&2
        exit 1
    fi

    if [[ -z "$WORKDIR" || "$WORKDIR" == "/" || "$WORKDIR" == "/opt" ]]; then
        echo "[eng-workstation] unsafe WORKDIR: $WORKDIR" >&2
        exit 1
    fi

    mkdir -p "$LOG_DIR"
    exec > >(tee -a "$LOG_FILE") 2>&1

    echo "[eng-workstation] log: $LOG_FILE"

    export DEBIAN_FRONTEND=noninteractive

    apt-get update
    apt-get install -y ca-certificates git wget sudo

    mkdir -p "$(dirname "$WORKDIR")"

    if [[ -d "$WORKDIR" ]]; then
        echo "[eng-workstation] removing existing workdir: $WORKDIR"
        rm -rf --one-file-system "$WORKDIR"
    fi

    git clone --depth 1 "$REPO_URL" "$WORKDIR"

    cd "$WORKDIR"

    bash ./bootstrap.sh "$@"
}

main "$@"
