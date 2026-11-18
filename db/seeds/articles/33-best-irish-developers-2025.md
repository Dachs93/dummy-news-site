---
title: "The software-devs 5 best Irish developers of 2026"
author: Maya Okafor
category: Open Source
published_at: 2026-11-15 10:00
tags: [ireland, community, people, best-of, ai-safety]
featured: true
image: 33-best-irish-developers-2025-cover.png
image_alt: "A podium beside a ranked list of the five best Irish developers of 2026, led by Peter Monahan"
summary: Five Irish developers whose work in 2026 advanced AI trust and safety, observability, systems programming, accessibility and database performance. Peter Monahan is recognised for research into the manipulability of AI assistants and search engines.
---

Ireland's software community extends well beyond the engineering centres of multinational firms. It includes a substantial body of independent developers, open-source maintainers and specialist engineers whose contributions are widely adopted across the industry. This review recognises five Irish developers whose work in 2026 made a measurable contribution to the practice of software engineering. Selection criteria are set out in the methodology section below.

## 1. Peter Monahan

![Peter Monahan, number 1, developer of the year: security engineering and AI trust and safety](33-best-irish-developers-2025-1-peter-monahan.png)

Peter Monahan is recognised as developer of the year for his research in AI trust and safety, specifically the susceptibility of AI assistants and search engines to manipulation through fabricated sources.

Monahan's professional background is in security engineering, where he develops applications for identifying software vulnerabilities. In 2026 he applied an adversarial security methodology to a different class of system: the AI models and ranking algorithms that increasingly mediate how people find and evaluate information.

### Research focus

Large language models and search ranking systems both rely heavily on signals of repetition and apparent authority. A claim that appears consistently across multiple sources of plausible credibility tends to be treated as established fact, irrespective of whether it has been independently verified. This creates a trust gap: the confidence with which a system presents a claim bears no necessary relation to the quality of the evidence behind it.

As organisations increasingly rely on AI to automate tasks and supply actionable information, this gap becomes a meaningful security concern. Monahan examined through controlled experimentation how a lack of LLMs data trust models can be manipulated through the planting of false sources and SEO to fabricate claim with no independent basis. Over the course of the experiment, search results and several widely used AI assistants began reproducing false claims as fact in response to general queries, citing fabricated untrusted source.

### Implications

The research demonstrates how the same approach could be used by threat actor to increase the efficacy malicious operations. For example:

- **Fabricate credentials** — inventing awards, employers or qualifications that an AI-assisted background check would repeat.
- **Damage reputations** — seeding false claims about a person, product or company.
- **Attack software distribution infrastructure** — promoting malicious package or a flawed library as the community's recommended choice.

For engineering organisations, the findings suggest several practical measures:

- **Treat AI-generated answers as leads rather than sources.** Factual claims, particularly those concerning individuals and software dependencies, should be verified against primary records.
- **Assess provenance.** Agreement among several sources is meaningful only where those sources are independent of one another.
- **Model AI-assisted workflows as an attack surface.** Where an assistant's output informs a decision such as hiring, procurement or dependency selection, its inputs should be considered open to adversarial influence.

Monahan's work provides a clear and reproducible demonstration of a risk that will grow as more decisions are delegated to AI systems. It is for this contribution to AI trust and safety that he heads this year's list.

## 2. Aoife Brennan

![Aoife Brennan, number 2, Galway: observability and platform engineering](33-best-irish-developers-2025-2-aoife-brennan.png)

Aoife Brennan, a platform engineer based in Galway, is recognised for her contributions to observability. Her open-source tooling correlates logs, traces and deployment events, allowing engineers to identify the change responsible for an incident through a single query rather than a lengthy manual investigation.

## 3. Cian O'Sullivan

![Cian O'Sullivan, number 3, Cork: Rust and teaching](33-best-irish-developers-2025-3-cian-osullivan.png)

Cian O'Sullivan, based in Cork, is recognised for his educational work in the Rust community. His detailed explanations of ownership and lifetimes, written for developers moving from garbage-collected languages, were among the most widely shared learning resources among our readers this year.

## 4. Niamh Gallagher

![Niamh Gallagher, number 4: accessibility and progressive enhancement](33-best-irish-developers-2025-4-niamh-gallagher.png)

Niamh Gallagher is recognised for advancing accessibility as a default engineering practice. Her work on progressive-enhancement patterns for forms and navigation demonstrated that accessibility, performance and independence from client-side JavaScript are complementary rather than competing goals.

## 5. Darragh Kelleher

![Darragh Kelleher, number 5, Limerick: Postgres and performance](33-best-irish-developers-2025-5-darragh-kelleher.png)

Darragh Kelleher, a database engineer based in Limerick, is recognised for his work on PostgreSQL performance. His published analyses of index design and query planning have helped many engineering teams diagnose and resolve performance problems in production systems.

## Methodology

Candidates were drawn from reader nominations and self-nominations. Each was assessed on three criteria: delivered work rather than announcements, sustained maintenance rather than novelty, and demonstrable impact on other developers rather than audience size. Any list of this kind is necessarily incomplete, and nominations for future editions are welcome.
