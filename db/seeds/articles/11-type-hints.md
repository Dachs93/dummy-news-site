---
title: "Gradual typing in practice: adding types to a large dynamic codebase"
author: Priya Natarajan
category: Languages
published_at: 2026-05-28 13:45
tags: [typescript, python, typing, refactoring]
image: 11-type-hints-cover.png
image_alt: A typed Python dataclass and function signature
summary: You don't have to type everything at once. A step-by-step strategy for introducing type checking to an existing project without stopping feature work.
---

Python, Ruby and JavaScript all have optional type systems now. Starting a new project with types is easy. Adding them to a 200,000-line codebase is a different problem.

## Start at the edges

Types pay off most at **boundaries**: public APIs, service clients, serialization code. Annotating those first gives every caller better autocomplete and error checking.

```python
from dataclasses import dataclass

@dataclass
class Invoice:
    id: int
    customer_email: str
    total_cents: int

def fetch_invoice(invoice_id: int) -> Invoice | None:
    ...
```

## Ratchet, don't mandate

1. Turn the checker on in **permissive** mode for the whole project.
2. Enable **strict** mode per-directory as each area gets cleaned up.
3. Add a CI check that **new files** must pass strict mode.
4. Track the number of untyped files over time and make it go down.

```jsonc
// tsconfig.json — tighten gradually
{
  "compilerOptions": {
    "allowJs": true,
    "checkJs": false,
    "strict": true
  },
  "include": ["src/billing/**/*", "src/api/**/*"]
}
```

## Avoid the escape-hatch trap

`any` (or `Any`) silences the checker — and spreads. Prefer `unknown` plus a type guard, and lint for new `any` usages.

## What you get

Fewer "undefined is not a function" bugs in production, safer refactors, and onboarding docs that can't go stale: the types *are* the documentation.
