---
# Required ---------------------------------------------------------------
title: Your headline here
author: Jane Doe                 # existing author name, or a new one (created automatically)
category: Languages              # must match an existing topic name
# Optional ---------------------------------------------------------------
author_role: Staff Writer        # only used when the author is new
summary: One or two sentences shown under the headline and in listings.
published_at: 2026-11-15 09:00   # blank = draft, future date = scheduled
tags: [example, markdown]        # or: example, markdown
featured: false                  # true = eligible for the front page lead
# Cover image — uncomment and set. Use a URL or a path from Admin → Images (1200×630 works best).
# image: /rails/active_storage/blobs/redirect/.../cover.png
# image_alt: Describe the image for screen readers   # required when image is set
# image_caption: Optional caption or photo credit
# slug: your-headline-here       # defaults to the title, parameterized
---

Open with the news: what happened and why a working developer should care.

## What changed

Explain the change in a few short paragraphs. Use `inline code` for names
of functions, flags and files.

```ruby
# Fenced code blocks are supported — set the language after the backticks.
puts "Hello, software-devs"
```

## Why it matters

Inline images: upload under Admin → Images, then paste the Markdown it gives you,
e.g. `![Describe the image](/path/to/image.png "Optional caption")`.

- Bullet lists work
- So do **bold**, _italics_ and [links](https://example.com)

| Option | Default | Notes          |
| ------ | ------- | -------------- |
| tables | yes     | GitHub-style   |

> Pull quotes use a leading `>`.

## What's next

Close with what to watch for, or how readers can try it themselves.
