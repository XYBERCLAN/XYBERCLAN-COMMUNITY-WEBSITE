---
id: XYB-030
title: Navigation and footer
phase: 3-home
type: dev
size: M
depends_on: [XYB-014, XYB-010, XYB-017, XYB-006]
skills: [react, css, gsap, accessibility]
good_first_issue: false
---

# XYB-030 — Navigation and footer

## Why this exists (the strategy)
**Claim:** Xyberclan is easy to enter and easy to find your way around. You always know where you are, and
every page ends with the clan's name, said proudly.

**Proof:** a plain bar that never hides the content, with the same five places on every page, and a footer
that is a designed close (the wordmark at full width with blobs peeking over it), not a sitemap dump.

The nav is the frame of the whole site. If it looks like every other template (floating glass pill, ten
links), the rest of the site cannot recover. The footer is the last thing every visitor sees on every
page: it is our signature.

## What the visitor should feel and do
- **Feel:** "This is calm and clear. I'm in good hands."
- **Do:** reach any main page in one click, and find **Join the clan** at any moment.

## Scope
- `SiteNav`: desktop bar, hide-on-scroll-down / show-on-scroll-up, active state, skip link.
- `MobileMenu`: full-screen menu with blobs, opened by a menu button.
- `SiteFooter`: full-width wordmark, peeking blobs, link groups, socials, credits line, code of conduct link.
- Used on every page via the root layout.
- Footer holds a **Pause motion** switch (XYB-080, WCAG 2.2.2) that puts the whole site in the reduced-motion state and is remembered (XYB-020 reads it).
- Leave a slot for the optional **Sound** toggle (XYB-028) and the language link (`LanguageLink` from XYB-006: one link naming the other language, "Français" / "English", never an "EN · FR" pair).
- Footer links also reach **Built by the clan** (`/built`), **Journal** (`/journal`, hidden until 3 real stories exist), **FAQ** and **Code of conduct**.

## Content
- **Wordmark / logo:** from XYB-010 (the X + blob mark, then "Xyberclan").
- **Nav links (in this order):** The clan → `/clan` · What's inside → `/inside` · Our mindset → `/mindset` ·
  Events → `/events`. **Action:** Join the clan → `/join` (primary pill button).
- **Footer groups** (draft — confirm in XYB-018):
  - *The clan:* Meet the clan, Built by the clan, Journal.
  - *Show up:* Events, What's inside, Join the clan.
  - *The rules:* Our mindset, Code of conduct, Privacy.
  - *Find us:* real social links only (Discord, GitHub, Instagram, LinkedIn, X — whichever the clan
    actually uses, from XYB-001). Each external link gets the ↗ arrow.
- **Closing line** above the wordmark (draft): "Different minds. One frequency." — or a short sign-off from XYB-018.
- **Credits line:** "Built by the clan." + link to the GitHub repo + photo credits from XYB-017 + © year.
- Content owner: founders (XYB-001) for socials; copy from XYB-018.

## Design spec

**Nav — desktop (1440)**
- Height 80px. Paper ground (`--color-ground`), no border, no shadow, no blur.
- Left: logo mark + wordmark, at the outer margin. Centre-right: four text links at text size (17px), full ink.
  Right: **Join the clan** pill (ink fill, paper text), at the outer margin.
- Active page: the link gets a small Lagoon blob dot under it (6px, the one allowed decoration because it is
  a tiny blob, not a line). No underline bars.
- When it reappears after scrolling, it keeps the paper ground so text below never shows through.
- On full-field colour sections (Lagoon/Deep), the bar takes that field colour so it never sits as a
  paper strip on top of a colour field. Text and button invert if needed for contrast (≥ 4.5:1).

**Nav — tablet (768) and phone (390)**
- Logo left, **Join the clan** pill (small size) + menu button right. Height 64px.
- Menu button: the word "Menu" (not a hamburger icon alone). Accessible name "Open menu" / "Close menu".

**Mobile menu (full screen)**
- Full Lagoon field. Links stacked at display size (step 4 of the scale, about 44px), left aligned, ink.
- Bottom third: 3–5 small blobs sitting on the bottom edge (inline SVG from the blob renderer, XYB-025), bobbing on the clan beat.
- Socials as plain text links at the bottom. Close button top right, same place as the menu button.

**Footer — desktop**
- Ink field (`--color-ink`) with paper text: the dark band that closes every page. Top padding 160px.
- Row 1: closing line at statement size (≤ 36px), left. Join the clan pill, right.
- Row 2: four link groups in four columns of the 12-column grid. Group titles in sentence case, same size as links, bold. No uppercase labels.
- Row 3: **the wordmark at full width**, edge to edge inside the outer margins (it fills the 12 columns,
  about 18vw tall letters). 3–4 blobs peek over the top edge of the letters (only the top half of each
  blob visible, as if hiding behind the word).
- Row 4: credits line in small text (14px), paper at 70% tone (secondary note — allowed grey).

**Footer — phone**
- Link groups become two columns, then the wordmark full width (it scales with vw, never wraps), blobs scaled down to 2.

## Motion spec
- **Nav hide/show:** translateY(-100%) on scroll down after 120px, back to 0 on any scroll up. 280ms, ease
  `--ease-out` from XYB-020. Never hides while the mobile menu or any focus is inside it.
- **Mobile menu open:** the Lagoon field grows from the menu button as a circle clip (clip-path circle,
  420ms), links rise 24px + fade in with 60ms stagger, blobs drop in last with a squash. Close plays it backwards at 1.5× speed.
- **Footer:** as the footer enters the viewport, the peeking blobs rise from behind the wordmark (translateY
  40% → 0) one by one, then idle on the clan beat (XYB-020). If the pointer is over the footer, their eyes follow it (XYB-026; skipped on touch and under reduced motion).
- **Hover:** links nudge 2px and get the blob dot; the pill button follows XYB-027.
- **Reduced motion:** nav does not hide (stays fixed), menu opens with a 150ms fade only, footer blobs are still.

## Build notes
- Files: `components/site/SiteNav.tsx`, `components/site/MobileMenu.tsx`, `components/site/SiteFooter.tsx`,
  mounted in `app/layout.tsx`. Links data in `content/site/navigation.ts` (one source for nav, menu and footer).
- Scroll direction: read from the Lenis instance (XYB-021), not a separate scroll listener.
- Field-colour awareness: each section sets `data-field="paper|lagoon|deep|ink"`; an IntersectionObserver at
  the nav's height updates `data-nav-field` on the nav.
- Mobile menu: a real dialog (`<dialog>` or Radix Dialog), focus trapped, Esc closes, body scroll locked
  through Lenis `stop()`/`start()`, focus returns to the menu button.
- Wordmark in the footer is an inline SVG from XYB-010, with `aria-hidden` and a visually hidden "Xyberclan" text.
- Footer blobs: `<Blob>` inline SVG (XYB-025), decorative, so `aria-hidden="true"`; animations paused until the footer is in view.

## Acceptance criteria
- [ ] Nav shows the same 4 links + Join the clan on every page; the current page is marked with `aria-current="page"`.
- [ ] A "Skip to content" link is the first focusable element and works.
- [ ] Nav hides on scroll down and returns on scroll up; it never covers focused content.
- [ ] On a Lagoon or Deep section, the nav takes the field colour and keeps ≥ 4.5:1 contrast.
- [ ] Mobile menu: opens and closes with keyboard, traps focus, Esc closes, focus returns to the button.
- [ ] No backdrop blur, no shadow, no border line, no floating pill navbar.
- [ ] Footer wordmark spans the full content width at 1440, 768 and 390 and never wraps or overflows.
- [ ] Footer social links are real (from XYB-001) and marked with ↗; internal links have no arrow.
- [ ] Footer includes credits for every found photo (XYB-017) and a link to the code of conduct.
- [ ] Reduced motion: nav static, menu fades, footer blobs still.
- [ ] The footer **Pause motion** switch stops every animation on the site and the choice survives a reload.
- [ ] Lighthouse accessibility 100 on a page with only nav + footer.
- [ ] Bilingual: every visible string comes from `messages/*.json` or localized content (XYB-006); the section works in English and French, and every headline still fits two lines in French at 1440, 768 and 390.
- [ ] Follows the house rules in `docs/creative-direction.md` §4.

## Out of scope
- Search in the nav. Building the language link itself (XYB-006 provides it; this ticket places it in the nav, mobile menu and footer). Page transitions (XYB-024).

## References
- Discord brand site: a plain bar that changes with the field colour.
- Many studio sites: the name returning at full width as the footer's close.
- Duolingo: characters peeking from behind edges.
