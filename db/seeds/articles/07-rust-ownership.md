---
title: "Rust's ownership model, explained for developers coming from garbage-collected languages"
author: Priya Natarajan
category: Languages
published_at: 2026-08-03 08:05
tags: [rust, memory, beginners]
image: 07-rust-ownership-cover.png
image_alt: Rust code where using a moved String produces a borrow-checker error
summary: Ownership and borrowing are why Rust needs no garbage collector. Three rules, a few examples, and the mental model that makes the borrow checker click.
---

If you come from Ruby, Python, Java or JavaScript, memory just… works. Rust gets the same safety without a garbage collector by checking, at compile time, who *owns* each value.

## The three rules

1. Every value has exactly one **owner**.
2. When the owner goes out of scope, the value is **dropped**.
3. You can have **either** one mutable reference **or** any number of immutable references — never both at once.

## Moves

```rust
let a = String::from("hello");
let b = a;           // ownership moves to b
// println!("{a}");  // compile error: a was moved
println!("{b}");
```

Assigning a heap value moves it. This is how Rust guarantees there's exactly one place responsible for freeing it.

## Borrowing

Most of the time you don't want to give a value away — you want to lend it:

```rust
fn length(s: &String) -> usize {
    s.len()
}

let name = String::from("ferris");
let n = length(&name); // borrow
println!("{name} has {n} letters"); // still usable
```

## Why rule three matters

Shared mutable state is the root of data races and iterator-invalidation bugs. By forbidding mutation while something else is reading, Rust rules out a whole class of bugs before the program runs.

## The mental model

Think of the borrow checker as a code reviewer who insists on one question: *who is responsible for this data right now?* Once you design your code to answer that clearly, the fights with the compiler mostly stop.
