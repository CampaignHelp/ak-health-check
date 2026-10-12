# ClientCon 2026 show-and-tell presentation design

**Date:** 2026-03-27
**Event:** ClientCon 2026, April 14-15, Indian Pueblo Cultural Center, Albuquerque
**Format:** 5-minute show-and-tell
**Topic:** AK Health Check — 19 SQL query reports as a native AK dashboard

## Goal

Lead with generosity — give away something genuinely useful, be the expert who shares freely. Let the expertise position Jordan naturally without selling.

## Presentation structure

### Slide 1 — The problem (~45 sec)

**Headline:** "Your AK instance is accumulating problems right now"

**Talking points:**
- Staff turnover means ghost accounts with superuser access still active
- Years of mailings means stale drafts and sends without wrappers
- Long subscriber lists mean spam trap risk from people who haven't engaged in 2+ years
- Nobody audits this stuff proactively — it just piles up

**Visual treatment:** Dark background (CH neutral 900), headline in Fraunces, 2-3 short bullet points in Inter. Clean, not busy. CH branding throughout.

### Slide 2 — The solution (~45 sec)

**Headline:** "19 queries. One dashboard. Zero external tools."

**Talking points:**
- Five categories: staff security, list health & deliverability, fundraising, mailing hygiene, data quality
- Runs inside AK's native report and dashboard system — nothing external to install or maintain
- One Python install script creates everything on your instance
- Free and open source

**Visual treatment:** Same dark background. Five category names listed cleanly. Transition line at bottom: "Let me show you."

### Live demo on Robotic Dogs (~3 min)

Switch from slides to the AK admin on roboticdogs.actionkit.com. Walk through the Health Check dashboard.

**Highlights to show (pick 2-3, don't try to cover all 19):**
1. **Ghost staff** (`hc_staff_ghost`) — immediately relatable, security angle
2. **Spam trap risk** (`hc_list_spamrisk`) — big number, deliverability impact
3. **Expiring cards** (`hc_fund_expiring`) — money on the table
4. **Provider mix pie chart** (`hc_list_providers`) — visual, interesting data
5. **Cancellation reasons bar chart** (`hc_fund_canceled`) — visual, actionable

**Demo flow:**
- Start at the top of the dashboard, scroll through to show the full layout
- Pause on 2-3 sections with commentary
- Don't read the numbers — tell the story ("See these 4 staff accounts? They haven't logged in in 90 days but still have superuser access.")

### Close (~30 sec)

- "The install script and all 19 queries are on GitHub — I'll drop the link in the chat"
- No pitch, no CTA. Just: here's a free tool, go use it.

## Deliverables

### 1. Two-slide HTML presentation

- Self-contained single HTML file with arrow-key navigation
- CampaignHelp branding: Fraunces headings, Inter body, CH blue (#19AAE2) and orange (#F77F0D) accents, dark background (neutral 900 #1a1a1a)
- Responsive but optimized for projector/external display (16:9)
- Minimal animations — fade transitions between slides at most

### 2. Demo prep checklist

Documented in this spec. The 2-3 dashboard sections to highlight and talking points for each are listed in the "Live demo" section above.

### 3. Backup plan

- Hidden slides (slide 3+) in the same HTML file containing screenshots of the dashboard
- Accessible via arrow key if the live demo fails (AK down, network issues, projector problems)
- Screenshots should be taken from the Robotic Dogs instance after confirming it's populated with the Health Check dashboard

## Technical notes

- Slides HTML file location: `business/campaignhelp/ak-health-check/presentation/`
- The Health Check is already installed on Robotic Dogs (per CLAUDE.md status)
- Robotic Dogs has minimal data — demo numbers will be small, which is fine for showing the format. If MomsRising data would be more compelling, that's an option but requires Nate's awareness.
- AK team review of queries should happen before ClientCon (separate Drift task, due Apr 7)

## Out of scope

- Printed handouts (business cards already have AK Help QR code)
- Post-presentation email follow-up template (separate task)
- README or install guide updates (already done)
