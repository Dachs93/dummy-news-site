---
title: "SLOs and error budgets: deciding how reliable is reliable enough"
author: Samuel Brandt
category: DevOps
published_at: 2024-10-11 15:50
tags: [sre, reliability, slo, monitoring]
image: 49-slos-error-budgets-cover.png
image_alt: An SLO definition targeting 99.9 percent of checkout requests succeeding within 500 milliseconds
summary: 100% uptime is the wrong goal. Service level objectives turn reliability into a number you can plan around, and error budgets tell you when to slow down.
---

"The site should never go down" isn't a goal — it's a wish, and chasing it makes every change feel dangerous. Service level objectives (SLOs) replace it with an explicit, measurable target.

## The vocabulary

- **SLI (indicator):** a measurement of user experience, such as the fraction of requests that succeed quickly.
- **SLO (objective):** the target for that measurement over a time window.
- **Error budget:** the amount of unreliability the SLO permits.

```yaml
slo:
  name: checkout-availability
  sli: requests with status < 500 and latency < 500ms
  target: 99.9%
  window: 30d
# error budget ≈ 43 minutes of full outage per 30 days
```

## Choosing SLIs

Measure what users feel, as close to them as possible:

- Availability: did the request succeed?
- Latency: did it succeed *fast enough*?
- Freshness: is the data shown recent enough?

CPU usage and memory are useful for debugging, but they aren't SLIs — users don't experience them directly.

## Picking a target

Each extra nine costs dramatically more. Your users probably can't tell 99.95% from 99.99%, especially if their own network fails more often than that. Start with something you currently achieve, then tighten if users need it.

## Spending the budget

The error budget is what makes SLOs useful:

- **Budget remaining:** ship features, run experiments, take reasonable risks.
- **Budget exhausted:** slow down, focus on reliability work until you recover.

This turns the eternal argument between "ship faster" and "be careful" into a shared, data-driven rule.

## Alerting on burn rate

Instead of paging on every error spike, alert when the budget is being consumed too fast — for example, at a rate that would exhaust a month's budget in a couple of days. That catches real incidents and ignores harmless blips.

## Start with one

Pick your most important user journey — login, checkout, search — define one SLO, put it on a dashboard and review it monthly. That alone changes how a team talks about reliability.
