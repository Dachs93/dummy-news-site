---
title: "Monorepo or polyrepo? The trade-offs, honestly"
author: Editorial Team
category: Tools
published_at: 2024-04-02 08:00
tags: [monorepo, architecture, git, tooling]
image: 61-monorepo-vs-polyrepo-cover.png
image_alt: A monorepo directory tree with apps and shared packages
summary: Whether to keep all your code in one repository or many is mostly a question of tooling and team structure. Neither is free.
---

Some organizations keep every project in a single repository; others give each service or library its own. Both approaches power successful companies. The right choice depends on what you're optimizing for.

## The monorepo

```text
repo/
├── apps/
│   ├── web/
│   └── mobile-api/
├── packages/
│   ├── ui/
│   └── billing-client/
└── tools/
```

**Strengths**

- **Atomic changes:** update a shared library and all its callers in one pull request.
- **One source of truth** for tooling, linting and CI configuration.
- **Easy code sharing** and discoverability.
- **No version juggling** between internal packages.

**Costs**

- **Tooling:** builds and tests must be scoped to what changed, or CI grinds to a halt as the repo grows.
- **Access control** is coarser; restricting parts of a repo is harder.
- **Git performance** can degrade at very large sizes without extra tooling.

## The polyrepo

**Strengths**

- **Clear ownership and boundaries** per repository.
- **Independent release cycles** and simpler, faster CI per project.
- **Fine-grained permissions.**

**Costs**

- **Cross-cutting changes** require coordinated pull requests across repositories.
- **Dependency drift:** services end up on different versions of shared libraries.
- **Duplicated configuration** for CI, linting and tooling.

## How to decide

- **Small team, tightly coupled code:** a monorepo usually reduces friction.
- **Many autonomous teams with stable interfaces:** separate repositories may fit better.
- **Shared libraries that change often:** monorepos make that painless.
- **Strict access requirements:** polyrepos are simpler.

## Hybrid is fine

Many organizations land somewhere in between: a monorepo for the main product, separate repositories for open-source libraries or infrastructure. Optimize for how your teams actually work, and revisit the decision as they grow.
