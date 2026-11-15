---
title: "Before you ship an LLM feature, build an eval set"
author: Maya Okafor
category: AI & ML
published_at: 2024-06-12 13:15
tags: [ai, llm, testing, evaluation]
image: 21-llm-evals-cover.png
image_alt: A small eval script scoring model outputs against expected answers
summary: LLM features fail in ways unit tests don't catch. A few dozen labeled examples and a repeatable scoring script turn "it seems fine" into evidence.
---

Traditional code is deterministic: same input, same output, and a unit test pins it down. LLM-powered features are probabilistic, sensitive to prompt wording and can change behavior when you switch models. "I tried it a few times and it looked good" is not a release criterion.

## What an eval set is

A collection of realistic inputs with a way to judge each output:

```python
cases = [
    {"input": "Refund for order 4812, item arrived broken", "expect_intent": "refund"},
    {"input": "How do I change my password?",             "expect_intent": "account"},
    {"input": "asdfgh",                                    "expect_intent": "unknown"},
]

passed = sum(classify(c["input"]) == c["expect_intent"] for c in cases)
print(f"{passed}/{len(cases)} correct")
```

## Building one

1. **Start with real data.** Pull examples from logs, support tickets or user research — not inputs you invented to make the feature look good.
2. **Cover the edges.** Empty input, very long input, other languages, adversarial attempts, ambiguous requests.
3. **Start small.** Thirty to fifty well-chosen cases catch most regressions. Grow it as you find failures.
4. **Add every bug.** When a user reports a bad answer, it becomes a new case.

## Scoring

- **Exact match** works for classification and extraction.
- **Programmatic checks** work for structure: valid JSON, required fields present, length limits.
- **Model-graded scoring** — asking a model to judge against a rubric — helps for open-ended text, but spot-check its judgments against your own.
- **Human review** of a sample remains the ground truth.

## Use it like a test suite

Run the eval on every prompt change and every model upgrade, and track the score over time. A prompt tweak that fixes one complaint and silently breaks five other cases is the most common LLM regression — and an eval set is how you see it.

## The real benefit

Evals turn arguments about whether a change is "better" into numbers. That makes it safe to iterate quickly, swap models when a cheaper one is good enough and ship with confidence instead of hope.
