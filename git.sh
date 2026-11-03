#!/bin/sh
# Install Git for the current user. J.C. Vaught.
set -eu

[ "$#" -eq 0 ] || { echo 'Usage: sh git.sh' >&2; exit 1; }
[ "$(uname -s)-$(uname -m)" = Linux-x86_64 ] || {
    echo 'Run this on a Linux x86_64 workstation.' >&2; exit 1;
}
install_dir="$HOME/.local/share/server-guide/git"
command_path="$HOME/.local/bin/git"
for target in "$install_dir" "$command_path"; do
    [ ! -e "$target" ] && [ ! -L "$target" ] || {
        echo "Already exists: $target" >&2; exit 1;
    }
done

work_dir=$(mktemp -d)
trap 'rm -rf -- "$work_dir"' 0
trap 'exit 1' HUP INT TERM
curl -fL -o "$work_dir/micromamba" \
    https://github.com/mamba-org/micromamba-releases/releases/download/2.10.0-0/micromamba-linux-64
printf '%s  %s\n' \
    701f39c06f8e6a670a0e186c8479b9e5c0502a2f0cda6cef65d83bdd2875e8bd \
    "$work_dir/micromamba" | sha256sum -c -
chmod +x "$work_dir/micromamba"
"$work_dir/micromamba" --no-rc --no-env --root-prefix "$work_dir/cache" \
    create --yes --prefix "$install_dir" --override-channels \
    --channel conda-forge 'git=2.56.0'
mkdir -p "$HOME/.local/bin"
ln -s "$install_dir/bin/git" "$command_path"
"$command_path" --version
path_line='export PATH="$HOME/.local/bin:$PATH"'
if ! grep -Fxq "$path_line" "$HOME/.bashrc" 2>/dev/null; then
    printf '\n%s\n' "$path_line" >> "$HOME/.bashrc"
fi
printf '\nGit is ready in new Bash terminals. To use it in this terminal, run:\n%s\n' "$path_line"
