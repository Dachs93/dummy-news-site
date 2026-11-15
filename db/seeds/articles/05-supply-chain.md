---
title: "Your dependencies are your attack surface: a supply-chain security checklist"
author: Samuel Brandt
category: Security
published_at: 2026-09-06 14:30
tags: [security, dependencies, supply-chain]
image: 05-supply-chain-cover.png
image_alt: Shield icon beside a CI log showing dependency audits with no vulnerabilities
summary: Most of the code you ship, you didn't write. A short, practical checklist for keeping third-party packages from becoming your next incident.
---

A typical web application pulls in hundreds of transitive dependencies. Each one is code that runs with your app's permissions. Supply-chain attacks target exactly that trust.

## The checklist

### 1. Commit your lockfile

`Gemfile.lock`, `package-lock.json`, `Cargo.lock`, `uv.lock` — commit them all. Builds should install exactly what you tested, not whatever was published five minutes ago.

### 2. Audit continuously

Run an advisory scanner in CI on every pull request, not just once a quarter.

```bash
bundle exec bundler-audit check --update
npm audit --omit=dev
```

### 3. Be suspicious of install scripts

Packages that execute code at install time deserve extra scrutiny. Many package managers let you disable install scripts by default and allow-list the few that need them.

### 4. Watch for typosquats

`reqeusts` is not `requests`. Review new dependencies in code review like any other change: who maintains it, how old is it, how many downloads?

### 5. Pin your CI actions

Reference third-party CI actions by commit SHA, not a mutable tag. A tag can be moved; a SHA can't.

### 6. Minimize what ships

Multi-stage Docker builds keep compilers and dev dependencies out of production images. Less code shipped means less code to exploit.

## The mindset

You can't review every line of every dependency. You *can* control what gets in, keep it current, and limit what it can reach.
