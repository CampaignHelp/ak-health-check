# AK Health Check

![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)
![Queries: 19](https://img.shields.io/badge/queries-19-blue.svg)
![Platform: ActionKit](https://img.shields.io/badge/platform-ActionKit-orange.svg)
![SELECT only](https://img.shields.io/badge/SQL-SELECT%20only-brightgreen.svg)
![Built with Claude](https://img.shields.io/badge/built%20with-Claude-blueviolet.svg)
![Reviewed by ChatGPT](https://img.shields.io/badge/reviewed%20by-ChatGPT-74aa9c.svg)

A dashboard and set of SQL queries for auditing ActionKit instances. Built for the ActionKit community — free, open source, and designed to run safely on production instances.

## What this is

A single ActionKit Dashboard report backed by individual query reports. Install the queries, install the dashboard, and see your instance health at a glance from the Reports tab.

**Categories:**
- **Staff security** — ghost accounts, missing 2FA, superuser sprawl
- **List health** — subscription status, blocked users, spam trap risk, inactivity buckets, provider mix
- **Fundraising** — expiring cards, failed recurring, cancellation reasons
- **Mailing hygiene** — stale drafts, missing wrappers, stopped/died mailings
- **Data quality** — missing zip codes, missing state, completeness summary

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
2. Set **Name** to "Health Check" and **Short name** to `health_check`
3. Paste the contents of `dashboard.html` into the HTML field
4. Optionally add the `homepage` category to show it on your Home tab
5. Save

### Step 3: Run it

Navigate to your new Health Check dashboard from the Reports tab. Review the results and decide what needs attention.

## Queries

| # | File | Short name | Category | What it checks |
|---|------|-----------|----------|----------------|
| 01 | `01-staff-ghost.sql` | `hc_staff-ghost` | Staff security | Active staff, no login 90+ days |
| 02 | `02-staff-superusers.sql` | `hc_staff-superusers` | Staff security | All active superusers |
| 03 | `03-staff-no2fa.sql` | `hc_staff-no2fa` | Staff security | Staff without 2FA |
| 04 | `04-staff-summary.sql` | `hc_staff-summary` | Staff security | Active/super/ghost/deactivated counts |
| 05 | `05-list-status.sql` | `hc_list-status` | List health | Subscription status breakdown |
| 06 | `06-list-blocked.sql` | `hc_list-blocked` | List health | Blocked user count |
| 07 | `07-list-spamrisk.sql` | `hc_list-spamrisk` | List health | Zero engagement 24+ months |
| 08 | `08-list-inactive.sql` | `hc_list-inactive` | List health | Engagement buckets (12/24+ mo) |
| 09 | `09-list-providers.sql` | `hc_list-providers` | List health | Mailbox provider mix |
| 10 | `10-fund-expiring.sql` | `hc_fund-expiring` | Fundraising | Cards expiring next month |
| 11 | `11-fund-failed.sql` | `hc_fund-failed` | Fundraising | Failed recurring, no active backup |
| 12 | `12-fund-canceled.sql` | `hc_fund-canceled` | Fundraising | Cancellations by reason (90 days) |
| 13 | `13-fund-summary.sql` | `hc_fund-summary` | Fundraising | Active profiles, revenue, churn |
| 14 | `14-mail-drafts.sql` | `hc_mail-drafts` | Mailing hygiene | Drafts older than 90 days |
| 15 | `15-mail-nowrap.sql` | `hc_mail-nowrap` | Mailing hygiene | Sent without wrapper (12 months) |
| 16 | `16-mail-failed.sql` | `hc_mail-failed` | Mailing hygiene | Stopped/died mailings (90 days) |
| 17 | `17-data-nozip.sql` | `hc_data-nozip` | Data quality | Subscribed users missing zip |
| 18 | `18-data-nostate.sql` | `hc_data-nostate` | Data quality | Subscribed users missing state |
| 19 | `19-data-summary.sql` | `hc_data-summary` | Data quality | Missing field counts vs total |

## Files

```
queries/              19 individual SQL query reports (see table above)
dashboard.html        Dashboard HTML template (references queries via {% report %} tags)
install.py            Automated installer via AK REST API
```

## Background

Built by [CampaignHelp](https://campaign.help) from patterns observed across multiple ActionKit instances. Each check addresses a real problem that accumulates silently over time — the kind of thing nobody audits until something breaks.

## See also

**[Stratosphere](https://launchstratosphere.com/)** by Third Bear Solutions — if AK Health Check tells you what's broken, Stratosphere helps you understand what's working. Ongoing dashboards, query builders, and member insights for your ActionKit instance.

## AI disclaimer

This project was built with [Claude](https://claude.ai) and reviewed with [ChatGPT](https://chatgpt.com). All SQL queries were developed using ActionKit's official help documentation as the primary reference. Every query was tested and verified on production-scale data by a human before inclusion.

## License

MIT
