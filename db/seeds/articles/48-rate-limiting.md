---
title: "Rate limiting algorithms: token bucket, fixed window and sliding window"
author: Samuel Brandt
category: Security
published_at: 2025-01-08 13:00
tags: [rate-limiting, security, api, reliability]
image: 48-rate-limiting-cover.png
image_alt: A token bucket implementation that refills tokens over time
summary: Rate limits protect logins from brute force and APIs from overload. The algorithm you choose decides how bursty traffic is treated.
---

Rate limiting caps how many requests a client can make in a period. It defends against brute-force login attempts, scraping and accidental overload from a buggy client. The interesting part is *how* you count.

## Fixed window

Count requests per client per calendar window — say, per minute — and reject once the count passes the limit.

- **Pro:** trivial with a counter and an expiry.
- **Con:** bursts at window boundaries. A client can send the full limit at 12:00:59 and again at 12:01:00 — double the intended rate in two seconds.

## Sliding window

Count requests over the last N seconds from *now*. An approximation weights the previous window's count by how much of it overlaps the current period:

```text
estimate = current_count + previous_count × (1 - elapsed_fraction)
```

Smooths out boundary bursts at little extra cost.

## Token bucket

Each client has a bucket holding up to `capacity` tokens, refilled at a steady rate. Each request spends a token; no token, no request.

```python
import time

class TokenBucket:
    def __init__(self, capacity, refill_per_sec):
        self.capacity = capacity
        self.tokens = capacity
        self.rate = refill_per_sec
        self.last = time.monotonic()

    def allow(self):
        now = time.monotonic()
        self.tokens = min(self.capacity, self.tokens + (now - self.last) * self.rate)
        self.last = now
        if self.tokens >= 1:
            self.tokens -= 1
            return True
        return False
```

Allows short bursts up to `capacity` while enforcing a long-run average. Popular for APIs.

## Practical concerns

- **What's the key?** IP address, user ID, API key, or a combination. Logins should limit per account *and* per IP.
- **Shared state:** with several servers, keep counters in a shared store, or limit at a proxy in front of them.
- **Tell clients:** return `429 Too Many Requests` with a `Retry-After` header.
- **Don't punish legitimate users:** many users can share one IP behind a corporate network or mobile carrier.

## Where to apply it

Login, signup, password reset and anything that sends email or SMS should always be rate limited. For APIs, publish your limits so client developers can build within them.
