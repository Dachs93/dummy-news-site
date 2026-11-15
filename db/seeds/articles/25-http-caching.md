---
title: "HTTP caching, properly: Cache-Control, ETags and what browsers actually do"
author: Daniel Reyes
category: Web
published_at: 2025-10-31 14:30
tags: [http, caching, performance, web]
image: 25-http-caching-cover.png
image_alt: HTTP response headers showing Cache-Control and an ETag, then a 304 Not Modified
summary: The fastest request is the one that never reaches your server. A practical guide to the headers that control browser and CDN caching.
---

HTTP has a powerful caching system built in. Used well, it makes sites faster and servers cheaper. Used badly, users see stale pages or nothing gets cached at all.

## Cache-Control is the main lever

```text
Cache-Control: public, max-age=31536000, immutable
```

- `max-age=N` — the response is fresh for N seconds.
- `public` — shared caches (CDNs, proxies) may store it.
- `private` — only the user's browser may store it. Use for personalized pages.
- `no-cache` — store it, but revalidate with the server before every use.
- `no-store` — don't store it at all. Use for sensitive data.

`no-cache` does **not** mean "don't cache." It means "always check first."

## Fingerprinted assets: cache forever

When asset filenames include a content hash (`app-3f9a1c.css`), a changed file gets a new URL. That means the old URL can be cached forever:

```text
Cache-Control: public, max-age=31536000, immutable
```

## HTML: revalidate

Pages change, so let browsers keep a copy but check whether it's still current. That's what validators are for.

## ETags and conditional requests

```text
HTTP/1.1 200 OK
ETag: "a7f3c9"
Cache-Control: no-cache

GET /articles/42
If-None-Match: "a7f3c9"

HTTP/1.1 304 Not Modified
```

A `304` has no body. The server still does some work — it must compute the ETag — but skips rendering and transferring the page. Many frameworks can short-circuit rendering entirely when the ETag matches.

## CDNs

`s-maxage` sets freshness for shared caches only, so a CDN can cache for minutes while browsers revalidate every time:

```text
Cache-Control: public, max-age=0, s-maxage=300
```

## Common mistakes

- Caching personalized pages as `public` — one user's page served to another.
- Forgetting `Vary` when responses differ by header, such as `Accept-Encoding` or `Accept-Language`.
- Long `max-age` on unfingerprinted URLs, leaving users stuck on old files.

## A sane default

Fingerprinted assets: cache for a year. HTML: `no-cache` with ETags. Private data: `private` or `no-store`. Start there and tune with real traffic.
