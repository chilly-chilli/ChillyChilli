#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

echo "== Quartz prepublish check =="
git status --short --branch

echo
echo "== Checking Obsidian callout markers =="
if rg -n '^>\[!' content; then
  cat <<'MSG'

Found Obsidian callouts without a space after ">".
Use:
  > [!note]
instead of:
  >[!note]
MSG
  exit 1
fi
echo "OK: no malformed callout markers found."

echo
echo "== Checking leading thematic breaks =="
leading_breaks="$(
  find content -type f -name '*.md' -print0 |
    xargs -0 perl -0ne 'print "$ARGV\n" if /\A\s*---\n#/'
)"
if [[ -n "$leading_breaks" ]]; then
  cat <<'MSG'

Found Markdown files that start with a standalone "---" followed by a heading.
Remove the leading "---" or replace it with valid YAML frontmatter.

Files:
MSG
  printf '%s\n' "$leading_breaks"
  exit 1
fi
echo "OK: no ambiguous leading thematic breaks found."

echo
echo "== Restoring Quartz 5 plugins =="
./quartz/bootstrap-cli.mjs plugin install --clean

echo
echo "== Building Quartz =="
./quartz/bootstrap-cli.mjs build

echo
echo "OK: Quartz prepublish check passed."
