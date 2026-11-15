---
title: "Structured logging: making logs you can actually query"
author: Samuel Brandt
category: DevOps
published_at: 2024-07-15 10:15
tags: [logging, observability, debugging, devops]
image: 50-structured-logging-cover.png
image_alt: Code emitting a JSON log event with consistent field names and a request ID
summary: Free-form log lines are easy to write and painful to search. Emitting events with consistent fields turns logs into data.
---

During an incident, you need answers like "how many payment failures did customer 4812 hit in the last hour?" With free-form text logs, that's a fragile regex. With structured logs, it's a query.

## Text vs. structure

```text
Payment failed for order 4812 (customer 991) after 1873ms: card_declined
```

versus

```python
logger.info(
    "payment.failed",
    order_id=4812,
    customer_id=991,
    duration_ms=1873,
    reason="card_declined",
    request_id=request.id,
)
```

The second becomes a JSON object your log platform can index, filter and aggregate.

## Conventions that pay off

- **Stable event names:** `payment.failed`, not a sentence that changes with every edit.
- **Consistent field names across services:** pick `user_id` once and use it everywhere.
- **Units in names:** `duration_ms`, `size_bytes`.
- **Correlation IDs:** include a request or trace ID on every line so you can follow one request across services.
- **Levels that mean something:** `error` should be actionable, not just "unexpected."

## Add context once

Most logging libraries support context that's attached automatically — request ID, user ID, tenant — so individual log calls stay short and nothing gets forgotten.

## What not to log

- Passwords, tokens, API keys and session cookies.
- Full payment card numbers or other regulated data.
- Large request bodies by default — they're expensive to store and often contain personal data.

Use an allow-list of loggable parameters, or a filter that redacts known sensitive keys.

## Cost control

Logs can become one of your largest infrastructure bills. Sample noisy debug events, drop health-check logs and set retention per level: errors for months, debug for days.

## Logs, metrics and traces

Structured logs are the detailed record. Counting events is cheaper with metrics, and following a request across services is easier with traces. Shared IDs tie all three together.
