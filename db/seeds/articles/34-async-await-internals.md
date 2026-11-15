---
title: "What async/await actually does under the hood"
author: Priya Natarajan
category: Languages
published_at: 2026-01-06 08:05
tags: [async, concurrency, javascript, python]
image: 34-async-await-internals-cover.png
image_alt: Python asyncio code running two network fetches concurrently with gather
summary: async/await looks like sequential code but runs very differently. Understanding event loops and suspension points explains the performance — and the pitfalls.
---

`async`/`await` exists in JavaScript, Python, C#, Rust, Swift and Kotlin. The syntax hides a simple idea: a function that can **pause** while it waits, letting other work run on the same thread.

## The event loop

An event loop is a scheduler. It holds tasks that are ready to run and tasks waiting for something — a network response, a timer. It runs ready tasks one at a time; when a task hits `await` on something not yet available, the task is suspended and the loop moves on.

```python
import asyncio

async def fetch(name, delay):
    await asyncio.sleep(delay)      # suspension point
    return f"{name} done"

async def main():
    results = await asyncio.gather(fetch("a", 1), fetch("b", 1))
    print(results)                  # ~1 second total, not 2

asyncio.run(main())
```

## Async functions become state machines

Compilers and runtimes transform an async function into an object that remembers where it paused and what its local variables were. Each `await` is a point where it can yield control and later resume. No extra threads are involved.

## Concurrency is not parallelism

Async lets one thread juggle many waiting tasks. It doesn't run CPU-heavy work in parallel. A long computation inside an async function blocks the whole loop — every other task freezes until it finishes.

## Common pitfalls

- **Blocking calls inside async code:** a synchronous HTTP library or `time.sleep` stalls everything. Use async-aware libraries, or push blocking work to a thread pool.
- **Forgetting to await:** you get a coroutine or promise object instead of a result, and errors may vanish silently.
- **Sequential awaits when you meant concurrent ones:** `await a(); await b()` runs one after the other. Use `gather`, `Promise.all` or the equivalent.
- **Function coloring:** async functions can generally only be awaited from other async functions, which spreads `async` through a codebase.

## When async pays off

I/O-bound workloads with many concurrent waits: web servers, crawlers, chat systems, API gateways. For CPU-bound work, reach for processes, threads or a language with true parallelism instead.
