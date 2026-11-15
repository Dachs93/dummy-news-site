---
title: "Threads, actors and channels: a guide to concurrency models"
author: Priya Natarajan
category: Languages
published_at: 2024-02-14 11:50
tags: [concurrency, go, elixir, threads]
image: 42-concurrency-models-cover.png
image_alt: Go code with worker goroutines receiving jobs from a channel
summary: Languages offer very different tools for doing many things at once. Each model makes certain bugs impossible and others easy.
---

Concurrency is about structuring a program to handle many things at once. How a language lets you express that determines which bugs you'll fight.

## Shared memory and locks

Threads share memory; mutexes protect it. Available almost everywhere.

- **Pro:** flexible and fast when done right.
- **Con:** data races and deadlocks. Forget a lock and you get corrupted data; take locks in different orders and threads wait on each other forever.

## Communicating sequential processes (channels)

Independent tasks communicate by sending messages over channels instead of sharing variables. Go's goroutines are the best-known example:

```go
jobs := make(chan int)
results := make(chan int)

for w := 0; w < 3; w++ {
    go func() {
        for j := range jobs {
            results <- j * 2
        }
    }()
}
```

"Don't communicate by sharing memory; share memory by communicating."

## Actors

Each actor has private state and a mailbox. Actors process one message at a time and talk only by sending messages. Erlang and Elixir build on this, with supervisors that restart failed actors:

```elixir
send(pid, {:charge, order_id})

receive do
  {:charged, ^order_id} -> :ok
after
  5_000 -> :timeout
end
```

Because state isn't shared, there are no data races between actors.

## Async tasks

Cooperative tasks on an event loop — `async`/`await` — handle huge numbers of concurrent I/O operations on few threads, but CPU-bound work blocks everything.

## Ownership-checked threads

Rust's type system tracks which data can be shared or sent between threads, so most data races are compile errors rather than production incidents.

## Choosing

| Model | Great for |
| --- | --- |
| Locks | Small critical sections, performance-sensitive code |
| Channels | Pipelines, worker pools |
| Actors | Fault-tolerant systems with lots of independent state |
| Async | High-concurrency I/O |

Most real systems mix models. The goal is the same: make it hard for two things to touch the same data at the same time without meaning to.
