# ClientCon presentation implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a two-slide HTML presentation for the AK Health Check ClientCon show-and-tell, with backup screenshot slides.

**Architecture:** Single self-contained HTML file with CSS slide system (arrow-key navigation, 16:9 aspect ratio, fade transitions). CampaignHelp branding via Google Fonts (Fraunces + Inter). Backup slides use placeholder images initially, replaced with real screenshots in a later task.

**Tech stack:** HTML, CSS, vanilla JavaScript

**Spec:** `docs/superpowers/specs/2026-03-27-clientcon-presentation-design.md`

**Branding reference:** `~/ClaudeCode/business/campaignhelp/branding/BRAND-REFERENCE.md`

---

### Task 1: Build the slide presentation HTML file

**Files:**
- Create: `presentation/index.html`

- [ ] **Step 1: Create the presentation directory**

```bash
mkdir -p presentation
```

- [ ] **Step 2: Write the HTML presentation file**

Create `presentation/index.html` — a single self-contained HTML file with:

**CSS slide engine:**
- Full-viewport slides using `100vw` x `100vh` with 16:9 content area centered
- Dark background: `#1a1a1a` (CH neutral 900)
- Arrow-key and click navigation (left/right arrows advance slides)
- Fade transition between slides (CSS opacity, ~300ms)
- Slide counter in bottom-right corner (e.g., "1 / 2")
- No external dependencies except Google Fonts

**Google Fonts import:**
- Fraunces (variable weight) for headings
- Inter (400, 500, 600) for body text

**Slide 1 — The problem:**
- Headline: "Your AK instance is accumulating problems right now" in Fraunces, white, large
- Three bullet points in Inter, light gray (#d1d5db / neutral 300):
  - "Staff turnover leaves ghost accounts with superuser access"
  - "Years of mailings pile up stale drafts and unwrapped sends"
  - "Inactive subscribers become spam trap risks"
- Subtle CH blue (#19AAE2) accent line or element at top
- CH logo in bottom-left corner (use text "CampaignHelp" in Inter 600 + CH blue if logo embedding is complex; otherwise embed `logos/logo-icon-512x512.png` as base64)

**Slide 2 — The solution:**
- Headline: "19 queries. One dashboard. Zero external tools." in Fraunces, white, large
- Five category pills/badges in a row: "Staff Security" / "List Health" / "Fundraising" / "Mailing Hygiene" / "Data Quality"
  - Style: rounded pill shape, CH blue (#19AAE2) background, white text, Inter 500
- Below categories: "Runs inside AK's native reporting. One install script. Free and open source." in Inter, light gray
- Bottom of slide: "Let me show you." in CH orange (#F77F0D), Inter 600
- Same CH branding element as slide 1

**Backup slides (slides 3-5) — screenshot placeholders:**
- Slide 3: Placeholder text "Dashboard overview screenshot" centered, gray border box
- Slide 4: Placeholder text "Staff security section screenshot" centered, gray border box
- Slide 5: Placeholder text "Charts section screenshot" centered, gray border box
- These will be replaced with real screenshots in Task 3
- Slide counter should show "backup 1/3" etc. for slides 3+ to distinguish from the main deck

- [ ] **Step 3: Open in browser and verify**

```bash
open presentation/index.html
```

Verify:
- Slide 1 renders with dark background, Fraunces headline, Inter bullets
- Slide 2 renders with category pills and orange "Let me show you"
- Arrow keys navigate between slides
- Fade transitions work
- Slide counter updates
- Backup slides 3-5 are accessible via arrow keys
- Looks good at a 16:9 aspect ratio (resize browser window to approximate projector)

- [ ] **Step 4: Commit**

```bash
git add presentation/index.html
git commit -m "feat: add ClientCon show-and-tell presentation slides"
```

### Task 2: Visual review and polish

**Files:**
- Modify: `presentation/index.html`

- [ ] **Step 1: Show the presentation in the visual companion browser**

Push the presentation to the visual companion server for Jordan to review. Load `presentation/index.html` content into the brainstorm companion at the running URL.

- [ ] **Step 2: Iterate on feedback**

Adjust typography sizes, spacing, colors, and layout based on Jordan's feedback. Key things to watch for:
- Headline font size — needs to be readable from the back of a conference room
- Bullet point spacing — not too cramped, not too spread
- Category pills — readable, not too small
- Overall balance — does each slide feel complete without being busy?

- [ ] **Step 3: Commit polish changes**

```bash
git add presentation/index.html
git commit -m "style: polish presentation typography and layout"
```

### Task 3: Capture backup screenshots

**Files:**
- Modify: `presentation/index.html` (replace placeholder slides with real screenshots)

**Prerequisite:** Health Check dashboard must be rendering on Robotic Dogs. Per CLAUDE.md status, it's already installed. Verify before capturing.

- [ ] **Step 1: Verify dashboard is live on Robotic Dogs**

Log into `roboticdogs.actionkit.com` and navigate to the Health Check dashboard. Confirm it renders with data.

- [ ] **Step 2: Capture 3 screenshots**

Using Playwright or manual screenshot:
1. Full dashboard overview (scrolled to show multiple sections)
2. Staff security section (ghost staff table + summary stats)
3. A chart section (provider mix pie chart or cancellation bar chart)

Save to `presentation/screenshots/` as PNG files.

- [ ] **Step 3: Embed screenshots in backup slides**

Replace the placeholder text in slides 3-5 with the actual screenshot images. Embed as base64 data URIs to keep the file self-contained. Size images to fill the 16:9 slide area with appropriate padding.

- [ ] **Step 4: Verify backup slides**

Open presentation, arrow-key to slides 3-5, confirm screenshots display correctly and are readable at presentation scale.

- [ ] **Step 5: Commit**

```bash
git add presentation/
git commit -m "feat: add backup dashboard screenshots to presentation"
```
