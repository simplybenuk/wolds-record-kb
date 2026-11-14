# Wolds Record knowledge base

Source for the public help site at <https://help.woldsrecord.com/>.

This repository is the only editable source of the public help content. The
Wolds Record application repository (`simplybenuk/wolds-record`, private) keeps
the product code, specifications, plans and internal engineering
documentation. It no longer holds a copy of these pages.

## Layout

| Path | Purpose |
| --- | --- |
| `knowledge-base/` | Published Markdown pages, plus `CNAME` for the custom domain |
| `mkdocs.yml` | Site configuration and navigation |
| `requirements-docs.txt` | Pinned MkDocs and Material versions |
| `.markdownlint-cli2.jsonc`, `.lychee.toml` | Lint and link-check settings |
| `.github/workflows/ci.yml` | `docs-ci`: validates every pull request |
| `.github/workflows/deploy.yml` | `docs-deploy`: publishes `main` to `gh-pages` |

Branches:

- `main` holds the source. Change it through pull requests.
- `gh-pages` holds the generated site that GitHub Pages serves. Only
  `docs-deploy` writes to it. Do not edit it by hand.

## Edit and preview locally

```bash
python -m venv .venv
. .venv/bin/activate
pip install -r requirements-docs.txt
mkdocs serve
```

Before opening a pull request, run the same checks as CI:

```bash
mkdocs build --strict
npx markdownlint-cli2 "**/*.md" "!site/**" "!.venv/**"
```

CI also checks links with [lychee](https://lychee.cli.rs/). Run
`lychee --config .lychee.toml --exclude-path site --exclude-path .venv "./**/*.md"`
locally if you have it installed.

When you add a page, add it to `nav` in `mkdocs.yml`. Keep existing page paths
stable: each path is a public URL that other pages, emails and the app may link
to. If a page has to move, leave a short page at the old path that links to
the new one.

## Validate and publish

1. Work on a branch and open a pull request to `main`. Draft pull requests are
   fine; `docs-ci` runs on every pull request, including drafts.
2. `docs-ci` runs `mkdocs build --strict`, markdownlint and lychee. Its
   `validate` job must pass before merging.
3. Merging to `main` runs `docs-deploy`. It builds the site, pushes it to
   `gh-pages` with the repository's own `GITHUB_TOKEN`, waits for GitHub Pages
   to build that commit, and then requests a few pages from
   `help.woldsrecord.com`.

Publishing does not depend on an application release. You can also rerun a
deploy of `main` from the Actions tab (`docs-deploy`, **Run workflow**).

### Settings this depends on

- **Settings → Pages**: source is **Deploy from a branch**, branch `gh-pages`,
  folder `/ (root)`, custom domain `help.woldsrecord.com`, HTTPS enforced.
- **Settings → Actions → General**: workflow permissions can stay
  read-only by default. `docs-deploy` asks for `contents: write` on its one
  job.
- `knowledge-base/CNAME` must contain `help.woldsrecord.com`. MkDocs copies it
  into the site. Both workflows fail if it is missing, because publishing
  without it would remove the custom domain.

### Roll back a deploy

`gh-pages` keeps its history, so each deploy is one commit named
`deploy: simplybenuk/wolds-record-kb@<source sha>`.

- Preferred: revert the bad change on `main` through a pull request. The merge
  republishes the site.
- Emergency: revert the deploy commit on `gh-pages` directly, then fix `main`
  before the next merge, because the next deploy replaces the whole branch
  contents.

```bash
git fetch origin gh-pages
git switch gh-pages
git revert --no-edit <bad deploy commit>
git push origin gh-pages
```

## Writing guidelines

- Write for practitioners and organisation owners, in plain UK English.
- Describe what the app does now. Do not document planned or beta-only
  behaviour as generally available. Say clearly when a feature is limited, for
  example to Calendar beta organisations.
- Use the labels the app shows on screen.
- Never include customer data, real client or dog names, secrets or internal
  URLs. Screenshots must use test data only.

## Agents

Coding agents start with [AGENTS.md](AGENTS.md).
