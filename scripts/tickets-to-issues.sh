#!/usr/bin/env bash
# Turn every ticket in tickets/phase-*/ into a GitHub issue.
#
#   ./scripts/tickets-to-issues.sh            dry run: print what would be created
#   ./scripts/tickets-to-issues.sh --create   create labels and issues (needs `gh auth login`)
#
# Safe to re-run: a ticket whose id already appears in an open or closed issue title is skipped.
set -euo pipefail

cd "$(dirname "$0")/.."
CREATE=false
[[ "${1:-}" == "--create" ]] && CREATE=true

field() { # field <name> <file> -> value of a frontmatter field
  awk -v k="$1" 'NR==1 && $0=="---"{f=1; next} f && $0=="---"{exit} f && $0 ~ "^"k":" {sub("^"k":[ ]*",""); sub(/[ ]+#.*$/,""); gsub(/^"|"$/,""); print; exit}' "$2"
}
body() { # everything after the closing frontmatter fence
  awk 'NR==1 && $0=="---"{f=1; next} f==1 && $0=="---"{f=2; next} f==2{print}' "$1"
}

if $CREATE; then
  command -v gh >/dev/null || { echo "Install the GitHub CLI first: https://cli.github.com"; exit 1; }
  existing=$(gh issue list --state all --limit 500 --json title --jq '.[].title')
  for l in phase:0-foundations phase:1-brand-system phase:2-motion-engine phase:3-home phase:4-pages \
           phase:5-platform phase:6-quality-launch type:design type:dev type:3d type:motion type:content \
           type:qa size:S size:M size:L "good first issue"; do
    gh label create "$l" --force >/dev/null
  done
else
  existing=""
fi

for f in tickets/phase-*/XYB-*.md; do
  id=$(field id "$f"); title=$(field title "$f")
  phase=$(field phase "$f"); type=$(field type "$f"); size=$(field size "$f")
  gfi=$(field good_first_issue "$f"); deps=$(field depends_on "$f")
  labels="phase:$phase,type:$type,size:$size"
  [[ "$gfi" == "true" ]] && labels="$labels,good first issue"
  issue_title="$id: $title"

  if grep -qF "$id:" <<<"$existing"; then
    echo "skip   $issue_title (already exists)"; continue
  fi
  if $CREATE; then
    { echo "> Ticket file: \`$f\` · Depends on: $deps"; echo; body "$f"; } \
      | gh issue create --title "$issue_title" --label "$labels" --body-file - >/dev/null
    echo "create $issue_title"
  else
    echo "would  $issue_title  [$labels]  deps: $deps"
  fi
done
