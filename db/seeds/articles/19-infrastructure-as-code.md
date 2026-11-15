---
title: "Infrastructure as code: what belongs in it, and what doesn't"
author: Maya Okafor
category: DevOps
published_at: 2024-11-30 08:05
tags: [infrastructure, terraform, devops]
image: 19-infrastructure-as-code-cover.png
image_alt: An infrastructure definition declaring a server and a firewall rule
summary: Declaring infrastructure in version control makes it reviewable and repeatable. It also has sharp edges — state, secrets and drift.
---

Infrastructure as code (IaC) means describing servers, networks, DNS and databases in files instead of clicking through a cloud console. The files live in git, changes go through review, and environments can be recreated from scratch.

## The core loop

Most declarative tools follow the same pattern:

```hcl
resource "server" "web" {
  name   = "web-1"
  image  = "ubuntu-24.04"
  size   = "medium"
  region = "eu-central"
}

resource "firewall_rule" "https" {
  server = server.web.id
  port   = 443
}
```

1. **Plan:** compare the files with what exists and show a diff.
2. **Review:** a human reads the plan in the pull request.
3. **Apply:** the tool makes reality match the files.

Reading the plan is the most important step. "1 to destroy" on your production database should never be a surprise.

## What belongs in IaC

- Networks, firewalls, load balancers and DNS
- Servers, managed databases and buckets
- IAM roles and permissions
- Monitoring and alert definitions

## What doesn't

- **Secrets.** Reference them from a secrets manager; don't commit values.
- **Application deploys.** Shipping a new version of your app every hour is a deploy tool's job, not an infrastructure change.
- **Data.** IaC creates the database; migrations and backups manage what's inside.

## The sharp edges

**State.** Tools track what they created in a state file. Store it remotely with locking, back it up and never edit it by hand.

**Drift.** Someone "just quickly" changes a setting in the console, and the files no longer describe reality. Run plans on a schedule to detect drift, and lock down console write access in production.

**Blast radius.** One giant configuration means every change risks everything. Split by environment and by lifecycle — networking changes rarely, app servers change often.

## Start small

You don't need to codify everything on day one. Start with DNS and one environment. Once changes reliably go through review, expand. The goal isn't perfect coverage — it's never having to wonder how production was configured.
