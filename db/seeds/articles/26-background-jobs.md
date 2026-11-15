---
title: "Background jobs that don't bite: idempotency, retries and timeouts"
author: Daniel Reyes
category: Web
published_at: 2025-08-02 10:20
tags: [background-jobs, reliability, queues]
image: 26-background-jobs-cover.png
image_alt: A background job that checks whether work was already done before charging a card
summary: Jobs will run twice, run late and fail halfway. Designing for that from the start is what separates a reliable queue from a source of 3 a.m. pages.
---

Moving slow work — emails, payments, image processing — into background jobs keeps web requests fast. It also introduces a distributed system, with all the failure modes that come with it.

## Assume at-least-once delivery

Most job systems guarantee a job runs *at least* once, not *exactly* once. A worker can crash after doing the work but before marking the job complete, and the job will run again.

So every job must be **idempotent**: running it twice has the same effect as running it once.

```ruby
class ChargeOrderJob < ApplicationJob
  def perform(order_id)
    order = Order.find(order_id)
    return if order.paid?          # already done — safe to exit

    Payments.charge(order, idempotency_key: "order-#{order.id}")
    order.update!(paid_at: Time.current)
  end
end
```

Pass an idempotency key to external APIs that support one, so a retried charge isn't a double charge.

## Pass IDs, not objects

Enqueue `order_id`, not a serialized order. By the time the job runs, the record may have changed — or been deleted. Load fresh data inside the job and handle "not found" gracefully.

## Retries with backoff

Transient failures — timeouts, rate limits — should retry, with exponential backoff and jitter so a thousand failed jobs don't all retry in the same second. Permanent failures — invalid data — should not retry forever. Send them to a dead-letter queue where a human can look.

## Timeouts everywhere

A job waiting forever on an unresponsive API ties up a worker forever. Set timeouts on HTTP calls and a maximum runtime for the job itself.

## Enqueue after commit

If you enqueue a job inside a database transaction that later rolls back, the job runs against data that doesn't exist. Enqueue after the transaction commits, or use a database-backed queue that shares the transaction.

## Watch the queue

Alert on queue depth and job latency — how long jobs wait before starting — not just on failures. A growing backlog is often the first sign something is wrong.

Jobs are where "works on my machine" goes to die. Idempotency, sane retries and timeouts make them boring, which is exactly what you want.
