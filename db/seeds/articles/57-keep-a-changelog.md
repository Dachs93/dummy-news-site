---
title: "Keeping a changelog humans want to read"
author: Editorial Team
category: Open Source
published_at: 2025-03-14 14:30
tags: [changelog, documentation, releases]
image: 57-keep-a-changelog-cover.png
image_alt: A changelog entry grouping changes under added, changed and fixed headings
summary: A git log is not a changelog. A short, curated record of notable changes tells users what an upgrade means for them.
---

Commit messages are written for maintainers. A changelog is written for users, who want to know one thing: what does upgrading mean for me?

## A simple format

```markdown
## [2.4.0] - 2025-03-03

### Added
- `--watch` flag to rebuild on file changes

### Changed
- Default timeout raised from 5s to 30s

### Deprecated
- `legacyMode` option; will be removed in 3.0

### Fixed
- Crash when the config file is empty

### Security
- Updated XML parser to address an entity expansion issue
```

Group changes by type, newest version first, with dates.

## What to include

- New features users can see or use
- Changes in behavior or defaults
- Deprecations and removals
- Bug fixes users might have noticed
- Security fixes, clearly marked

## What to leave out

- Internal refactors, test changes and CI tweaks
- Dependency bumps that don't affect users
- "Fixed typo" commits

## Make breaking changes impossible to miss

Put them first in a major release, explain why they happened and show how to migrate:

```text
BREAKING: `parse()` now returns a Result instead of throwing.
Migrate: replace try/catch with `if (result.ok) { ... }`.
```

## Keep an "Unreleased" section

Add entries as changes merge, under an `Unreleased` heading. At release time, rename it to the new version. This spreads the work out and avoids reconstructing months of history from commit logs the night before a release.

## Generated vs. curated

Tools can draft changelogs from commit messages or pull request labels. That's a useful start — but a human pass to merge, reword and highlight what matters is what makes it readable.
