---
title: "How to write commit messages your future self will thank you for"
author: Editorial Team
category: Tools
published_at: 2024-09-28 13:10
tags: [git, commits, collaboration, writing]
image: 59-commit-messages-cover.png
image_alt: A git commit message with a short summary line and an explanatory body
summary: A commit message is a note to whoever runs git blame next year. A few conventions make history searchable and debugging faster.
---

Six months from now, someone will run `git blame` on a confusing line and land on your commit. The message is your only chance to explain why the code looks the way it does.

## The shape of a good message

```text
Retry webhook delivery with exponential backoff

Partners reported missing events during their maintenance
windows. We previously retried 3 times over 30 seconds, which
wasn't long enough for a typical restart.

Retries now back off exponentially for up to 6 hours.
Fixes #482
```

- **Summary line:** around 50 characters, imperative mood ("Add", "Fix", "Remove"), no trailing period.
- **Blank line**, then a **body** wrapped at about 72 characters.
- **Explain why**, not just what. The diff already shows what changed.

## The imperative mood test

A good summary completes the sentence "If applied, this commit will…":

- ✅ "Add rate limiting to the login endpoint"
- ❌ "Added rate limiting" / "Rate limiting stuff"

## Small, focused commits

One logical change per commit makes history easier to read, review and revert. "Fix login bug and refactor mailer and update dependencies" should be three commits.

## Conventions, if your team wants them

Some teams prefix messages with a type:

```text
feat: add CSV export to reports
fix: handle empty cart in checkout total
docs: document webhook retry policy
```

This enables automated changelogs and version bumps. It's useful, but optional — clarity matters more than format.

## Things to avoid

- "WIP", "fix", "changes" and "asdf" on shared branches
- Messages that only make sense with chat context
- Mixing formatting changes with logic changes

## Clean up before merging

Commit as messily as you like locally. Before opening a pull request, squash fixups and reword messages so the history you share tells a clear story.
