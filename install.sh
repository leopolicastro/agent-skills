#!/usr/bin/env bash
# Install these agent skills + AGENTS.md for Crush and Claude Code.
#
# - Symlinks each skills/<name> into ~/.agents/skills/<name> (Crush) and
#   ~/.claude/skills/<name> (Claude Code) so `git pull` updates them in place.
# - Symlinks AGENTS.md to ~/.claude/CLAUDE.md if none exists; never clobbers
#   an existing file it didn't create.
#
# Idempotent: safe to re-run after every pull.
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skills_targets=("${HOME}/.agents/skills" "${HOME}/.claude/skills")
claude_md="${HOME}/.claude/CLAUDE.md"

warnings=0

link_into_place() {
  local src="$1" link="$2"

  mkdir -p "$(dirname "$link")"
  if [ -L "$link" ]; then
    ln -sfn "$src" "$link"
    echo "linked   $link -> $src"
  elif [ -e "$link" ]; then
    echo "WARNING: $link already exists and is not a symlink, left untouched." >&2
    echo "         Remove it (or merge it by hand) and re-run to manage it from this repo." >&2
    warnings=$((warnings + 1))
  else
    ln -s "$src" "$link"
    echo "linked   $link -> $src"
  fi
}

for target in "${skills_targets[@]}"; do
  for skill_dir in "$repo_dir"/skills/*/; do
    link_into_place "${skill_dir%/}" "$target/$(basename "$skill_dir")"
  done
done

link_into_place "$repo_dir/AGENTS.md" "$claude_md"

echo
if [ "$warnings" -gt 0 ]; then
  echo "Done with $warnings warning(s), see above."
  exit 1
fi
echo "Done. Run /skills in Claude Code, or check the skills list in Crush, to confirm."
