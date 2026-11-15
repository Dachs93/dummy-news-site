---
title: "Immutability and persistent data structures for everyday developers"
author: Priya Natarajan
category: Languages
published_at: 2025-07-19 14:15
tags: [immutability, functional-programming, data-structures]
image: 36-immutability-cover.png
image_alt: JavaScript code creating an updated copy of an object instead of mutating it
summary: Data that never changes is easier to reason about, share and test. Persistent data structures make immutability practical without copying everything.
---

A huge class of bugs comes from one piece of code changing data another piece of code was still using. Immutability removes that class entirely: once created, a value never changes. To "modify" it, you create a new value.

## Immutability in practice

```js
const user = { name: "Ana", plan: "free" };

// mutation: anyone holding `user` sees the change
// user.plan = "pro";

// immutable update: a new object; the original is untouched
const upgraded = { ...user, plan: "pro" };
```

Many languages support this directly: frozen objects and strings in Ruby, tuples and frozen dataclasses in Python, `final` and records in Java, and immutability by default in Rust, Elixir and Clojure.

## Why it helps

- **Reasoning:** a value you were handed can't change behind your back.
- **Concurrency:** immutable data can be shared across threads without locks.
- **Change detection:** "did it change?" becomes a cheap reference comparison, which UI frameworks rely on.
- **Undo and history:** keep old versions around for free.

## Isn't copying expensive?

Copying a million-element list to change one item would be. **Persistent data structures** avoid that through *structural sharing*: the new version reuses most of the old version's internal nodes and only allocates the path that changed.

```text
old vector:   [root] → [a][b][c][d]
new vector:   [root'] → [a][b][c'][d]
                  shared: a, b, d   new: root', c'
```

Tree-based vectors and maps make updates cost roughly logarithmic time and memory instead of linear.

## Where to apply it

You don't need a purely functional language to benefit:

- Treat function arguments as read-only.
- Use value objects for things like money, dates and coordinates.
- Keep shared configuration and caches immutable.
- In UI state management, return new state instead of mutating.

## The trade-off

Immutable updates allocate more, and hot loops over large data can be faster with careful mutation. The pragmatic approach: immutable by default, mutable where profiling says it matters — and keep that mutation local.
