---
title: How to get your CI pipeline under ten minutes
author: Maya Okafor
category: Tools
published_at: 2025-02-25 07:30
tags: [ci, testing, productivity]
image: 18-fast-ci-cover.png
image_alt: A CI configuration that runs lint, tests and builds as parallel jobs with caching
summary: Slow CI quietly taxes every pull request. Measure first, then cache, parallelize and stop doing work that doesn't matter.
---

When CI takes 30 minutes, developers batch changes, context-switch while waiting and merge larger, riskier pull requests. Getting feedback under ten minutes changes how a team works.

## Measure before optimizing

Most CI systems show per-step timings. Look for the long poles: dependency installation, a single giant test job, or Docker builds with no cache. Fix the biggest one first.

## Cache dependencies

Reinstalling every package on every run is the most common waste. Key the cache on your lockfile:

```yaml
jobs:
  test:
    steps:
      - uses: actions/checkout@v4
      - uses: actions/cache@v4
        with:
          path: vendor/bundle
          key: gems-${{ hashFiles('Gemfile.lock') }}
      - run: bundle install --path vendor/bundle
      - run: bin/rails test
```

## Run independent work in parallel

Linting, security scans, unit tests and image builds rarely depend on each other. Run them as separate jobs so total time equals the slowest job, not the sum.

## Split the test suite

Shard tests across several runners. Splitting by historical timing balances shards better than splitting by file count, so one runner isn't stuck with all the slow tests.

## Do less work

- **Skip unaffected work** in monorepos by running jobs only when relevant paths change.
- **Kill sleeps and real network calls** in tests; they're slow and flaky.
- **Move rare checks** (full browser matrices, long fuzzing runs) to a nightly schedule.
- **Cancel superseded runs** when a new commit is pushed to the same branch.

## Treat flakiness as a bug

A flaky test that forces reruns doubles CI time for everyone it hits. Track flaky tests, quarantine them quickly and fix or delete them.

## Keep it fast

CI time creeps up as a codebase grows. Put the duration on a dashboard and treat a regression like any other performance regression. Ten minutes is a budget, not a one-time achievement.
