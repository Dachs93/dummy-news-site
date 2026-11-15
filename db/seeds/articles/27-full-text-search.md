---
title: "Full-text search without a search cluster"
author: Daniel Reyes
category: Databases
published_at: 2025-05-06 15:30
tags: [search, postgres, sqlite, sql]
image: 27-full-text-search-cover.png
image_alt: SQL creating a full-text search index and querying it with ranking
summary: Before you add a dedicated search engine, check what your database already does. Postgres and SQLite both ship capable full-text search.
---

`WHERE title LIKE '%deploy%'` works for a prototype. It can't use a normal index, ignores word forms ("deploy" vs. "deploying") and has no notion of relevance. The usual next step is a separate search cluster. Often, your database is enough.

## Postgres: tsvector and tsquery

Postgres converts text into a `tsvector` — normalized words called lexemes — and matches it against a `tsquery`.

```sql
ALTER TABLE articles ADD COLUMN search tsvector
  GENERATED ALWAYS AS (
    setweight(to_tsvector('english', coalesce(title, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(body, '')), 'B')
  ) STORED;

CREATE INDEX articles_search_idx ON articles USING gin (search);

SELECT title, ts_rank(search, q) AS rank
FROM articles, websearch_to_tsquery('english', 'deploy rails') q
WHERE search @@ q
ORDER BY rank DESC
LIMIT 20;
```

- **Stemming:** "deploying" matches "deploy".
- **Weights:** title matches rank above body matches.
- **`websearch_to_tsquery`** accepts search-box syntax like quoted phrases and `-exclude`.

## SQLite: FTS5

SQLite's FTS5 extension provides a virtual table with ranking built in:

```sql
CREATE VIRTUAL TABLE articles_fts USING fts5(title, body);

SELECT title FROM articles_fts
WHERE articles_fts MATCH 'deploy AND rails'
ORDER BY rank;
```

Keep it in sync with your main table using triggers, or rebuild it in a background job.

## When to reach for a dedicated engine

- Typo tolerance and fuzzy matching as a core feature
- Faceted search across many attributes at large scale
- Search traffic heavy enough to warrant separate infrastructure
- Complex relevance tuning and multilingual analysis

## Why start with the database

No extra service to run, no sync pipeline to break, and search results are always consistent with your data. For a blog, docs site, internal tool or modest product catalog, built-in full-text search is often all you'll ever need.
