---
title: "Secrets management for small teams"
author: Samuel Brandt
category: Security
published_at: 2025-04-06 14:10
tags: [security, secrets, devops, credentials]
image: 47-secrets-management-cover.png
image_alt: A shell session scanning a repository for accidentally committed secrets
summary: API keys in the repo, passwords in chat, one shared admin login. A practical path from secret sprawl to something you can actually audit and rotate.
---

Every application has secrets: database passwords, API keys, signing keys. In young teams they tend to sprawl across `.env` files, chat messages and CI settings. Here's a path to something better that doesn't require a platform team.

## Rule one: not in git

Even private repositories get cloned to laptops, shared with contractors and mirrored to CI. Once a secret is in history, assume it's exposed. Add secret scanning to catch mistakes:

```bash
$ secret-scan --since origin/main
✖ config/payments.yml:4  possible API key
  remove it, rotate it, then rewrite or accept history
```

If a secret is committed, **rotate it first**. Rewriting history doesn't help if it was already pushed.

## Rule two: one source of truth

Pick one place secrets live:

- **Encrypted files in the repo**, decrypted with a key stored outside it. Simple, versioned and reviewable.
- **A password manager** with a CLI, so scripts and deploy tools can fetch secrets.
- **A dedicated secrets manager** from your cloud provider or a self-hosted vault, once you need fine-grained access control and audit logs.

Inject secrets into the app as environment variables or files at deploy time.

## Rule three: least privilege

- Separate secrets per environment: staging keys must not work in production.
- Scope API keys to the permissions the app needs.
- Give CI only the secrets each job requires.

## Rule four: plan for rotation

Rotation is when a secret leaks — or someone leaves the team. Make it routine:

1. Support two valid credentials at once during the switch.
2. Script the rotation so it isn't a scary manual process.
3. Prefer short-lived credentials issued on demand over long-lived keys.

## Rule five: personal accounts

Shared admin logins make it impossible to know who did what or to revoke one person's access. Use individual accounts with SSO and MFA wherever the service allows it.

You don't need all of this on day one. But "out of git, in one place, rotatable" covers most of the risk.
