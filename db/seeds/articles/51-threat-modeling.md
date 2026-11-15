---
title: "Threat modeling for small teams in an afternoon"
author: Samuel Brandt
category: Security
published_at: 2024-04-22 09:30
tags: [security, threat-modeling, design, stride]
image: 51-threat-modeling-cover.png
image_alt: A threat model table listing a data flow, a threat category and a mitigation
summary: You don't need a security department to think like an attacker. A lightweight, repeatable session finds the risks worth fixing before they ship.
---

Threat modeling sounds like something for banks and governments. In practice, it's a structured conversation about four questions — and a small team can do it in an afternoon.

## The four questions

1. **What are we building?**
2. **What can go wrong?**
3. **What are we going to do about it?**
4. **Did we do a good job?**

## Step 1: draw it

Sketch the system: users, services, databases, third-party APIs and the data flowing between them. Mark **trust boundaries** — places where data crosses from less trusted to more trusted, like the internet into your API, or your app into a payment provider.

## Step 2: walk the boundaries with STRIDE

For each boundary, run through six categories:

| Letter | Threat | Example question |
| --- | --- | --- |
| S | Spoofing | Can someone pretend to be another user or service? |
| T | Tampering | Can data be modified in transit or at rest? |
| R | Repudiation | Could someone deny an action because we don't log it? |
| I | Information disclosure | Can data leak to someone who shouldn't see it? |
| D | Denial of service | Can someone exhaust a resource? |
| E | Elevation of privilege | Can a user gain permissions they shouldn't have? |

## Step 3: write it down

```text
flow: browser → /api/invoices/:id
threat: I — user requests another account's invoice by changing the ID
mitigation: scope lookups to current_account.invoices
owner: billing team   status: fixed in PR 482
```

Rank threats by likelihood and impact, fix the important ones and accept the rest knowingly.

## Step 4: repeat

Revisit the model when you add a feature that crosses a trust boundary: a new integration, file uploads, a public API, an admin tool.

## Tips

- Include someone who didn't build the feature — fresh eyes find assumptions.
- Keep it short. A one-page model that gets updated beats a perfect one that doesn't.
- Feed findings into normal tickets so they actually get done.

The goal isn't to find every possible attack. It's to make sure the obvious ones were considered on purpose.
