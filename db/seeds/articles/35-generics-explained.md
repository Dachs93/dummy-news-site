---
title: "Generics explained: one idea, three implementations"
author: Priya Natarajan
category: Languages
published_at: 2025-10-08 12:40
tags: [generics, typescript, go, rust]
image: 35-generics-explained-cover.png
image_alt: A generic Go function that returns the maximum of a slice of ordered values
summary: Generics let you write code once for many types without giving up type safety. TypeScript, Go and Rust each approach them differently.
---

Without generics, you either write `maxInt`, `maxFloat` and `maxString`, or you accept "any" type and lose compile-time checking. Generics let you write the logic once, parameterized by type.

## Go: type parameters with constraints

```go
import "cmp"

func Max[T cmp.Ordered](xs []T) T {
    m := xs[0]
    for _, x := range xs[1:] {
        if x > m {
            m = x
        }
    }
    return m
}

Max([]int{3, 9, 2})          // 9
Max([]string{"b", "a"})      // "b"
```

The constraint `cmp.Ordered` says `T` must support `<` and `>`.

## TypeScript: generics with structural typing

```ts
function first<T>(items: T[]): T | undefined {
  return items[0];
}

function longest<T extends { length: number }>(a: T, b: T): T {
  return a.length >= b.length ? a : b;
}
```

TypeScript's types disappear at runtime; generics exist purely for the type checker.

## Rust: traits as bounds

```rust
fn largest<T: PartialOrd + Copy>(xs: &[T]) -> T {
    let mut m = xs[0];
    for &x in xs { if x > m { m = x; } }
    m
}
```

## How they're implemented

- **Monomorphization** (Rust, C++): the compiler generates a specialized copy for each concrete type. Fast at runtime, larger binaries and slower compiles.
- **Type erasure** (Java, TypeScript): generic types are checked at compile time and erased afterwards. One implementation, less runtime type information.
- **Hybrid approaches** (Go): implementations may share code across types with similar memory shapes, balancing binary size and speed.

## When to use them

Collections, utilities like `map` and `filter`, caches and repository layers are natural fits. If a function only ever handles one type, a generic version adds noise. A good rule: write the concrete version first, and generalize when the second or third type shows up.
