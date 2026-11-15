---
title: "SQL injection is still here. Parameterized queries still fix it"
author: Samuel Brandt
category: Security
published_at: 2026-03-19 15:20
tags: [security, sql, injection, owasp]
image: 43-sql-injection-cover.png
image_alt: Code contrasting a query built by string concatenation with a parameterized query
summary: One of the oldest web vulnerabilities keeps showing up in new code. The fix has been known for decades — here's how to apply it everywhere, including the places ORMs don't cover.
---

SQL injection happens when user input is pasted into a SQL string and the database interprets part of it as code. It's decades old, well understood and still regularly found in production applications.

## The bug

```python
# vulnerable: input becomes part of the SQL
query = f"SELECT * FROM users WHERE email = '{email}'"

# email = "' OR '1'='1"  → returns every user
```

Depending on the database and permissions, an attacker can read other users' data, bypass logins, modify records or worse.

## The fix: parameters

Send the query and the values separately. The database treats parameters as data, never as SQL:

```python
cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
```

Every mainstream database driver and ORM supports this. With ORMs, the standard query methods parameterize for you:

```ruby
User.where(email: params[:email])            # safe
User.where("email = ?", params[:email])      # safe
User.where("email = '#{params[:email]}'")    # vulnerable
```

## Where injection still sneaks in

- **Raw SQL fragments** in ORMs: string interpolation inside `where`, `order` or `select` calls.
- **Dynamic column or table names**, which can't be parameterized. Validate them against an allow-list.
- **`ORDER BY` from query parameters:** map user choices like `"newest"` to fixed SQL instead of passing column names through.
- **`LIKE` patterns:** parameterize the value and escape `%` and `_` if users shouldn't use wildcards.
- **Stored procedures** that build dynamic SQL internally.

## Defense in depth

- Connect with a database user that has only the permissions the app needs.
- Use static analysis tools that flag string-built queries.
- Log and alert on database errors, which often spike during injection attempts.

## The rule

User input never becomes SQL syntax. If you find yourself concatenating strings into a query, stop and parameterize — or allow-list.
