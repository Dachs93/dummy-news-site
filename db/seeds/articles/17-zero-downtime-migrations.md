---
title: "Zero-downtime database migrations with expand and contract"
author: Maya Okafor
category: DevOps
published_at: 2025-05-26 12:35
tags: [databases, migrations, deployment]
image: 17-zero-downtime-migrations-cover.png
image_alt: A sequence of migration steps adding a new column, backfilling it and dropping the old one
summary: Renaming a column sounds trivial until old and new code run at the same time. The expand/contract pattern makes schema changes safe during live deploys.
---

During any zero-downtime deploy there's a window where the old version and the new version of your app both talk to the same database. A migration that breaks the old code — renaming or dropping a column it reads — will cause errors in that window.

The fix is to split risky changes into backwards-compatible steps.

## Expand, migrate, contract

Say you want to rename `users.name` to `users.full_name`.

```text
Deploy 1 (expand)    add column full_name; write to both columns
Backfill             copy name → full_name in batches
Deploy 2 (migrate)   read from full_name; still write both
Deploy 3 (contract)  stop writing name; drop the column
```

At every step, the previous version of the app still works against the current schema.

## Operations to treat with care

- **Dropping a column:** first deploy code that no longer reads it. Many ORMs cache column lists, so tell the ORM to ignore the column before you drop it.
- **Adding a NOT NULL column:** add it as nullable (or with a default), backfill, then add the constraint.
- **Adding an index on a big table:** use your database's concurrent/online index build so writes aren't blocked.
- **Changing a column type:** treat it like a rename — new column, backfill, switch, drop.

## Backfill in batches

Updating ten million rows in one statement holds locks and bloats your transaction log. Batch it:

```sql
UPDATE users SET full_name = name
WHERE id BETWEEN 1 AND 10000 AND full_name IS NULL;
```

Run batches in a background job with a short pause between them, and make the job safe to restart.

## Make it routine

Expand/contract feels slow the first time — three deploys for a rename. But each deploy is small and reversible, and you never schedule a maintenance window again. Add a migration checklist to your pull request template and the pattern quickly becomes habit.
