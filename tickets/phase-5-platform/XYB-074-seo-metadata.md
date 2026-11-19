---
id: XYB-074
title: SEO, metadata and structured data
phase: 5-platform
type: dev
size: M
depends_on: [XYB-005, XYB-072]
skills: [nextjs, seo, json-ld]
good_first_issue: false
---

# XYB-074 — SEO, metadata and structured data

## Why this exists (the strategy)
**Claim:** when someone searches for a tech community, an event, or a member's name, Xyberclan answers clearly.
**Proof:** every page has an honest title and description, events appear as events in search results,
and search engines know exactly what Xyberclan is.

People find communities by searching "tech community in <city>", "design meetup <city>", or the name of
an event they heard about. Good metadata is not a trick. It is the site describing itself accurately.

## What the visitor should feel and do
- Feel: the search result already sounds like the clan, not like a template.
- Do: click the result that matches what they searched for.

## Scope
- Root metadata and a `metadataBase`.
- A title and description pattern for every route type.
- JSON-LD: `Organization` (site-wide), `Event` (event pages), `Person` (member pages, **only with consent**),
  `Article` (journal posts), `BreadcrumbList` (inner pages).
- `sitemap.xml`, `robots.txt`, canonical URLs.
- `hreflang` alternates for English and French on every page (helper `alternatesFor()` from XYB-006).

## Content
- Final copy for the home title and description, from XYB-018.
- The organisation facts from XYB-001: official name, founding date, city/country, logo, social profiles.

## Design spec
What a person sees in a search result:
- Title pattern: `<Page subject> — Xyberclan`. Home: `Xyberclan — Different minds. One frequency.`
- Description: one real sentence, 120–155 characters, saying what the page gives. Written, not generated
  from the first paragraph.
- Examples:
  - `/clan` → "Meet the clan — Xyberclan" / "Designers, developers and makers who build things together. Find your people by craft and city."
  - `/events/[slug]` → "<Event title>, <date> in <city> — Xyberclan" / the event's own one-line summary.
- **Failure state:** if an item has no description in its content file, the build fails with a clear message
  (better than shipping an empty or duplicated description).

## Motion spec
None.

## Build notes
- `src/app/layout.tsx`: `export const metadata` with `metadataBase: new URL(process.env.NEXT_PUBLIC_SITE_URL)`,
  `title: { default, template: "%s — Xyberclan" }`, `openGraph`, `twitter: { card: "summary_large_image" }`, icons from XYB-010.
- Dynamic routes use `generateMetadata()` reading the same content as the page (no second source of truth).
- JSON-LD component: `src/components/seo/json-ld.tsx` rendering `<script type="application/ld+json">` with
  `JSON.stringify` and `<` escaped as `<`. Types from `schema-dts`.
- `Organization`: name, url, logo, sameAs (Discord invite, GitHub org, Instagram, LinkedIn, X — only the real ones).
- `Event`: name, startDate/endDate with timezone offset, `eventAttendanceMode`, `eventStatus`, `location`
  (`Place` with address, or `VirtualLocation`), organizer → the Organization, `offers` with `price: 0` if free.
- `Person`: only when the member file has `consent.structuredData: true` (field added in XYB-072). Otherwise no Person markup.
- `src/app/sitemap.ts`: every static route + every member (with consent) + event + project + post, with `lastModified` from content.
- `src/app/robots.ts`: allow all in Production; **disallow all on Preview deployments** (check `VERCEL_ENV`)
  so preview URLs never get indexed.
- Canonical: `alternates.canonical` on every page. Strip query strings.
- `hreflang`: `alternates.languages: { en: …, fr: …, "x-default": … }`.
- Add `pnpm seo:check` (a small script) that fails if any built page has a missing or duplicate title/description.

## Acceptance criteria
- [ ] Every route has a unique title and description following the pattern; `pnpm seo:check` passes in CI.
- [ ] Google Rich Results Test validates the Event markup on at least two real event pages.
- [ ] Schema.org validator shows no errors for Organization, Article and BreadcrumbList.
- [ ] No `Person` markup appears for a member without `consent.structuredData: true` (tested with two fixtures).
- [ ] `/sitemap.xml` lists every public page and no draft, preview or private page.
- [ ] `/robots.txt` disallows everything on Preview and allows indexing on Production.
- [ ] Every page has a canonical URL without query strings.
- [ ] Every page has correct English/French `hreflang` pairs and an `x-default`.
- [ ] Lighthouse SEO score is 100 on home, `/clan`, an event page and a journal post.
- [ ] Follows the house rules in `docs/creative-direction.md` §4 (no keyword stuffing, no invented facts).

## Out of scope
- Share images (XYB-073).
- Content marketing or keyword strategy.
- Paid search.

## References
- Next.js Metadata API docs; Google Search Central: Event structured data.
- Trait to learn: Lu.ma event pages — clean, accurate event metadata that search engines display well.
