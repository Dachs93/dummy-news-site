---
title: "Contributing to open source without burning out maintainers"
author: Maya Okafor
category: Open Source
published_at: 2026-06-13 08:15
tags: [open-source, community, maintainers]
image: 10-open-source-maintainers-cover.png
image_alt: A pull request checklist from a CONTRIBUTING file
summary: Most maintainers are volunteers with limited time. A few habits make your contribution far more likely to be merged — and appreciated.
---

Open source runs on goodwill, and maintainer time is its scarcest resource. The most helpful contributors are the ones who make a maintainer's job easier.

## Before you write code

- **Read `CONTRIBUTING.md`.** It answers most questions before you ask them.
- **Search existing issues.** Your bug may already be reported, or your feature already declined.
- **Open an issue first for anything large.** A five-minute discussion can save you a week on a PR that won't be accepted.

## Writing a good bug report

1. The version you're using.
2. The smallest possible reproduction.
3. What you expected versus what happened.

```text
Version: 2.4.1
Steps: run `tool build --watch` in an empty directory
Expected: waits for changes
Actual: exits with "ENOENT: no such file or directory, scandir 'src'"
```

## Writing a good pull request

- **One change per PR.** Don't bundle a bug fix with a refactor and a formatting pass.
- **Include tests** that fail without your change.
- **Explain the why**, not just the what.
- **Be patient.** A week of silence usually means a busy maintainer, not a rejection.

## Other ways to help

Triaging issues, improving docs, answering questions and reproducing bugs are often more valuable than new features. And if your company depends on a project, consider sponsoring it.
