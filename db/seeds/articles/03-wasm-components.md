---
title: "WebAssembly outside the browser: what the component model actually is"
author: Priya Natarajan
category: Languages
published_at: 2026-10-12 13:30
tags: [webassembly, wasm, rust]
image: 03-wasm-components-cover.png
image_alt: A WIT interface definition for a greeter component
summary: WebAssembly modules are portable but awkward to connect. The component model adds typed interfaces so modules written in different languages can talk to each other.
---

WebAssembly started as a way to run fast code in the browser. Increasingly, it's showing up on servers, at the edge and inside plugins. The piece that makes that practical is the **component model**.

## Modules vs. components

A core Wasm *module* only understands numbers: integers and floats. Passing a string means agreeing on a memory layout, writing bytes into linear memory and handing over a pointer and a length. Every language toolchain did this differently.

A *component* wraps a module with a typed interface described in **WIT** (Wasm Interface Type):

```wit
package example:greeter;

interface greet {
  greet: func(name: string) -> string;
}

world greeter {
  export greet;
}
```

Tooling generates the glue code on both sides, so a component written in Rust can call one written in Go or Python without either knowing the other's memory layout.

## Why developers care

- **Plugins without the risk.** Components are sandboxed by default and only get the capabilities they're handed.
- **Polyglot libraries.** Write a parser once, use it from any language with a Wasm runtime.
- **Small, fast cold starts.** A natural fit for serverless and edge functions.

## Trying it

```bash
cargo install cargo-component
cargo component new greeter --lib
cargo component build --release
```

The ecosystem is still settling, but the core idea — typed, sandboxed, language-neutral components — is solid enough to start experimenting with today.
