---
title: "Signing commits and build artifacts: proving where code came from"
author: Samuel Brandt
category: Security
published_at: 2024-01-26 14:25
tags: [security, git, supply-chain, signing]
image: 52-signing-commits-artifacts-cover.png
image_alt: Git configuration enabling SSH-based commit signing
summary: Anyone can set their git author name to yours. Signatures let you verify who actually made a commit, and which pipeline produced a release.
---

Git's author field is just text. Anyone can commit as "Linus Torvalds" or as your lead engineer. Signing adds cryptographic proof of who created a commit or a release artifact.

## Signing commits with an SSH key

Git can sign with the SSH key you probably already use:

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
git config --global tag.gpgsign true
```

Upload the same public key to your code host as a signing key, and signed commits show as verified. GPG keys work too, but SSH keys are simpler for most teams.

## Verifying

```bash
git log --show-signature -1
git verify-tag v2.4.0
```

For local verification of SSH signatures, configure an allowed-signers file that maps identities to public keys.

## Enforcing it

Most code hosts can require signed commits on protected branches. Combine that with required reviews so a single compromised account can't push straight to production.

## Signing artifacts

Commits are only half the story. What users actually run is a build artifact: a container image, a package, a binary. Signing artifacts lets consumers verify they came from your build pipeline and weren't swapped along the way.

- Sign container images and release binaries in CI.
- Use **keyless signing** where available: CI proves its identity with short-lived credentials instead of a long-lived private key you'd have to protect.
- Publish **provenance** — metadata describing which source commit and build process produced the artifact.

## Verify on the consuming side

Signatures only help if someone checks them. Configure deploys to verify image signatures, and prefer dependencies that publish signed releases.

## Why bother

Supply-chain attacks target the gap between "code we reviewed" and "code we run." Signing commits and artifacts closes that gap with evidence instead of trust.
