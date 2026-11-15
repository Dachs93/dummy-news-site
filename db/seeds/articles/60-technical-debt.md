---
title: "Talking about technical debt so the business listens"
author: Editorial Team
category: Tools
published_at: 2024-06-29 12:15
tags: [technical-debt, engineering-management, communication]
image: 60-technical-debt-cover.png
image_alt: A tech debt register entry describing impact, cost and proposed fix
summary: Saying "we need to refactor" rarely wins a planning meeting. Framing debt in terms of risk, speed and cost does.
---

Every codebase accumulates technical debt: shortcuts taken to ship, designs that no longer fit, dependencies left to rot. Engineers feel the pain daily. Getting time to fix it depends on how you explain it.

## Not all debt is bad

Like financial debt, technical debt can be a smart trade: ship sooner, pay later. The problem is debt nobody tracks, with interest nobody measures.

## Translate it into outcomes

Instead of "the billing module is a mess," describe the effect:

- **Speed:** "Billing changes take three times longer than similar features."
- **Risk:** "Two of the last five incidents started in this module."
- **Cost:** "We spend about a day a week on manual reconciliation."
- **Opportunity:** "We can't offer annual plans until this is restructured."

## Keep a debt register

A lightweight list makes debt visible and comparable:

```yaml
- id: TD-14
  area: billing
  problem: invoice totals computed in three different places
  impact: 2 incidents this quarter; changes take ~3x longer
  fix: single InvoiceCalculator, migrate callers
  estimate: 2 weeks
  priority: high
```

Review it during planning alongside feature work.

## Pay it down continuously

Big-bang rewrites are risky and hard to justify. Steadier approaches tend to work better:

- **The boy-scout rule:** leave code a little better each time you touch it.
- **A fixed allocation:** a consistent slice of each cycle for maintenance.
- **Bundling:** fix the debt in the area you're about to build a feature on, and include the cost in the estimate.

## Measure the effect

After paying something down, report back: fewer incidents, faster delivery, less manual work. Showing the return on the last investment is the best argument for the next one.
