---
title: "CSRF in the age of SameSite cookies"
author: Samuel Brandt
category: Security
published_at: 2025-09-26 09:50
tags: [security, csrf, cookies, web]
image: 45-csrf-samesite-cover.png
image_alt: A Set-Cookie header with HttpOnly, Secure and SameSite attributes
summary: Browsers now block many cross-site requests by default. That helps, but it doesn't make CSRF tokens obsolete.
---

Cross-site request forgery (CSRF) tricks a logged-in user's browser into sending a request to your site from somewhere else. Because the browser attaches your session cookie automatically, the request looks legitimate.

## The classic attack

```html
<!-- on evil.example -->
<form action="https://bank.example/transfer" method="post">
  <input type="hidden" name="to" value="attacker">
  <input type="hidden" name="amount" value="1000">
</form>
<script>document.forms[0].submit()</script>
```

If the bank relies on cookies alone, the transfer goes through.

## SameSite cookies

The `SameSite` attribute tells browsers when to send a cookie on cross-site requests:

```text
Set-Cookie: session=abc123; HttpOnly; Secure; SameSite=Lax
```

- `Strict` — never sent on cross-site requests, even when following a link.
- `Lax` — sent on top-level navigations with safe methods (GET), not on cross-site POSTs or background requests.
- `None` — always sent; requires `Secure`.

Many browsers treat cookies without the attribute as `Lax`. That alone blocks the form above.

## Why you still want tokens

- **Not all browsers or configurations** apply the same defaults.
- **Same-site isn't same-origin.** A vulnerable subdomain counts as same-site and can send your cookies.
- **GET requests that change state** are still exposed under `Lax`. (They shouldn't change state — but some do.)

A CSRF token is a secret value embedded in your forms and checked on submit. An attacker's page can't read it, so it can't forge a valid request. Most frameworks generate and verify these automatically.

## A solid setup

1. Session cookies: `HttpOnly; Secure; SameSite=Lax` (or `Strict` for sensitive apps).
2. Framework CSRF protection enabled for all state-changing requests.
3. Never change state on GET.
4. For APIs using tokens in headers instead of cookies, CSRF largely doesn't apply — but don't mix the two carelessly.

SameSite is a strong safety net. Tokens remain the seatbelt.
