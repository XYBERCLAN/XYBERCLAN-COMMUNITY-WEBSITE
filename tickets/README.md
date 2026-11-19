# Xyberclan website — Tickets

This folder is the full plan to build the Xyberclan community website, written as tickets that
**members of the clan pick up and build**. Each ticket is one file, one GitHub issue, one pull request.

**Start here:** read [`docs/creative-direction.md`](../docs/creative-direction.md) (10 minutes). Every
ticket assumes you have. Then find your lane in the [team plan](../docs/team-plan.md): seven developers, seven lanes, six sprints.

**The site is bilingual, English and French, from day one.** No page or component with text is built before
XYB-006 is merged. Every PR shows both languages.

---

## How to work a ticket

1. Take the next ticket in your lane (see the [team plan](../docs/team-plan.md)) whose `depends_on` are all merged. Helping out? Filter by `good_first_issue: true`.
2. Comment on its GitHub issue ("I'm on it") so nobody doubles up. One person owns a ticket at a time.
3. Branch: `xyb-031-hero` (ticket id + short name).
4. Build it. Check every box under **Acceptance criteria** yourself before asking for review.
5. Open a PR titled `XYB-031: Hero`, paste the acceptance checklist with boxes ticked, add screenshots at
   1440 / 768 / 390 **in English and French** and a short screen recording for anything that moves.
6. Your pair lane reviews the code, a designer reviews the look, a French copy owner reviews French text. Merge. Close the issue.

Sizes: **S** = ½ day · **M** = 1–2 days · **L** = 3–5 days. Nothing is bigger; big work is split.

---

## The stack (decided in XYB-002, change only by a new ticket)

| Layer | Choice |
| --- | --- |
| Framework | Next.js 16 (App Router), React 19, TypeScript strict |
| Styling | Tailwind CSS v4 with CSS custom-property tokens |
| Motion | GSAP 3 (ScrollTrigger, SplitText, @gsap/react) + Lenis smooth scroll + CSS for simple states |
| Blobs | Inline SVG from the Figma art kit, animated with GSAP — no WebGL |
| Languages | English + French with next-intl, `messages/{en,fr}.json`, localized content (XYB-006) |
| Content | MDX + JSON in the repo, typed with zod (Velite or Content Collections) |
| Hosting | Vercel (preview deploy on every PR) |
| Package manager | pnpm |

---

## Milestones

| Milestone | Tickets | What exists when it is done |
| --- | --- | --- |
| **M0 — Ground** | Phase 0 | The repo builds, deploys, speaks English and French, and accepts contributions. |
| **M1 — Language** | Phase 1 + 2 | Tokens, type, components, blobs and the motion engine. You can build any section. |
| **M2 — Home** | Phase 3 + XYB-070 + XYB-058 part 1 (the Blob Maker) | The home page, complete and moving. This is the first public launch. |
| **M3 — The whole clan** | Phase 4 + 5 | Every page, the Blob Maker, real data, joining works end to end. |
| **M4 — Launch** | Phase 6 | Audited, fast, accessible, ready for galleries. |

`M3` in a *Depends on* column means "every ticket of Phase 4 and 5 is merged".

Phase 1 (brand) and Phase 2 (motion) run **in parallel**: designers on one, developers on the other.

---

## All tickets

### Phase 0 — Foundations · `tickets/phase-0-foundations/`

| ID | Ticket | Type | Size | Depends on |
| --- | --- | --- | --- | --- |
| XYB-001 | [Clan facts & PRODUCT.md](phase-0-foundations/XYB-001-clan-facts-product-md.md) | content | M | — |
| XYB-002 | [Scaffold the app](phase-0-foundations/XYB-002-scaffold-the-app.md) | dev | M | — |
| XYB-003 | [CI/CD and preview deploys](phase-0-foundations/XYB-003-ci-cd-previews.md) | dev | M | 002 |
| XYB-004 | [Contribution system](phase-0-foundations/XYB-004-contribution-system.md) | dev | S | 002 |
| XYB-005 | [Content layer and schemas](phase-0-foundations/XYB-005-content-layer.md) | dev | M | 002, 006, 015 (enums only) |
| XYB-006 | [Bilingual foundation (English + French)](phase-0-foundations/XYB-006-bilingual-foundation.md) | dev | L | 002 |

### Phase 1 — Brand & design system · `tickets/phase-1-brand-system/`

| ID | Ticket | Type | Size | Depends on |
| --- | --- | --- | --- | --- |
| XYB-010 | [Logo, wordmark and favicons](phase-1-brand-system/XYB-010-logo-wordmark.md) | design | M | 001 |
| XYB-011 | [Colour system](phase-1-brand-system/XYB-011-colour-system.md) | design | M | 001 |
| XYB-012 | [Type system](phase-1-brand-system/XYB-012-type-system.md) | design | M | 001 |
| XYB-013 | [Layout primitives: grid, margins, rhythm](phase-1-brand-system/XYB-013-layout-primitives.md) | dev | M | 011, 012 |
| XYB-014 | [Core UI components](phase-1-brand-system/XYB-014-core-components.md) | dev | L | 013, 006 |
| XYB-015 | [The Blob species: character bible](phase-1-brand-system/XYB-015-blob-character-bible.md) | design | L | 011 |
| XYB-016 | [2D blob art kit: Figma to SVG](phase-1-brand-system/XYB-016-2d-blob-art-kit.md) | design | L | 015 |
| XYB-017 | [Photography and imagery direction](phase-1-brand-system/XYB-017-photography-direction.md) | content | M | 001 |
| XYB-018 | [Voice and UX copy guide](phase-1-brand-system/XYB-018-voice-copy-guide.md) | content | M | 001 |

### Phase 2 — Motion & interaction engine · `tickets/phase-2-motion-engine/`

| ID | Ticket | Type | Size | Depends on |
| --- | --- | --- | --- | --- |
| XYB-020 | [Motion tokens and the clan beat](phase-2-motion-engine/XYB-020-motion-tokens-clan-beat.md) | motion | M | 002 |
| XYB-021 | [Smooth scroll + ScrollTrigger plumbing](phase-2-motion-engine/XYB-021-smooth-scroll-plumbing.md) | dev | M | 020 |
| XYB-022 | [Accessible text reveal](phase-2-motion-engine/XYB-022-accessible-text-reveal.md) | motion | M | 021 |
| XYB-023 | [Section entrance system](phase-2-motion-engine/XYB-023-section-entrances.md) | motion | M | 021 |
| XYB-024 | [Page transitions: the blob wipe](phase-2-motion-engine/XYB-024-page-transitions.md) | motion | L | 021, 015 |
| XYB-025 | [Blob renderer (SVG)](phase-2-motion-engine/XYB-025-blob-renderer.md) | dev | L | 002, 016 (can start with the hero duo only) |
| XYB-026 | [Blob behaviour kit](phase-2-motion-engine/XYB-026-blob-behaviour-kit.md) | motion | L | 020, 025 |
| XYB-027 | [Micro-interactions and states](phase-2-motion-engine/XYB-027-micro-interactions.md) | motion | M | 014, 020 |
| XYB-028 | [Sound of the clan (optional)](phase-2-motion-engine/XYB-028-sound-layer.md) | motion | M | 020 |

### Phase 3 — Home page · `tickets/phase-3-home/`

Each section is its own ticket, in scroll order. Each has one job.

| ID | Section | Its one job | Size | Depends on |
| --- | --- | --- | --- | --- |
| XYB-030 | [Navigation and footer](phase-3-home/XYB-030-nav-footer.md) | Always know where you are; end every page with the name. | M | 014, 010, 017, 006 |
| XYB-031 | [Hero: Different minds. One frequency.](phase-3-home/XYB-031-hero.md) | Say what Xyberclan is in 5 seconds and make you smile. | L | 014, 022, 026 |
| XYB-032 | [Signature scene: into phase](phase-3-home/XYB-032-signature-scene-into-phase.md) | Act out the tagline: different blobs fall into one beat. | L | 026, 021, 005 |
| XYB-033 | [What happens here: three verbs](phase-3-home/XYB-033-three-verbs.md) | Prove the clan does things: find, trade, make. | L | 023, 017 |
| XYB-034 | [The pulse: the clan right now](phase-3-home/XYB-034-the-pulse.md) | Prove it is alive today, with live data. | M | 070, 023 |
| XYB-035 | [Members preview: the crowd](phase-3-home/XYB-035-members-preview.md) | Show the people. Make you want to be one of them. | M | 026, 005 |
| XYB-036 | [Built by the clan](phase-3-home/XYB-036-built-by-the-clan.md) | Show the work members shipped together. | M | 005, 023 |
| XYB-037 | [Next events: the tickets](phase-3-home/XYB-037-next-events.md) | Give you a date to show up. | M | 005, 023 |
| XYB-038 | [Mindset teaser](phase-3-home/XYB-038-mindset-teaser.md) | Say what we believe in one line you remember. | S | 022 |
| XYB-039 | [Member voices](phase-3-home/XYB-039-member-voices.md) | Let members, not us, say why it matters. | M | 017, 023 |
| XYB-040 | [Final call: your blob is waiting](phase-3-home/XYB-040-final-call-blob-teaser.md) | Turn interest into joining, with the Blob Maker teaser. | M | 026, 058 (maker part only) |

### Phase 4 — Inner pages · `tickets/phase-4-pages/`

| ID | Page | Its one job | Size | Depends on |
| --- | --- | --- | --- | --- |
| XYB-050 | [The Clan directory `/clan`](phase-4-pages/XYB-050-clan-directory.md) | Find your people by craft, city, interest. | L | 005, 026 |
| XYB-051 | [Member profile `/clan/[handle]`](phase-4-pages/XYB-051-member-profile.md) | Respect the person; show what they make. | M | 050, 073 |
| XYB-052 | [What's inside `/inside`](phase-4-pages/XYB-052-whats-inside.md) | Show the inside before you join. | L | 023, 017 |
| XYB-053 | [Our mindset `/mindset`](phase-4-pages/XYB-053-our-mindset.md) | The manifesto, as a scroll story. | L | 022, 032 |
| XYB-054 | [Events index `/events`](phase-4-pages/XYB-054-events-index.md) | What's next, what happened. | M | 005, 037 |
| XYB-055 | [Event page `/events/[slug]`](phase-4-pages/XYB-055-event-page.md) | Everything to show up, then the recap. | M | 054 |
| XYB-056 | [Built by the clan `/built`](phase-4-pages/XYB-056-built-showcase.md) | Projects as case studies. | M | 005, 036 |
| XYB-057 | [Journal `/journal`](phase-4-pages/XYB-057-journal.md) | Member stories worth reading. | M | 005 |
| XYB-058 | [Join + Blob Maker `/join`](phase-4-pages/XYB-058-join-blob-maker.md) | Make your blob, then join. The live thing. | L | 026, 015; application step: 071 |
| XYB-059 | [Code of conduct `/conduct` + FAQ `/faq`](phase-4-pages/XYB-059-conduct-faq.md) | Make it safe and answer the real questions. | S | 018 |
| XYB-060 | [404, error and empty states: the lost blob](phase-4-pages/XYB-060-lost-blob-states.md) | Make even dead ends feel like the clan. | S | 026, 025 |
| XYB-061 | [Privacy and legal](phase-4-pages/XYB-061-privacy-legal.md) | Be honest about data. | S | 070, 071, 072, 075 |

### Phase 5 — Platform & integrations · `tickets/phase-5-platform/`

| ID | Ticket | Type | Size | Depends on |
| --- | --- | --- | --- | --- |
| XYB-070 | [Discord integration: live counts and invite](phase-5-platform/XYB-070-discord-integration.md) | dev | M | 002 |
| XYB-071 | [Join application backend](phase-5-platform/XYB-071-join-backend.md) | dev | L | 005 |
| XYB-072 | [Add yourself (and projects, events) by pull request](phase-5-platform/XYB-072-add-yourself-by-pr.md) | dev | M | 005, 004 |
| XYB-073 | [Dynamic share images](phase-5-platform/XYB-073-dynamic-og-images.md) | dev | M | 016, 012 |
| XYB-074 | [SEO, metadata and structured data](phase-5-platform/XYB-074-seo-metadata.md) | dev | M | 005, 072 |
| XYB-075 | [Privacy-first analytics](phase-5-platform/XYB-075-analytics.md) | dev | S | 002 |
| XYB-076 | [French voice, glossary and bilingual review](phase-5-platform/XYB-076-i18n-en-fr.md) | content | L | 006, 018 (starts in Sprint 1, runs every sprint) |

### Phase 6 — Quality & launch · `tickets/phase-6-quality-launch/`

| ID | Ticket | Type | Size | Depends on |
| --- | --- | --- | --- | --- |
| XYB-080 | [Accessibility audit (WCAG 2.2 AA)](phase-6-quality-launch/XYB-080-accessibility-audit.md) | qa | M | M3 |
| XYB-081 | [Performance budget](phase-6-quality-launch/XYB-081-performance-budget.md) | qa | M | 003 (full pass after M3) |
| XYB-082 | [Device and browser QA](phase-6-quality-launch/XYB-082-device-browser-qa.md) | qa | M | M3 |
| XYB-083 | [Content QA and launch checklist](phase-6-quality-launch/XYB-083-launch-checklist.md) | qa | S | 080–082 |
| XYB-084 | [Showcase kit for galleries](phase-6-quality-launch/XYB-084-showcase-kit.md) | content | M | 083 |

---

## Turning these into GitHub issues

```bash
./scripts/tickets-to-issues.sh            # dry run: prints what it would create
./scripts/tickets-to-issues.sh --create   # creates one issue per ticket with labels
```

Needs the GitHub CLI (`gh auth login`) and a GitHub remote on this repo.
