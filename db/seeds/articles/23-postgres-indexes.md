---
title: "Postgres indexes beyond the basics: partial, expression and covering"
author: Daniel Reyes
category: Databases
published_at: 2026-04-19 13:00
tags: [postgres, sql, performance, indexes]
image: 23-postgres-indexes-cover.png
image_alt: SQL statements creating partial, expression and covering indexes
summary: A plain B-tree index on the right column solves most problems. For the rest, Postgres has index types that are smaller, faster and more precise.
---

Most query tuning starts and ends with "add an index on the column in the WHERE clause." That's usually right. But Postgres offers more precise tools, and knowing them can turn a 2-second query into a 2-millisecond one.

## Start with EXPLAIN

Never guess. Ask the planner what it's doing:

```sql
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE status = 'pending' AND created_at > now() - interval '1 day';
```

A `Seq Scan` over millions of rows on a selective query is your cue.

## Partial indexes

Index only the rows you query. If 98% of orders are `completed` and you only ever look up `pending` ones:

```sql
CREATE INDEX orders_pending_idx
  ON orders (created_at)
  WHERE status = 'pending';
```

The index is tiny, stays in memory and is cheap to maintain on writes.

## Expression indexes

Queries that wrap a column in a function can't use a plain index on that column:

```sql
SELECT * FROM users WHERE lower(email) = 'ana@example.com';

CREATE INDEX users_lower_email_idx ON users (lower(email));
```

The query must use the same expression for the index to apply.

## Multicolumn order matters

An index on `(account_id, created_at)` serves `WHERE account_id = ?` and `WHERE account_id = ? ORDER BY created_at`. It's much less useful for `WHERE created_at > ?` alone. Put equality columns first, range or sort columns last.

## Covering indexes

`INCLUDE` adds columns to the index leaf pages so Postgres can answer the query from the index alone — an index-only scan:

```sql
CREATE INDEX orders_account_idx
  ON orders (account_id) INCLUDE (total_cents, status);
```

## The cost of indexes

Every index slows down inserts and updates and takes disk space. Periodically check for indexes that are never used and drop them. And on busy tables, build new indexes with `CREATE INDEX CONCURRENTLY` so you don't block writes.

## Rule of thumb

Index for the queries you actually run, verify with `EXPLAIN ANALYZE`, and prefer the smallest index that does the job.
