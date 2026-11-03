#!/bin/sh
# Install GitHub CLI for the current user. J.C. Vaught.
set -eu

[ "$#" -eq 0 ] || { echo 'Usage: sh gh.sh' >&2; exit 1; }
[ "$(uname -s)-$(uname -m)" = Linux-x86_64 ] || {
    echo 'Run this on a Linux x86_64 workstation.' >&2; exit 1;
}
command_path="$HOME/.local/bin/gh"
[ ! -e "$command_path" ] && [ ! -L "$command_path" ] || {
    echo "Already exists: $command_path" >&2; exit 1;
}

work_dir=$(mktemp -d)
trap 'rm -rf -- "$work_dir"' 0
trap 'exit 1' HUP INT TERM
curl -fL -o "$work_dir/gh.tar.gz" \
    https://github.com/cli/cli/releases/download/v2.103.3/gh_2.103.3_linux_amd64.tar.gz
printf '%s  %s\n' \
    4c806978ffce1cec70853302a56d70ac6da4f19bae7adca4e1a8ab00633dd91d \
    "$work_dir/gh.tar.gz" | sha256sum -c -
tar -xzf "$work_dir/gh.tar.gz" -C "$work_dir" gh_2.103.3_linux_amd64/bin/gh
mkdir -p "$HOME/.local/bin"
cp "$work_dir/gh_2.103.3_linux_amd64/bin/gh" "$command_path"
chmod +x "$command_path"
"$command_path" --version
path_line='export PATH="$HOME/.local/bin:$PATH"'
if ! grep -Fxq "$path_line" "$HOME/.bashrc" 2>/dev/null; then
    printf '\n%s\n' "$path_line" >> "$HOME/.bashrc"
fi
printf '\nGitHub CLI is ready in new Bash terminals. To use it here, run:\n%s\n' "$path_line"
