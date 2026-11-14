# Knowledge agent: update the help site from app changes

Use this procedure to find shipped Wolds Record changes that the help site
does not cover yet, and to propose documentation for them as one draft pull
request in this repository. It works with any coding agent that can run a
shell, `git` and `gh`. Antigravity, Claude Code and Codex have thin entry
points that point here.

## Inputs

The person running the agent gives one of:

- a release version, for example `0.36.0` (preferred), or
- one or more application PR numbers, or
- a date range of merged application PRs.

If none is given, ask for a release version. Do not guess one.

Start from a branch that does not track `main`:

```bash
git fetch origin
git switch --no-track -c docs/<version or topic> origin/main
```

## Boundaries

These apply on top of [AGENTS.md](../AGENTS.md).

- **Application repository (`simplybenuk/wolds-record`): read only.** Read it
  with `gh` or with a fresh clone in a temporary directory. Never push, open
  or edit PRs or issues, comment, or run its scripts, tests, migrations or app.
- **This repository: feature branches only.** Branch from `main`, named
  `docs/<release or topic>`. Never push to `main` or `gh-pages`. Never merge,
  mark a PR ready, trigger `docs-deploy` or change settings.
- **No production data or secrets.** Do not use Supabase, Vercel, Stripe,
  PostHog, Resend or any production connector, and do not read `.env` files.
  The app repository's code, specifications, CHANGELOG and PRs are enough.
- **Shipped behaviour only.** A change is shipped when its release PR from
  `staging` to `main` has merged. Specifications, plans, open PRs and
  `staging`-only work describe intent; they are not evidence that a feature
  exists. When a feature is limited, for example to Calendar beta
  organisations or Stripe test mode, say so on the page.
- **Reachable behaviour only.** Merged code that users cannot reach yet is
  not available: for example, code behind an environment flag that is off in
  production, a beta flag, or links that only a disabled email sends. Find
  such gates in the code and in the CHANGELOG wording, never by reading
  environment values. Leave the change undocumented and list it in the PR.
- **Smallest useful change.** Extend an existing page before adding one.
  Do not rewrite pages that are still accurate, restyle unrelated text or
  rename existing pages. If the release adds to a feature the help site does
  not cover at all, do not write a partial page for this release's slice.
  List it in the PR as an open question with a suggested page outline, and
  leave the decision to the owner.
- **Nearby errors.** If a line you are already editing has a wrong label or
  fact that predates the release, fix it after checking the code, and list it
  separately in the PR. Do not search unrelated pages for errors.

## Procedure

### 1. Gather the changes

For a release, run:

```bash
scripts/app-release-context.sh <version>
```

It prints the release PR and whether it has shipped, the CHANGELOG section,
the PRs merged to `staging` since the previous release, and the issues the
CHANGELOG references. If it reports the release as not shipped, stop and tell
the person; offer to rerun after the release reaches `main`.

For PR numbers or a date range, read each PR with
`gh pr view <n> --repo simplybenuk/wolds-record --json title,body,files,mergedAt,baseRefName`
and confirm each change has reached `main`
(`gh api repos/simplybenuk/wolds-record/compare/<merge sha>...main --jq .status`
answers `ahead` or `identical` when it has).

### 2. Pick the user-facing changes

Keep changes a practitioner, organisation owner or dog owner would notice:
new screens, settings, actions, labels, emails, limits, permissions and error
messages. Drop CI, tests, QA tooling, dependency updates, refactors, internal
docs and changes with no visible effect.

Write a short list: change, source PRs, and who it affects.

### 3. Confirm the behaviour in code

For each kept change, read the merged code on `main`, not only the PR text:
routes and components under `app/`, logic under `src/`, and visible copy.
Note the exact on-screen labels, where the feature lives in the navigation,
who can use it (role, plan, beta flag), and any limits. Check permissions in
the server code (`app/api/`, server actions, `src/` access helpers), not only
in the UI: a button can show for roles that the server then refuses. Use specifications
under `spec/` only to understand intent, and check every claim against code.

If the code and the PR description disagree, follow the code and mention the
difference in the PR.

### 4. Compare with the help site

Search `knowledge-base/` for each change (`grep -ril` on its labels and
terms). Classify each one:

- **covered**: the page is accurate; no change.
- **outdated**: a page describes old behaviour; correct it.
- **missing**: nothing covers it; add a section to the closest existing page,
  or a new page if no page fits.

### 5. Write the documentation

- Follow the writing guidelines in [README.md](../README.md#writing-guidelines).
- Lead with the task the reader wants to do, then numbered steps that use the
  app's exact labels.
- Use the app's terms for things. Look at how existing pages name things such
  as organisation, case, session and vet report, and match them.
- For a new page, add it to `nav` in `mkdocs.yml` in the matching section, and
  link to it from at least one related page. Use relative links to `.md`
  files.
- Do not add screenshots. In the PR, list each screenshot that would help by
  page, section, screen and state, for example "Record sessions, Switch
  session form: the Switch session form? dialog".

### 6. Validate

```bash
mkdocs build --strict
npx markdownlint-cli2@0.24.0 "**/*.md" "!site/**" "!.github/**" "!.venv/**"
```

Run lychee too if it is available, with the command in the README. Fix every
error before opening the PR.

### 7. Open a draft PR

Commit on the feature branch. Check that `git branch --show-current` is the
feature branch, then push it with `git push -u origin HEAD` and open a draft
PR to `main` with `gh pr create --draft --base main`. Fill in the template:

- **Summary**: what readers can now find.
- **Source**: the release PR and each application PR or issue used, as full
  `https://github.com/simplybenuk/wolds-record/...` links. They are private to
  the app repository, so also give the PR title.
- **Pages changed**: each page with covered, outdated or missing, and any
  `nav` change.
- **Checks**: what you ran, and which facts you confirmed in code (file paths).
- **Screenshots**: the screenshots to add or update.
- Also list changes you chose not to document and why, nearby errors you
  fixed, and any open questions for the owner.

Do not mark the PR ready and do not merge it.

### 8. Report

Tell the person the PR URL, what was documented, what was skipped, and any
questions. If `gh` cannot push or open the PR, keep the branch, give the exact
error, and print the PR body so the person can open it.

## Permissions for unattended runs

Manual runs use the operator's own `gh` login. That login is the repository
admin, so every boundary in this procedure is an instruction, not a technical
control: the agent could merge its own PR or push past branch protection.
Someone must review each manual run's PR before merging it.

Do not schedule the agent until all of these are in place:

- **Two GitHub Apps as the agent's identity**, because an App's permissions
  apply to every repository it is installed on:
  - a reader App installed only on `simplybenuk/wolds-record`, with Contents,
    Pull requests, Issues and Metadata read;
  - a writer App installed only on `simplybenuk/wolds-record-kb`, with
    Contents and Pull requests read and write, and Metadata read.

  The scheduler creates short-lived installation tokens and gives them to the
  agent. The agent never holds either App's private key, which could mint
  other tokens. Do not use an admin's token, which bypasses branch protection
  here. Do not use a machine account: these repositories belong to a personal
  account, so a collaborator cannot be read-only on the private app
  repository, and fine-grained tokens do not cover collaborator access.
- **`main` protection that the writer App cannot satisfy alone**: a pull request,
  the `validate` check, one approving review, **Dismiss stale pull request
  approvals when new commits are pushed** and **Require approval of the most
  recent reviewable push**. Without the last two, the writer App could push after
  the owner approves and merge content nobody reviewed, and merging
  publishes. The owner, as admin, is the approver and can still bypass.
- **A `gh-pages` ruleset** that blocks updates from everyone except GitHub
  Actions, with no bypass for either App. Contents write otherwise lets it
  publish by pushing to `gh-pages` directly.

Measure the quality and cost of several manual runs before scheduling.
