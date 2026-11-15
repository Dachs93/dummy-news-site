---
title: "Compilers 101: from source code to running program"
author: Priya Natarajan
category: Languages
published_at: 2024-05-11 12:40
tags: [compilers, parsing, interpreters, fundamentals]
image: 41-compilers-101-cover.png
image_alt: A tokenizer turning an arithmetic expression into a list of tokens
summary: Every language implementation follows a recognizable pipeline. Knowing the stages makes error messages, tooling and performance easier to understand.
---

Whether it's a C compiler, a JavaScript engine or the tool that runs your SQL, language implementations share a common shape. Understanding it demystifies everything from syntax errors to "why is the first call slower?"

## 1. Lexing

The lexer turns raw characters into **tokens**:

```text
input:  total = price * 2
tokens: IDENT(total) EQUALS IDENT(price) STAR NUMBER(2)
```

Whitespace and comments usually disappear here.

## 2. Parsing

The parser arranges tokens into an **abstract syntax tree** (AST) according to the grammar, respecting precedence — `*` binds tighter than `+`.

```text
Assign
├── total
└── Multiply
    ├── price
    └── 2
```

Syntax errors come from this stage. Linters, formatters and editors work on the AST too.

## 3. Semantic analysis

Name resolution (which `price` is this?), type checking and other rules the grammar can't express. "Undefined variable" and "type mismatch" errors come from here.

## 4. Intermediate representation

The AST is lowered into a simpler, more uniform IR that's easier to analyze and optimize — often a list of simple instructions or a control-flow graph.

## 5. Optimization

Constant folding (`2 * 3` becomes `6`), dead code elimination, inlining small functions and moving work out of loops.

## 6. Code generation

Finally: machine code for a specific CPU, bytecode for a virtual machine, or even another language.

## Interpreters and JITs

- **Interpreters** execute the AST or bytecode directly.
- **JIT compilers** start by interpreting, watch which code runs hot, then compile those parts to machine code at runtime — which is why many runtimes get faster after warming up.

## Why it's worth knowing

Better error messages make sense once you know which stage produced them. Tools like linters and codemods become approachable. And writing a tiny interpreter for a calculator or config language is one of the most rewarding weekend projects a developer can take on.
