#!/usr/bin/env bash
# Print read-only context for documenting one Wolds Record release:
# the release PR to main, its CHANGELOG section, the PRs merged to staging
# since the previous release, and the issues the CHANGELOG references.
#
# Usage: scripts/app-release-context.sh 0.36.0
# A release has shipped once its "Release <version>" PR from staging to main
# has merged. An open release PR is reported as not shipped, and its
# CHANGELOG section is read from staging.
# Needs: gh, authenticated with read access to simplybenuk/wolds-record.
# Makes no changes anywhere.
set -euo pipefail

APP_REPO="${APP_REPO:-simplybenuk/wolds-record}"
version="${1:?usage: $0 <version, e.g. 0.36.0>}"
version="${version#v}"

# One line per release PR, oldest first: number state mergedAt|- title
releases="$(gh pr list --repo "$APP_REPO" --base main --head staging --state all --limit 100 \
  --json number,state,mergedAt,title \
  --jq '[.[] | select(.title | test("^Release [0-9]"))] | sort_by(.number) | .[] | "\(.number) \(.state) \(.mergedAt // "-") \(.title)"')"

pattern="^[0-9]+ [A-Z]+ [^ ]+ Release ${version//./\\.}([^0-9.]|$)"
current="$(grep -E "$pattern" <<<"$releases" | tail -n1 || true)"
[ -n "$current" ] || { echo "No 'Release $version' PR from staging to main in $APP_REPO" >&2; exit 1; }
read -r release_pr release_state release_merged _ <<<"$current"
previous="$(grep -B1 -E "$pattern" <<<"$releases" | grep -E '^[0-9]+ MERGED ' | grep -v "^$release_pr " | tail -n1 || true)"
previous_merged="$(awk '{ print $3 }' <<<"$previous")"

if [ "$release_state" = "MERGED" ]; then
  ref=main
  status="shipped to main $release_merged"
  until="$release_merged"
else
  ref=staging
  status="NOT SHIPPED (release PR is $release_state). Do not document it as available yet."
  until="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
fi

echo "# Wolds Record $version"
echo
echo "Release PR: https://github.com/$APP_REPO/pull/$release_pr"
echo "Status: $status"
echo "Previous release PR merged: ${previous_merged:-unknown}"
echo

echo "## CHANGELOG ($ref)"
echo
changelog="$(gh api "repos/$APP_REPO/contents/CHANGELOG.md?ref=$ref" -H 'Accept: application/vnd.github.raw')"
section="$(awk -v v="$version" '
  index($0, "## [" v "]") == 1 { on = 1; print; next }
  on && /^## \[/ { exit }
  on { print }' <<<"$changelog")"
if [ -n "$section" ]; then echo "$section"; else echo "(no CHANGELOG section for $version on $ref)"; fi
echo

echo "## PRs merged to staging since the previous release"
echo
since="${previous_merged:-2000-01-01T00:00:00Z}"
gh pr list --repo "$APP_REPO" --base staging --state merged --limit 200 \
  --search "merged:$since..$until" \
  --json number,title,mergedAt,files \
  --jq 'sort_by(.mergedAt) | .[] | "- #\(.number) \(.title) [areas: \([.files[].path | split("/")[0]] | unique | join(", "))]"'
echo

echo "## Issues and PRs referenced in the CHANGELOG section"
echo
for n in $(grep -oE '#[0-9]+' <<<"$section" | tr -d '#' | sort -un); do
  gh issue view "$n" --repo "$APP_REPO" --json number,title,state,url \
    --jq '"- #\(.number) [\(.state)] \(.title) \(.url)"' 2>/dev/null || echo "- #$n (not found)"
done
