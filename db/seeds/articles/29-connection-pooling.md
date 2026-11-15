---
title: "Database connection pooling, explained"
author: Daniel Reyes
category: Databases
published_at: 2024-11-13 10:35
tags: [postgres, performance, databases, scaling]
image: 29-connection-pooling-cover.png
image_alt: A database configuration setting the connection pool size
summary: Hitting "too many connections" errors is a rite of passage. Understanding how pools work — in your app and in front of your database — makes them go away.
---

Opening a database connection is expensive: a network handshake, authentication and, in Postgres, a whole new server process. Applications avoid doing it per request by keeping a **pool** of open connections and lending them out.

## Pools in your application

Each app process keeps its own pool. A request borrows a connection, runs its queries and returns it.

```yaml
production:
  adapter: postgresql
  pool: 5          # connections per process
  checkout_timeout: 5
```

The pool should be at least as large as the number of threads in the process that use the database. Fewer, and threads wait for a connection; many more, and you're holding connections nobody uses.

## Do the math

Total connections = processes × pool size.

```text
4 servers × 3 processes × 5 threads = 60 connections
+ background workers                = 20 connections
                                      ──
                                      80
```

Each Postgres connection uses memory on the database server, and managed databases often cap connections at a modest number. Autoscaling app servers can blow straight past that limit.

## External poolers

A connection pooler sits between your apps and the database, multiplexing many client connections over a few real ones. Postgres poolers commonly offer modes such as:

- **Session pooling:** a client keeps a server connection for its whole session. Safe, but little multiplexing.
- **Transaction pooling:** a server connection is assigned only for the duration of a transaction. Far better multiplexing, but session-level features — some prepared statement setups, advisory locks, `SET` commands — need care.

## Symptoms and fixes

| Symptom | Likely cause |
| --- | --- |
| "Could not obtain a connection from the pool" | Pool smaller than thread count, or slow queries hogging connections |
| "Too many connections" from the database | Sum of all pools exceeds the server limit |
| Memory pressure on the database | Too many idle connections |

## Keep transactions short

The best way to need fewer connections is to hold each one for less time. Don't call external APIs inside a transaction, and fix slow queries. A connection held for 10 ms instead of 500 ms serves fifty times more requests.
