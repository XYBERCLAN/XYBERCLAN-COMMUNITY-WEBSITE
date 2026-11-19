---
id: XYB-032
title: "Signature scene: into phase"
phase: 3-home
type: motion
size: L
depends_on: [XYB-026, XYB-021, XYB-005]
skills: [gsap, scrolltrigger, svg, performance]
good_first_issue: false
---

# XYB-032 — Signature scene: into phase

## Why this exists (the strategy)
**Claim:** in Xyberclan, very different people end up on the same wavelength.

**Proof:** we don't just write the tagline, we **act it out**. The two hero blobs are joined by a crowd of
member blobs, one for each real member. Each one starts bobbing on its own rhythm (different minds). As you
scroll, they slowly fall into the same beat (one frequency). At the end the whole crowd bobs together and
the real member count appears.

This is the site's signature move: the one moment people will screen-record and share. It is also the
moment the brand idea becomes obvious without explanation.

## What the visitor should feel and do
- **Feel:** a small "oh!" when the crowd clicks into sync. Warmth: there are real people here.
- **Do:** keep scrolling, and notice there's a blob for every member.

## Scope
- A pinned scroll section directly after the hero.
- The crowd of blobs (one per member, capped for performance), each with its own phase.
- A `sync` value 0 → 1 scrubbed by scroll.
- Three copy beats and the final member count.
- Phone version and reduced-motion version.

## Content
- **Member count:** the real number of member files in `content/members/` (XYB-005), counted at build time.
  If the Discord member count (XYB-070) is higher, we still show the content count and say "members on the
  wall" — we never mix sources in one number.
- **Blob looks:** each member's own blob config (species + colour) from their member file. Members without a
  config get a species/colour picked deterministically from their handle (same look every visit).
- **Copy beats** (draft — confirm in XYB-018):
  1. At `sync` 0.0: "Different minds."
  2. At `sync` 0.5: "Different crafts, cities, ideas." (or a line from XYB-018 about who the clan is)
  3. At `sync` 1.0: "One frequency."
  4. Final, under the crowd: "**{count}** members on the same wavelength." + text link **Meet the clan →** `/clan`.
- Owner: content comes from the members data; copy from XYB-018.

## Design spec

**Desktop (1440)**
- The section pins for **about 250vh of scroll** (so it holds about 2.5 screens).
- Field: paper at the start. As `sync` passes 0.85, the field steps to **Lagoon** in one move (a full colour
  change, timed with "One frequency."). No fade between colours: one short 300ms crossfade of the field only is the limit.
- The crowd fills the lower 60% of the screen: a loose, natural crowd (not a grid) on 3–4 depth rows, back
  rows smaller. The two hero blobs are front centre.
- Copy beats appear one at a time in the upper third, left aligned on the grid, at display size step 2
  (about 72px), two lines max. Only one beat is on screen at a time.
- Final count: the number at display size (as big as the hero headline), the sentence at text-large next to it.

**Tablet (768)**
- Pin length 200vh. Crowd on 3 rows. Copy at step 3.

**Phone (390)**
- Pin length 160vh. Max 24 blobs visible, 2 rows. Copy at step 4 (about 44px), still left aligned.
- If the device is low-power, keep the bob and the sync but drop the look-at and the shared jump.

**Crowd size**
- Up to 60 animated blobs on desktop, 36 on tablet, 24 on phone. If there are more members, show the cap and
  the true count in the text. Each blob is one `<use href="#species">` from the blob sprite (XYB-025), coloured by
  its own `--blob` variable, so 60 blobs cost 60 small DOM nodes and no images.

## Motion spec
- **Phases:** each blob gets a phase offset `φ` (0…2π) from its handle hash. Idle bob:
  `y = A · sin(2π · f · t + φ · (1 − sync))`, where `f` is the clan beat frequency (XYB-020).
  At `sync = 0` they are scattered; at `sync = 1` all bob in perfect unison.
- **Entrance:** as the pin starts, blobs pop up from below the floor row by row, back to front, 30ms stagger,
  each landing with a small squash.
- **Scrub:** ScrollTrigger maps scroll progress → `sync` (0 → 1) with `scrub: 0.6` for softness. The copy beats
  swap at 0, 0.5 and 1.0 with a word reveal (XYB-022).
- **The click:** at `sync = 1` all blobs do one shared little jump together (stretch up, squash down). This
  happens once, not every time you scroll past the point.
- **Exit:** the pin releases, the crowd scrolls up naturally, the final count stays in the flow.
- **Pointer:** all blobs look at the pointer (cheap version: one shared `--look-x`/`--look-y` on the crowd that moves every `face` group).
- **Reduced motion:** no pin, no scrub. The same SVG crowd standing still **in sync** (final state), on the Lagoon field,
  with all four lines of copy stacked as normal text and the count. Same content, no movement.

## Build notes
- Files: `components/home/IntoPhase.tsx`, `components/home/intoPhase.crowd.tsx` (the SVG crowd), `components/home/intoPhase.timeline.ts`.
- The crowd is one inline `<svg>` that references the blob sprite (XYB-025). Each blob is a `<use>` with CSS
  custom properties `--blob`, `--phase` and `--i`; the bob is a CSS transform driven by one `--beat` value and
  one `--sync` value on the crowd container (XYB-026). One GSAP ticker writes those two values; nothing
  per-blob runs in JavaScript.
- `sync` lives in a ref / CSS variable, never in React state (no re-render per frame).
- Member data: `getMembers()` from the content layer (XYB-005), only `{handle, species, colour}` sent to the client.
- Pin with ScrollTrigger + Lenis (XYB-021). Call `ScrollTrigger.refresh()` after fonts load.
- Crowd positions are seeded from the handles, so the server HTML and the animated version are the same layout.
- Provide `?sync=0.5` query param in development to freeze the scene for screenshots.

## Acceptance criteria
- [ ] The number shown equals the number of member files in `content/members/` (checked by a unit test).
- [ ] At the start of the pin blobs are visibly out of phase; at the end they bob in exact unison.
- [ ] The two hero blobs appear in the front row with the same look as in the hero.
- [ ] Copy beats never overlap each other or the crowd; each is two lines max at every width.
- [ ] 60fps on desktop (Chrome performance panel, no frames > 20ms during scrub) and ≥ 50fps on a mid-range Android.
- [ ] No per-blob JavaScript per frame: only the crowd's `--beat` and `--sync` change (checked in the Performance panel).
- [ ] Phone (390): max 24 blobs, pin ≤ 160vh, no horizontal scroll.
- [ ] Low-power devices: the crowd still syncs with scroll, without look-at and jump.
- [ ] Reduced motion: no pin, the in-sync still frame and all copy are shown.
- [ ] Scrolling back up reverses the scene smoothly; no blobs left half-landed.
- [ ] Screen reader reads the copy beats and the count in order; the crowd SVG is `aria-hidden="true"`.
- [ ] Bilingual: every visible string comes from `messages/*.json` or localized content (XYB-006); the section works in English and French, and every headline still fits two lines in French at 1440, 768 and 390.
- [ ] Follows the house rules in `docs/creative-direction.md` §4.

## Out of scope
- Clicking a blob to open a member (that's XYB-035 and XYB-050). Sound on sync (XYB-028 may add it later).

## References
- Metronomes on a shared table falling into sync (the physics behind the idea).
- Award-site pinned scenes where scroll drives one simple parameter, not twenty.
