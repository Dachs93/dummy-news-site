---
title: "Content Security Policy without breaking your site"
author: Samuel Brandt
category: Security
published_at: 2025-06-30 13:25
tags: [security, csp, xss, headers]
image: 46-content-security-policy-cover.png
image_alt: A Content-Security-Policy header restricting scripts to the same origin and a nonce
summary: CSP is one of the most effective defenses against cross-site scripting. Rolling it out gradually is the difference between protection and a broken checkout page.
---

Cross-site scripting (XSS) lets an attacker run JavaScript in your users' browsers. Output escaping is the first line of defense. A Content Security Policy is the second: even if malicious markup slips through, the browser refuses to run scripts you didn't authorize.

## What a policy looks like

```text
Content-Security-Policy:
  default-src 'self';
  script-src 'self' 'nonce-r4nd0m';
  style-src 'self';
  img-src 'self' https: data:;
  object-src 'none';
  base-uri 'self';
  frame-ancestors 'none'
```

Each directive lists where a type of resource may load from. Anything else is blocked.

## Nonces beat allow-lists

Inline scripts are the main XSS vector, so a strong policy blocks them. When you need inline scripts, generate a random **nonce** per response and add it to both the header and your trusted script tags:

```html
<script nonce="r4nd0m">initApp()</script>
```

An injected `<script>` won't have the nonce and won't run. Many frameworks can generate nonces automatically.

## Roll out in report-only mode

Turning on a strict policy cold will break things — analytics snippets, inline event handlers, third-party widgets. Start with:

```text
Content-Security-Policy-Report-Only: ...; report-to csp-endpoint
```

The browser reports violations without blocking. Fix or allow-list legitimate sources until reports quiet down, then switch to enforcing.

## Common pitfalls

- **`'unsafe-inline'` in `script-src`** largely defeats the point.
- **Allow-listing big CDNs** may allow scripts an attacker can also host there.
- **Inline `onclick` handlers** are blocked by strict policies; move them into scripts.
- **Forgetting `frame-ancestors`**, which protects against clickjacking.

## Worth the effort

CSP takes some upfront work, especially on older codebases. In exchange, a whole class of XSS bugs goes from "account takeover" to "blocked in the console."
