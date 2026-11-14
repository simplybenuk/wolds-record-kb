# Agent instructions

This repository is the public help site for Wolds Record, published at
<https://help.woldsrecord.com/>. Read [README.md](README.md) for the layout,
local checks and publishing process.

## Boundaries

- Everything here is public. Never add customer data, real client or dog
  names, secrets, tokens, internal URLs or private repository content beyond
  what a help page needs.
- Do not push to `main` or `gh-pages`. Work on a feature branch and open a
  draft pull request to `main`. Merging publishes the site, so only the owner
  merges or marks a pull request ready.
- Do not edit `gh-pages`, repository settings, secrets or workflows unless the
  task asks for it.
- The application repository, `simplybenuk/wolds-record`, is read-only for
  documentation work. Do not push branches, open pull requests, comment or
  change anything there.

## Making a change

1. Branch from the latest `main`.
2. Edit pages under `knowledge-base/`. Add new pages to `nav` in `mkdocs.yml`.
   Keep existing page paths stable, because they are public URLs.
3. Run `mkdocs build --strict` and markdownlint, as described in the README.
4. Open a draft pull request using the template, and say what you checked.

Follow the writing guidelines in the README.
