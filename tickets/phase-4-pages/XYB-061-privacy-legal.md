---
id: XYB-061
title: Privacy and legal pages
phase: 4-pages
type: content
size: S
depends_on: [XYB-070, XYB-071, XYB-072, XYB-075]
skills: [copywriting, privacy, nextjs, mdx]
good_first_issue: true
---

# XYB-061 — Privacy and legal

## Why this exists (the strategy)
**Claim:** we treat your data the way we'd want ours treated. **Proof:** a short, plain-language page that
lists exactly what we collect (blob config, application form, analytics without cookies), why, where it is
stored, how long, and how to get it deleted — with a real contact.

A community that says "no algorithms, just chemistry" must not quietly track people. Being honest here is
part of the brand, and a requirement if the clan has members under data-protection laws (e.g. GDPR for
members in Europe, Cameroon's 2024 personal data law if XYB-001 confirms the base there — the team must
check, not assume).

## What the visitor should feel and do
- **Feel:** "They're not hiding anything."
- **Do:** find the answer in under a minute; ask for deletion if they want.

## Scope
- `/privacy`: what we collect, why, where, how long, who sees it, your rights, how to ask, contact, last updated.
- `/legal` (or a section of `/privacy`): who runs the site (organisation or named people, as XYB-001
  confirms), contact address, content licence for member content, credits for third-party assets and fonts.
- Footer links to both (XYB-030).
- No cookie banner **if** we truly use no non-essential cookies (XYB-075 must confirm cookieless analytics).

## Content
| Content | Source |
| --- | --- |
| Data inventory | Builders of XYB-071 (join form: name, email, crafts, why, how found, blob config, consent, timestamp, IP for spam only?), XYB-075 (analytics: what is collected), XYB-070 (Discord: what we fetch), XYB-072 (GitHub: public profile data in PRs) |
| Storage locations and processors | XYB-071 (e.g. Supabase region), hosting (Vercel), email (Resend), analytics provider, Cloudflare Turnstile, rate limiting (Upstash Redis), the nightly retention job (XYB-071) |
| Retention periods | Founders decide (e.g. applications deleted 6 months after decision; analytics aggregated only) |
| Rights and contact | Founders. A real email alias (e.g. privacy@…) that someone reads. |
| Responsible entity | XYB-001 (association, company, or named organisers) |
| Credits (fonts, Contributor Covenant, map tiles, any licensed media) | XYB-012, XYB-059, XYB-055, XYB-017 credit lists |

This ticket writes plain language from facts others provide. **It is not legal advice.** If the clan is a
registered organisation, a qualified person should review the text before launch (record who, in the PR).

## Page structure

### `/privacy`
1. **In short.** `h1` "Privacy." and 4–5 lines at statement size, draft — confirm in XYB-018: "We collect
   what you send us when you join, and anonymous visit counts. No ads, no tracking cookies, no selling data.
   Ever." Its job: the whole answer for most people.
2. **What we collect, and why.** A real `<table>`: data · why · where it's stored · how long. One row per
   item. Tables may have lines (house rules exception for real tables). Its job: precision.
3. **Who can see it.** Moderators, processors (named), nobody else.
4. **Your rights.** See, correct, delete, object — and exactly how to ask (email, Discord mod-mail), with the
   response time the team commits to.
5. **Changes.** How we tell members about changes; "Last updated" date.

### `/legal`
1. Who runs this site, contact.
2. Member content: members own what they publish; they give Xyberclan permission to show it on the site;
   they can remove it any time (how).
3. Credits and licences.

## Design spec

Shared `ReadingLayout` with XYB-059. Reading column 60–70ch, body 18px, full ink. The data table full
column width on desktop; on phone (390) it turns into stacked definition lists per row (no horizontal page
scroll). A small blob holding a padlock accessory (inline SVG from XYB-016, if XYB-015 includes it) beside the
"In short" block — the only illustration.

## Motion spec
- None beyond the shared page entrance (XYB-023) for the "In short" block. These are reading pages.
- Reduced motion: nothing moves.

## Build notes
- Routes: `app/(site)/privacy/page.tsx`, `app/(site)/legal/page.tsx`; content in
  `content/pages/privacy.mdx`, `content/pages/legal.mdx`.
- Keep the data inventory in one source of truth: `content/data-inventory.json`, rendered into the table and
  reviewed whenever XYB-070/071/072/075 change (add a CODEOWNERS rule pointing to the privacy owner).
- "Last updated" comes from the content file frontmatter, not the build date.
- Link from the join form's consent area (XYB-058) to `/privacy`.

## Acceptance criteria
- [ ] Every piece of personal data collected anywhere on the site appears in the data inventory (checked against XYB-071, XYB-075, XYB-070, XYB-072 code).
- [ ] Every processor is named with its storage region.
- [ ] A test deletion request sent to the contact gets a human answer (record date in the PR).
- [ ] No cookie banner is shown and the browser shows no non-essential cookies set on first visit (DevTools → Application → Cookies); if any exist, this criterion fails and a consent solution becomes a new ticket.
- [ ] The data table is readable at 390 without horizontal page scroll.
- [ ] Credits list covers every font, licensed text, map tiles and any third-party media used on the site.
- [ ] Reviewer named in the PR if a legal review was done; if not, the PR says so plainly.
- [ ] Layout checked at 1440 / 768 / 390.
- [ ] Bilingual: every visible string comes from `messages/*.json` or localized content (XYB-006); the section works in English and French, and every headline still fits two lines in French at 1440, 768 and 390.
- [ ] Follows the house rules in `docs/creative-direction.md` §4.

## Out of scope
- Terms of service for a paid product (there is none).
- Cookie consent manager (only if a future ticket adds cookies).

## References
- Basecamp / Plausible privacy pages: plain, short, specific.
- GOV.UK: tables and answers people can scan.
