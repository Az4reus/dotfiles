#!/usr/bin/env sh
set -e 
PATH="/usr/local/bin:$PATH"
dir="`git rev-parse --git-dir`"
trap 'rm -rf "$dir/$$.tags"' EXIT
git ls-files | ctags --tag-relative -L - -f"$dir/$$.tags" --languages=-javascript,sql
mv "$dir/$$.tags" "$dir/tags"
