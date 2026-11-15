---
title: "Storing passwords safely: slow hashes, salts and what not to do"
author: Samuel Brandt
category: Security
published_at: 2025-12-20 12:25
tags: [security, passwords, authentication, cryptography]
image: 44-password-storage-cover.png
image_alt: Code hashing a password with a slow, salted algorithm and verifying it
summary: If your user table leaks, how you hashed passwords decides whether attackers get a list of emails or a list of working logins.
---

Assume your database will leak someday — a backup left public, a SQL injection, a compromised laptop. Password storage is about making that leak as useless as possible.

## Never store passwords reversibly

- **Plain text:** obviously not.
- **Encryption:** whoever has the key can decrypt every password.
- **Fast hashes** like MD5 or SHA-256: built for speed, which is exactly wrong here. Modern GPUs can try billions of guesses per second against them.

## Use a password hashing function

Password hashing functions are deliberately slow and salted:

- **Argon2id** — the current general recommendation, tunable for memory and time.
- **scrypt** — memory-hard, widely available.
- **bcrypt** — older but still solid; note its 72-byte input limit.

```python
from argon2 import PasswordHasher

ph = PasswordHasher()
stored = ph.hash("correct horse battery staple")

ph.verify(stored, "correct horse battery staple")   # True, or raises
```

## Salts

A salt is random data unique to each password, stored alongside the hash. It ensures two users with the same password get different hashes and defeats precomputed lookup tables. Good libraries generate salts for you — don't roll your own.

## Tune the cost

Pick parameters so hashing takes noticeable time on your servers — tens to a few hundred milliseconds. Re-hash with stronger parameters when users log in, as hardware gets faster.

## Beyond hashing

- **Rate-limit login attempts** per account and per IP.
- **Check new passwords against breached-password lists.**
- **Allow long passphrases** and paste — password managers depend on it.
- **Offer multi-factor authentication**, ideally passkeys or authenticator apps.
- **Use constant-time comparison** for tokens; password libraries handle this for you.

## The short version

Use your framework's built-in password support — it almost certainly uses bcrypt or Argon2 correctly. Don't invent your own scheme.
