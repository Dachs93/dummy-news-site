---
title: "The case for boring technology"
author: Daniel Reyes
category: Web
published_at: 2024-02-27 08:50
tags: [architecture, engineering-culture, decisions]
image: 32-boring-technology-cover.png
image_alt: A short architecture decision record choosing a well-known database
summary: Every new technology you adopt spends some of your team's limited capacity for novelty. Spend it where it differentiates your product.
---

New tools are exciting. But every technology you adopt comes with unknowns: failure modes nobody on the team has seen, gaps in documentation, upgrade surprises. Choosing "boring" — mature, well-understood — technology isn't a lack of ambition. It's a budget decision.

## Innovation tokens

A useful mental model: each team gets a small number of "innovation tokens" to spend on unfamiliar technology. Spend one on a new database, a new language or a new deployment platform, and that's one fewer for the thing that makes your product unique.

## What "boring" buys you

- **Known failure modes.** Someone has already hit your bug and written about it.
- **Hiring.** More people already know it.
- **Ecosystem.** Libraries, monitoring integrations and hosting options exist.
- **Stability.** Fewer breaking changes and abandoned dependencies.

## Write the decision down

A short architecture decision record keeps the reasoning visible:

```markdown
# ADR 012: Use Postgres for the event store

Status: accepted
Context: we need durable, queryable event storage
Options: Postgres, a dedicated event database, a streaming platform
Decision: Postgres, with an append-only events table
Why: team expertise, existing backups and monitoring, adequate scale
Revisit if: write volume exceeds what one primary can handle
```

## When new technology is the right call

- It solves a problem your current tools genuinely can't.
- It's core to your product's differentiation.
- The team is prepared to own it — operate it, debug it and upgrade it.

## Questions to ask first

1. Can we solve this with what we already run, even if it's less elegant?
2. Who will be paged when it breaks at 3 a.m.?
3. What does it take to remove it if it doesn't work out?

## The point

Boring technology lets you spend your creativity on your users' problems instead of your infrastructure's. The most exciting products are often built on the least exciting stacks.
