#!/bin/sh
# Install Conda and Mamba for the current user. J.C. Vaught.
set -eu

[ "$#" -eq 0 ] || { echo 'Usage: sh miniforge.sh' >&2; exit 1; }
[ "$(uname -s)-$(uname -m)" = Linux-x86_64 ] || {
    echo 'Run this on a Linux x86_64 workstation.' >&2; exit 1;
}
install_dir="$HOME/miniforge3"
[ ! -e "$install_dir" ] && [ ! -L "$install_dir" ] || {
    echo "Already exists: $install_dir" >&2; exit 1;
}

work_dir=$(mktemp -d)
trap 'rm -rf -- "$work_dir"' 0
trap 'exit 1' HUP INT TERM
curl -fL -o "$work_dir/miniforge.sh" \
    https://github.com/conda-forge/miniforge/releases/download/26.9.4-1/Miniforge3-26.9.4-1-Linux-x86_64.sh
printf '%s  %s\n' \
    571b410272cc434f28bc6c5c49ca8ffd4a4d1bcba9f57f1b6baccdb46446cfcc \
    "$work_dir/miniforge.sh" | sha256sum -c -
bash "$work_dir/miniforge.sh" -b -p "$install_dir"
"$install_dir/bin/conda" init bash
"$install_dir/bin/mamba" shell init -s bash -r "$install_dir"
printf '\nConda and Mamba are ready. Open a new Bash terminal to use them.\n'
