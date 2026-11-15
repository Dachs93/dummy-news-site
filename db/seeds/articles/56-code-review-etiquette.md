---
title: "Code review etiquette for authors and reviewers"
author: Editorial Team
category: Tools
published_at: 2025-06-11 08:50
tags: [code-review, collaboration, engineering-culture]
image: 56-code-review-etiquette-cover.png
image_alt: Review comments prefixed with labels such as nit, question and blocking
summary: Good reviews catch bugs and spread knowledge without bruising anyone. Small habits on both sides of the pull request make the process faster and kinder.
---

Code review is one of the few rituals almost every software team shares. Done well, it catches bugs, spreads knowledge and keeps a codebase coherent. Done badly, it's a bottleneck and a source of friction.

## For authors

- **Keep pull requests small.** A 200-line change gets a careful review; a 2,000-line change gets a rubber stamp.
- **Explain the why.** Link the issue, describe the approach and call out anything you're unsure about.
- **Review your own diff first.** You'll catch debug statements and typos before anyone else has to.
- **Separate refactors from behavior changes** so reviewers can reason about each.
- **Don't take it personally.** Comments are about the code, not about you.

## For reviewers

- **Review promptly.** A pull request waiting a day blocks someone's work and invites merge conflicts.
- **Focus on what matters:** correctness, security, design and clarity. Let linters and formatters handle style.
- **Ask questions** instead of issuing commands — "What happens if the list is empty?" invites thinking.
- **Say what's good.** Pointing out a clean solution is useful feedback too.

## Label your comments

Make the weight of each comment explicit:

```text
nit: could be `find_each` here, but fine as is
question: is this called for archived accounts too?
suggestion: extract this into a method so it's testable
blocking: this skips the permission check for admins
```

Authors immediately know what must change before merging and what's optional.

## Approve with comments

If the remaining feedback is minor, approve and trust the author to address it. Round-trip cycles for nitpicks waste everyone's time.

## When it gets stuck

If a thread goes back and forth more than twice, switch to a call. Ten minutes of conversation resolves what twenty comments can't — then write the conclusion in the pull request for posterity.
