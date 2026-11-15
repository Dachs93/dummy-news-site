---
title: "Pattern matching across languages: Ruby, Python and Rust compared"
author: Priya Natarajan
category: Languages
published_at: 2026-03-31 08:30
tags: [pattern-matching, ruby, python, rust]
image: 33-pattern-matching-cover.png
image_alt: Rust match expression destructuring an enum with several variants
summary: Pattern matching has spread from functional languages into the mainstream. The syntax differs, but the idea — destructure and branch on shape — is the same.
---

Pattern matching lets you check the *shape* of a value and pull it apart in one step. Once niche, it's now available in Ruby, Python, Rust, C#, Java and more.

## Rust: exhaustive by default

```rust
enum Shape {
    Circle { r: f64 },
    Rect { w: f64, h: f64 },
}

fn area(s: &Shape) -> f64 {
    match s {
        Shape::Circle { r } => std::f64::consts::PI * r * r,
        Shape::Rect { w, h } => w * h,
    }
}
```

Add a `Triangle` variant and the compiler flags every `match` that doesn't handle it. That exhaustiveness check is pattern matching's killer feature in statically typed languages.

## Python: structural pattern matching

```python
match event:
    case {"type": "click", "x": x, "y": y}:
        handle_click(x, y)
    case {"type": "key", "key": "Escape"}:
        close_dialog()
    case _:
        pass
```

Python matches dictionaries, sequences and class instances, binding names as it goes. There's no exhaustiveness check at runtime, so a final `case _:` is good practice.

## Ruby: case/in

```ruby
case response
in { status: 200, body: { user: { name: String => name } } }
  puts "Hello, #{name}"
in { status: 404 }
  puts "Not found"
end
```

Ruby raises `NoMatchingPatternError` if nothing matches and there's no `else`, which makes missing cases loud.

## Shared ideas

- **Destructuring:** pull fields out while matching.
- **Guards:** add conditions — `if x > 0` in Rust and Python, `if` in Ruby.
- **Wildcards:** `_` matches anything.
- **Literal and type patterns:** match exact values or classes.

## When it shines

Parsing JSON-like data, handling tagged unions or result types, interpreting commands and implementing state machines. It replaces chains of `if` statements and type checks with something that reads like a description of the data.

## When it doesn't

For a simple equality check, a plain `if` is clearer. Pattern matching earns its keep when data has structure worth describing.
