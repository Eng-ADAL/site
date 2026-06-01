#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/Eng-ADAL/experimental_linux.git"
WORKDIR="${WORKDIR:-/opt/adal-workstation}"

echo "[eng-workstation] preparing environment"

if [[ ! -f /etc/debian_version ]]; then
  echo "[eng-workstation] Debian only. Aborting." >&2
  exit 1
fi

if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
  if command -v sudo >/dev/null 2>&1; then
    exec sudo -E bash "$0" "$@"
  fi

  cat >&2 <<'EOF'
[adal-workstation] sudo is not installed yet.

Switch to root and run again:

  su -
  bash /path/to/run.sh

EOF
  exit 1
fi

if [[ -z "$WORKDIR" || "$WORKDIR" == "/" || "$WORKDIR" == "/opt" ]]; then
  echo "[eng-workstation] unsafe WORKDIR: $WORKDIR" >&2
  exit 1
fi

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

bash ./bootstrap.sh --desktop sway
