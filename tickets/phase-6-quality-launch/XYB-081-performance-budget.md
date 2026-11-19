---
id: XYB-081
title: Performance budget
phase: 6-quality-launch
type: qa
size: M
depends_on: [XYB-003]   # set the budget in CI from Sprint 3; the full page pass runs after M3
skills: [web-performance, nextjs, lighthouse, svg]
good_first_issue: false
---

# XYB-081 — Performance budget

## Why this exists (the strategy)
**Claim:** a premium site is a fast site, on the phones our members really use.
**Proof:** measured numbers on a throttled mid-range Android over 4G, enforced in CI so they cannot quietly get worse.

Many clan members and future members browse on mid-range Android phones on mobile data. If the hero
blobs take six seconds to appear, the site has failed the people it was built for, however good it looks
on a designer's laptop. Award juries also test on phones. Speed is part of the craft.

## What the visitor should feel and do
- Feel: the site is instant and smooth, even on a modest phone.
- Do: scroll without stutter, tap without delay.

## Scope
- Set the budget, measure every key page against it, fix what fails, and lock it in CI.

## Content
None.

## Design spec
The budget (measured on a mid-range Android profile: Moto G Power class, 4× CPU slowdown, "Fast 4G"
1.6 Mbps / 150 ms RTT, the Lighthouse mobile default):

| Metric | Budget |
| --- | --- |
| LCP | ≤ 2.0 s |
| CLS | ≤ 0.05 |
| INP | ≤ 200 ms |
| TBT (lab) | ≤ 200 ms |
| Initial JS (gzip) per route | ≤ 170 KB |
| Fonts | ≤ 2 families, ≤ 4 files, ≤ 120 KB total |
| Each species SVG | ≤ 6 KB gzip (SVGO, no embedded images, no hidden layers) |
| Whole blob sprite | ≤ 40 KB gzip, loaded once per page |
| Animated blobs on screen | ≤ 60 on desktop, ≤ 30 on phone; the rest are static |
| Largest photo | ≤ 120 KB AVIF |
| Lighthouse mobile | Performance ≥ 90 · Accessibility 100 · Best Practices ≥ 95 · SEO 100 |

**Failure state the visitor must never see:** a blank space where the hero blobs will be. The blobs are inline
SVG in the first HTML, so they appear with the headline. The LCP element is the hero headline.

## Motion spec
- Scroll scenes keep 60 fps on the test phone (check the Performance panel; no long frames > 50 ms while scrolling).
- Idle animations pause when the tab is hidden or the scene is off-screen.
- On low-end devices (`navigator.hardwareConcurrency <= 4` or `deviceMemory <= 4`), blobs keep only the idle
  bob, and the animated-blob cap halves (XYB-025/XYB-026 decide the switch; this ticket verifies it).
- Blob animations are paused offscreen (IntersectionObserver) and when the tab is hidden.

## Build notes
- **Blobs:** server-rendered inline SVG for the few large blobs on a page; one `<symbol>` sprite + `<use>` for
  crowds. Animate only `transform` and `opacity` (via CSS variables), never SVG path data per frame.
- **GSAP:** import only the plugins used, per route. Lenis is small; keep it.
- **Fonts:** `next/font/local`, `display: swap`, subset to Latin + Latin Extended, preload only the display
  weight used in the hero. Use `size-adjust`/fallback metrics so swapping causes no CLS.
- **Images:** `next/image` with AVIF + WebP, real `sizes`, `priority` only on the first large photo of a page (the hero has no image to prioritise). Every image has width and height.
- **Video (if any):** muted, `preload="none"`, poster image, lazy-start when in view.
- **Third parties:** analytics proxied and deferred (XYB-075); Turnstile loaded only on `/join`.
- **Server:** static generation for all content pages; ISR where content changes; no client-side data fetching for first paint.
- **CI:** Lighthouse CI (`@lhci/cli`) on the Vercel preview URL for home, `/clan`, `/join`, an event page and
  `/mindset`, with assertions matching the table. `size-limit` or `@next/bundle-analyzer` check for the JS budget.
- **Field data:** enable Vercel Speed Insights (or the `web-vitals` library reporting to analytics) to watch real-user LCP/INP after launch.
- Write findings and before/after numbers in `docs/audits/perf-<date>.md`.

## Acceptance criteria
- [ ] Lighthouse CI runs on every PR against the preview URL and fails when any assertion in the budget table fails.
- [ ] Home page on the mobile profile: LCP ≤ 2.0 s, CLS ≤ 0.05, TBT ≤ 200 ms (median of 3 runs, reported in PR).
- [ ] INP ≤ 200 ms on the Blob Maker interactions (measured with the Web Vitals extension on a real mid-range Android).
- [ ] Initial JS per route ≤ 170 KB gzip (size-limit report).
- [ ] Each species SVG ≤ 6 KB gzip; the blob sprite ≤ 40 KB gzip (size report in the PR).
- [ ] Fonts ≤ 120 KB total; no layout shift when they load.
- [ ] No more than 60 blobs (30 on phone) animate at once anywhere on the site, and offscreen blobs are paused (checked on `/clan` with 500 sample members).
- [ ] Scroll scenes hold 60 fps on the test phone (Performance panel recording attached).
- [ ] Real-user monitoring is on and visible to the core team.
- [ ] `docs/audits/perf-<date>.md` lists before/after numbers for each page.
- [ ] Follows the house rules in `docs/creative-direction.md` §4.

## Out of scope
- Redrawing the blob art (send oversized SVGs back to XYB-016 as a new ticket).
- CDN or hosting changes beyond Vercel defaults.

## References
- web.dev Core Web Vitals; Lighthouse CI docs; SVGO for SVG size.
- Trait to learn: character-led award sites whose first frame is already complete, then comes alive without a jump.
