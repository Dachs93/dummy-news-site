---
title: "Debugging methodically: treat bugs like experiments"
author: Editorial Team
category: Tools
published_at: 2024-01-09 07:20
tags: [debugging, git, problem-solving]
image: 62-methodical-debugging-cover.png
image_alt: A git bisect session narrowing down the commit that introduced a bug
summary: Random changes and hopeful restarts waste hours. A scientific approach — reproduce, hypothesize, test, narrow — finds bugs faster.
---

When a bug is confusing, it's tempting to change things until it goes away. Sometimes that works. Often it burns an afternoon and leaves you unsure what fixed it. A methodical approach is faster on average, and it teaches you something every time.

## 1. Reproduce it reliably

You can't fix what you can't trigger. Find the smallest set of steps, inputs or data that makes the bug happen every time. Turn it into a failing automated test if you can — that test becomes proof of the fix later.

## 2. Gather facts

Read the actual error message and stack trace, all of it. Check logs around the time it happened. Note what changed recently: deploys, config, data, dependencies.

## 3. Form a hypothesis

State a specific, testable explanation: "The cache returns stale prices after a currency change." Vague hunches like "something's wrong with caching" can't be tested.

## 4. Test it — and change one thing at a time

Design an experiment that would prove the hypothesis wrong. Add a log line, write a test, toggle one setting. Changing several things at once makes results impossible to interpret.

## 5. Narrow the search space

Binary search is the most powerful debugging tool there is:

```bash
git bisect start
git bisect bad              # current commit is broken
git bisect good v2.3.0      # this release worked
# git checks out a midpoint; test it, then:
git bisect good             # or: git bisect bad
# ...repeat until git names the first bad commit
git bisect reset
```

The same idea applies to code, data and configuration: cut the problem in half until only the cause remains.

## 6. Explain it

Describing the problem out loud — to a colleague or a rubber duck — forces you to state assumptions, and one of them is often wrong.

## 7. Fix the cause, then prevent it

Fix the root cause rather than the symptom, keep the failing test as a regression test, and ask whether the same mistake could exist elsewhere.

## Take breaks

After an hour of going in circles, step away. A fresh perspective finds in minutes what a tired one misses for hours.
