---
title: "Choosing an open-source license: a plain-language guide"
author: Editorial Team
category: Open Source
published_at: 2026-02-28 11:45
tags: [open-source, licensing, legal]
image: 53-open-source-licenses-cover.png
image_alt: A source file header with an SPDX license identifier
summary: Code without a license isn't open source, even if it's public. Here's how the major license families differ and how to pick one.
---

Publishing code on the internet doesn't make it open source. Without a license, default copyright applies, and nobody has clear permission to use, modify or share it. Choosing a license is a small decision with long-lasting effects.

*This is a general overview, not legal advice. For anything with real stakes, talk to a lawyer.*

## Permissive licenses

**MIT, BSD and Apache 2.0** let anyone use, modify and redistribute your code — including in closed-source products — as long as they keep the copyright notice.

- **MIT:** short and simple.
- **Apache 2.0:** adds an explicit patent grant and clearer contribution terms, which many companies prefer.

Choose permissive if you want maximum adoption and don't mind proprietary use.

## Copyleft licenses

**GPL** requires that distributed derivative works also be released under the GPL, with source code available.

- **LGPL:** a weaker copyleft, commonly used for libraries; apps can link to the library without becoming LGPL themselves.
- **AGPL:** extends copyleft to software offered over a network, closing the "we only run it as a service" gap.
- **MPL 2.0:** file-level copyleft; modified files stay open, but they can be combined with proprietary code.

Choose copyleft if you want improvements to stay open.

## Mark your files

The SPDX standard gives every license a short identifier. Add it to source files and package metadata so tools can detect it automatically:

```text
// SPDX-License-Identifier: Apache-2.0
// Copyright 2026 The Project Authors
```

## Practical checklist

1. Add a `LICENSE` file at the repository root with the full license text.
2. Set the license field in your package manifest.
3. Check your dependencies' licenses are compatible with yours.
4. Decide how you'll accept contributions — a contributor license agreement, a sign-off on each commit, or neither.

## Changing later is hard

Relicensing requires permission from every copyright holder, which gets impractical once many people have contributed. Pick deliberately at the start.
