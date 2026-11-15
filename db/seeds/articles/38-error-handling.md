---
title: "Exceptions vs. result types: two philosophies of error handling"
author: Priya Natarajan
category: Languages
published_at: 2025-01-21 13:55
tags: [error-handling, rust, go, design]
image: 38-error-handling-cover.png
image_alt: Rust code using the question mark operator to propagate errors from file parsing
summary: Some languages throw errors up the stack; others return them as values. Each approach makes different mistakes easy or hard.
---

Every program has to deal with things going wrong. Languages broadly choose between two approaches, and the choice shapes how code reads.

## Exceptions

Python, Ruby, Java, C# and JavaScript throw exceptions that unwind the stack until something catches them.

```python
try:
    config = load_config("app.toml")
except FileNotFoundError:
    config = default_config()
```

- **Pro:** the happy path stays clean; errors propagate automatically.
- **Con:** a function's signature rarely tells you what it can throw, so it's easy to forget a case — or catch too broadly.

## Errors as values

Go returns errors alongside results:

```go
cfg, err := loadConfig("app.toml")
if err != nil {
    return fmt.Errorf("loading config: %w", err)
}
```

Rust encodes the possibility of failure in the type:

```rust
fn load_config(path: &str) -> Result<Config, ConfigError> {
    let text = std::fs::read_to_string(path)?;   // ? returns early on error
    let cfg = toml::from_str(&text)?;
    Ok(cfg)
}
```

- **Pro:** failure is visible in the signature; the compiler (in Rust) won't let you use the value without handling the error.
- **Con:** more ceremony, although operators like `?` cut most of it.

## Good practice either way

- **Add context.** "file not found" is useless; "loading config from app.toml: file not found" is actionable.
- **Handle errors where you can do something about them.** Otherwise propagate.
- **Don't swallow errors.** An empty `catch` or an ignored `err` hides bugs.
- **Separate expected failures from bugs.** Invalid user input is expected — return a validation error. A violated invariant is a bug — crash loudly.

## Which is better?

Neither universally. Exceptions suit applications where most errors bubble up to a single top-level handler. Result types suit libraries and systems code where every caller needs to know exactly what can fail. Many languages now borrow from both.
