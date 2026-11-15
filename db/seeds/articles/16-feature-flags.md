---
title: "Feature flags: separating deploy from release"
author: Maya Okafor
category: DevOps
published_at: 2025-08-21 14:00
tags: [feature-flags, deployment, product]
image: 16-feature-flags-cover.png
image_alt: Ruby code checking a feature flag before rendering a new checkout flow
summary: Shipping code and turning on a feature don't have to happen at the same moment. Flags make releases boring — if you also clean them up.
---

A deploy puts code on servers. A release puts a feature in front of users. Feature flags let you do those at different times, and that separation removes most of the drama from shipping.

## The basic idea

```ruby
if Flags.enabled?(:new_checkout, user)
  render :checkout_v2
else
  render :checkout
end
```

The new checkout ships dark. You turn it on for staff, then 5% of users, then everyone — without another deploy. If something goes wrong, you flip it off in seconds.

## Kinds of flags

Not all flags are equal, and treating them the same is how codebases fill with dead branches.

| Type | Lifetime | Example |
| --- | --- | --- |
| Release | Days to weeks | New checkout behind a rollout |
| Experiment | Weeks | A/B test of pricing copy |
| Ops / kill switch | Long-lived | Disable recommendations under load |
| Permission | Permanent | Beta features for a plan tier |

Release flags should be **temporary** by design. Ops and permission flags are really configuration and can live on.

## Practices that keep flags healthy

- **Give every release flag an owner and an expiry date.** Put it in the flag's description.
- **Remove the flag in the same sprint you reach 100%.** Delete the old branch of code, not just the flag check.
- **Test both paths** while the flag exists.
- **Evaluate flags once per request** and pass the result down, so a user doesn't see half a page in each variant.
- **Keep the flag check at the edge** — controllers and views — instead of sprinkling it through domain logic.

## The payoff

Trunk-based development becomes practical: unfinished work merges behind a flag instead of living on a long-running branch. Rollbacks become toggles. And launches stop being tied to deploy windows, so marketing can pick the moment while engineering ships whenever it's ready.

The cost is discipline. A flag you never delete is just an `if` statement nobody understands.
