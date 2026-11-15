---
title: "Health checks that mean something: liveness vs. readiness"
author: Maya Okafor
category: DevOps
published_at: 2025-11-17 08:10
tags: [reliability, kubernetes, monitoring]
image: 15-health-checks-cover.png
image_alt: A terminal showing curl requests to separate liveness and readiness endpoints
summary: A health check that always returns 200 is worse than none. Separate "is the process alive?" from "can it serve traffic?" and your deploys get safer.
---

Load balancers, orchestrators and deploy tools all poll a health endpoint to decide where traffic goes. What that endpoint checks determines whether a bad deploy is caught in seconds or served to every user.

## Two different questions

- **Liveness:** *Is this process stuck?* If it fails, restart it.
- **Readiness:** *Can this process serve requests right now?* If it fails, stop sending traffic — but don't kill it.

Mixing them up causes real outages. If liveness checks the database and the database blips, every app instance gets restarted at once, turning a brief hiccup into a full outage.

```bash
$ curl -s -o /dev/null -w "%{http_code}\n" localhost:3000/livez
200
$ curl -s -o /dev/null -w "%{http_code}\n" localhost:3000/readyz
503   # still warming caches — keep it out of rotation
```

## What each should check

**Liveness** should be almost trivially cheap: the process can respond. Don't touch dependencies.

**Readiness** can check what the instance needs to do useful work:

- Configuration loaded and migrations applied
- Connection pool can reach the primary database
- Caches warmed, if a cold start would be painfully slow

## Rules of thumb

1. **Keep checks fast.** A health check that takes two seconds will time out under load — exactly when you need it most.
2. **Don't cascade.** Checking a downstream service in readiness means its outage takes you out of rotation too. Usually you'd rather serve degraded responses.
3. **Fail during boot.** Readiness should return non-200 until the app is genuinely ready, so deploy tools wait before switching traffic.
4. **Exclude health checks from noise.** Skip them in request logs, redirects and authentication.

## Deploy tooling depends on it

Zero-downtime deploys work by booting the new version, waiting for its health check, then moving traffic. If the check passes before the app can actually serve requests, the "zero downtime" deploy will drop requests anyway.

A good health endpoint is a few lines of code. It's also one of the highest-leverage reliability features you can add.
