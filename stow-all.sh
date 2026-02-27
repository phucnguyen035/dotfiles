#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${HOME}"
PACKAGES=(nvim zellij ghostty agents fish)
STOW_ARGS=()

usage() {
  cat <<'EOF'
Usage: ./stow-all.sh [stow-options]

Applies all dotfile packages in this repository to a target directory.

Examples:
  ./stow-all.sh
  ./stow-all.sh -n
  ./stow-all.sh -R
  ./stow-all.sh -D
  ./stow-all.sh -t "$HOME" -R

Notes:
  - Defaults to target: $HOME
  - Any option not handled by this script is passed to `stow`
EOF
}

while (($# > 0)); do
  case "$1" in
    -t|--target)
      if (($# < 2)); then
        echo "Error: missing value for $1" >&2
        exit 1
      fi
      TARGET="$2"
      shift 2
      ;;
    --target=*)
      TARGET="${1#*=}"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      STOW_ARGS+=("$1")
      shift
      ;;
  esac
done

stow --dir="$SCRIPT_DIR" --target="$TARGET" "${STOW_ARGS[@]}" "${PACKAGES[@]}"
