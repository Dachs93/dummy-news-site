---
title: "Unicode for programmers: bytes, code points and graphemes"
author: Priya Natarajan
category: Languages
published_at: 2024-11-02 10:45
tags: [unicode, strings, i18n, text]
image: 39-unicode-cover.png
image_alt: Python showing different lengths for the same string as bytes, code points and graphemes
summary: Asking for the length of a string has at least three correct answers. Understanding why prevents a family of text-handling bugs.
---

Text looks simple until it isn't: a name truncated mid-character, an emoji counted as two letters, a search that misses "café" because of how the é was typed. The fix starts with knowing the layers.

## Three levels

- **Bytes:** how text is stored or sent. UTF-8 uses 1 to 4 bytes per code point.
- **Code points:** the numbered characters in the Unicode standard, like U+0065 for "e".
- **Grapheme clusters:** what a human perceives as one character — which may be several code points.

```python
s = "é"          # "é" built from e + combining accent
len(s.encode())        # 3 bytes
len(s)                 # 2 code points
# 1 grapheme — what the user sees
```

Emoji make this vivid: a family emoji or a flag can be several code points joined together, but it's one visible symbol.

## Normalization

"é" can be one code point (U+00E9) or two (e + U+0301). They look identical but compare unequal. Normalize before comparing or storing:

```python
import unicodedata
unicodedata.normalize("NFC", s) == "é"   # True
```

NFC composes characters where possible and is a good default for storage.

## Common bugs

- **Truncating by bytes or code points** can split a character or an emoji. Truncate by grapheme clusters for user-visible text.
- **Case-insensitive comparison** isn't just `lower()`. Some languages have special casing rules; use proper case folding.
- **Database column limits** may count bytes, not characters.
- **Reversing strings** code point by code point breaks combining marks.

## Practical rules

1. Use UTF-8 everywhere — files, databases, HTTP.
2. Decode bytes to text at the edges of your program; work with text inside.
3. Normalize user input you'll compare or search.
4. Use a library that understands grapheme clusters for display-length operations.

Most text bugs come from treating one layer as another. Keep them straight and Unicode becomes much less mysterious.
