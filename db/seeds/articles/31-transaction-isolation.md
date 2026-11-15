---
title: "Transaction isolation levels without the jargon"
author: Daniel Reyes
category: Databases
published_at: 2024-05-26 14:45
tags: [sql, transactions, concurrency, databases]
image: 31-transaction-isolation-cover.png
image_alt: Two concurrent transactions reading and updating the same account balance
summary: Your database lets concurrent transactions see each other in controlled ways. Knowing which anomalies your isolation level allows prevents subtle, expensive bugs.
---

Two requests update the same account balance at the same moment. What each one sees depends on the transaction's **isolation level** — and the default is often weaker than people assume.

## The anomalies

- **Dirty read:** you see another transaction's uncommitted changes.
- **Non-repeatable read:** you read a row twice in one transaction and get different values.
- **Phantom read:** you run the same query twice and new rows appear.
- **Lost update:** two transactions read a value, both modify it, and one overwrite silently wins.

## The levels

| Level | Prevents |
| --- | --- |
| Read uncommitted | (almost nothing) |
| Read committed | Dirty reads |
| Repeatable read | + non-repeatable reads |
| Serializable | All of the above — behaves as if transactions ran one at a time |

Exact behavior varies by database. Postgres, for example, defaults to read committed, and its repeatable read also prevents phantoms.

## The classic bug

```sql
-- Two transactions, both at READ COMMITTED
BEGIN;
SELECT balance FROM accounts WHERE id = 1;   -- both read 100
UPDATE accounts SET balance = 90 WHERE id = 1;  -- app computed 100 - 10
COMMIT;
```

Both withdraw 10, but the balance ends at 90, not 80. A lost update.

## Fixes, from simplest

1. **Do the math in SQL:** `UPDATE accounts SET balance = balance - 10 WHERE id = 1`. The database applies each update to the latest value.
2. **Lock the row:** `SELECT ... FOR UPDATE` makes the second transaction wait for the first.
3. **Optimistic locking:** add a `version` column and include it in the `WHERE` clause; if zero rows update, someone else changed it — retry.
4. **Serializable isolation:** the database detects conflicts and aborts one transaction, which your code must retry.

## Practical advice

Keep transactions short, push arithmetic into the database where you can, and use row locks or optimistic locking for read-modify-write flows. Reach for serializable when correctness matters more than throughput — and always write the retry loop.
