# AK Health Check

A dashboard and set of SQL queries for auditing ActionKit instances. Built for the ActionKit community — free, open source, and designed to run safely on production instances.

## What this is

A single ActionKit Dashboard report backed by individual query reports. Install the queries, install the dashboard, and see your instance health at a glance from the Reports tab.

**Categories:**
- **Staff security** — ghost accounts, missing 2FA, superuser sprawl
- **List health** — subscription status breakdown, blocked users inflating billing, spam trap risk
- **Deliverability** — inactive subscribers, engagement trends
- **Fundraising** — failed recurring payments, expiring cards
- **Mailing hygiene** — abandoned drafts, missing wrappers
- **Data quality** — missing zip codes, orphaned fields

## Performance and safety

Every query in this project was designed with shared infrastructure in mind:

- **SELECT only** — no queries modify data, ever
- **`summary_user` first** — engagement checks use the pre-aggregated summary table, not raw `core_usermailing`/`core_open`/`core_click` joins
- **Date-bounded** — no unbounded history scans. Queries scope to 90 days, 12 months, or 24 months as appropriate
- **LIMIT on detail queries** — counts return a single number; detail queries cap at 50 rows
- **Tested on real data** — every query was run and verified against a production-scale instance before inclusion
- **EXPLAIN verified** — execution plans checked to confirm no surprise full table scans

**Before installing:** Run each query individually in your instance first. Verify it completes quickly and returns reasonable results for your data volume.

## Installation

### Step 1: Create the query reports

For each `.sql` file in the `queries/` folder:

1. Go to **Reports** > **Add a Query Report**
2. Set the **Name** and **Short name** as noted in the file header
3. Paste the SQL
4. Save

### Step 2: Create the dashboard

1. Go to **Reports** > **Add a Dashboard**
2. Set **Name** to "Health Check" and **Short name** to `health-check`
3. Paste the contents of `dashboard.html` into the HTML field
4. Optionally add the `homepage` category to show it on your Home tab
5. Save

### Step 3: Run it

Navigate to your new Health Check dashboard from the Reports tab. Review the results and decide what needs attention.

## Files

```
queries/              Individual SQL query reports
  01-ghost-staff.sql
  02-staff-no-2fa.sql
  03-superuser-count.sql
  ...
dashboard.html        Dashboard HTML template (references queries via {% report %} tags)
install-guide.md      Detailed step-by-step with screenshots
CLAUDE.md             Project docs for development
```

## Background

Built by [CampaignHelp](https://campaign.help) from patterns observed across multiple ActionKit instances. Each check addresses a real problem that accumulates silently over time — the kind of thing nobody audits until something breaks.

## License

MIT
