---
title: "Semantic versioning: what the three numbers promise"
author: Editorial Team
category: Open Source
published_at: 2025-12-03 12:10
tags: [semver, versioning, dependencies, open-source]
image: 54-semantic-versioning-cover.png
image_alt: Dependency version constraints using caret and tilde ranges
summary: MAJOR.MINOR.PATCH is a contract between library authors and users. Understanding it helps you upgrade safely and publish responsibly.
---

Semantic versioning (SemVer) gives version numbers meaning: `MAJOR.MINOR.PATCH`.

- **PATCH** (1.4.**2**) — backwards-compatible bug fixes.
- **MINOR** (1.**5**.0) — backwards-compatible new features.
- **MAJOR** (**2**.0.0) — breaking changes.

If a library follows SemVer, upgrading from 1.4.2 to 1.9.0 should never break your code. Upgrading to 2.0.0 might.

## Version ranges in practice

Package managers use this contract to decide which upgrades are safe:

```json
{
  "dependencies": {
    "web-framework": "^4.2.0",
    "date-utils":    "~1.8.3",
    "parser":        "2.0.1"
  }
}
```

- `^4.2.0` — any 4.x version at or above 4.2.0.
- `~1.8.3` — patch updates only: 1.8.x.
- `2.0.1` — exactly this version.

Your lockfile then pins exact versions so every install is identical until you deliberately update.

## The 0.x exception

Before 1.0.0, anything may change at any time. Many tools treat each 0.MINOR as potentially breaking. If people depend on your library in production, it's probably time for 1.0.

## What counts as breaking?

More than you might think:

- Removing or renaming public functions, options or fields
- Changing default behavior
- Raising the minimum supported language or runtime version
- Changing error types that callers catch

## For library authors

- Document what your public API is, so users know what's covered by the promise.
- Deprecate before removing: warn in a minor release, remove in the next major.
- Keep a changelog that calls out breaking changes clearly.

## For users

SemVer is a promise, not a guarantee — mistakes happen. Keep a test suite, update dependencies regularly in small steps, and read changelogs before major upgrades.
