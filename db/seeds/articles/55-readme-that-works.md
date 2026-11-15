---
title: "Writing a README people actually read"
author: Editorial Team
category: Open Source
published_at: 2025-09-05 15:25
tags: [documentation, open-source, writing]
image: 55-readme-that-works-cover.png
image_alt: A README skeleton with sections for what it is, quick start and usage
summary: Your README is your project's front door. Answer the first three questions every visitor has, and keep the rest a click away.
---

Most visitors spend seconds on a README before deciding whether a project is worth their time. A good one answers their questions in the order they ask them.

## The questions, in order

1. **What is this?** One or two sentences, no jargon.
2. **Is it for me?** What problem it solves and for whom.
3. **How do I try it?** The shortest path to something working.
4. **Where do I learn more?** Links to docs, examples and help.

## A skeleton

```markdown
# fastcsv

Parse and write CSV files at high speed with a tiny API.

## Quick start

    npm install fastcsv

    import { parse } from "fastcsv";
    const rows = parse(text);

## Features
- Streams large files with constant memory
- Handles quoted fields and custom delimiters

## Documentation
Full guide and API reference: docs/

## Contributing
See CONTRIBUTING.md. Bug reports welcome!

## License
MIT
```

## Make the quick start real

- Copy-pasteable commands that work on a clean machine.
- The minimum code that produces a visible result.
- Test it regularly — or better, test it in CI.

A broken quick start costs you more users than a missing feature.

## Show, don't tell

A short code example, screenshot or terminal recording communicates more than a paragraph of adjectives. "Blazing fast" means nothing; a benchmark or an example does.

## Keep it current

Outdated install instructions are worse than none. When you change a command, flag or API, update the README in the same pull request.

## What to move elsewhere

Long API references, architecture deep-dives and full configuration tables belong in dedicated docs. The README should stay skimmable — a front door, not the whole house.
