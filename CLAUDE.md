# AK Health Check

## What this is

A free, open-source ActionKit dashboard + query reports that audit an AK instance for common problems. Show-and-tell project for ClientCon 2026 (April 14-15).

## Repo

- **GitHub:** `CampaignHelp/ak-health-check` (private)
- **Local:** `~/ClaudeCode/business/campaignhelp/ak-health-check/`

## Architecture

- **Individual query reports** (`queries/`) — each is a standalone custom SQL report with a specific short name
- **Dashboard report** (`dashboard.html`) — an AK Dashboard report that pulls all queries together via `{% report "short-name" %}` tags, with HTML layout and Google Charts
- **Install guide** — step-by-step for creating the reports in any AK instance

## AK Dashboard feature

Dashboards are a report type in AK (Reports > Add a Dashboard). They use HTML + Django template tags to display multiple query report results on one page. Key syntax:
- `{% report "query-short-name" %}` — embed a query's results
- `{% report "query-short-name" with param as query_param %}` — pass parameters
- `{{ reports.query-short-name }}` — alternative syntax for use inside Google Chart divs
- Google Charts: wrap in `<div class="google-chart ColumnChart">{{ reports.query_name }}</div>`
- Supported chart types: AreaChart, BarChart, ColumnChart, GeoChart, LineChart, PieChart, Table

## Test instances

- **Robotic Dogs** (`roboticdogs.actionkit.com`) — AK test instance, jordan@campaign.help. Minimal data — use for install testing, not query validation.
- **MomsRising** (`act.momsrising.org`) — real client instance with production data volumes. Use for query performance testing and validating meaningful results. Requires Nate's awareness.

## Query design rules

1. **SELECT only** — never modify data
2. **Use `summary_user`** for engagement checks — never raw `core_usermailing`/`core_open`/`core_click` joins
3. **Date-bound all scans** — 90 days, 12 months, or 24 months max
4. **LIMIT detail queries to 50 rows** — counts return a single number
5. **Run EXPLAIN** on every query against MomsRising before including
6. **Cite the AK doc** each query is based on (table reference, doc page)
7. **Test on real data** — don't ship a query that hasn't been run on a production-scale instance

## Why these rules matter

Karin (ActionKit ED) has expressed concern about AI-generated SQL queries being run on AK instances without proper testing. Some have nearly caused outages. Every query in this project must be hand-verified for performance and correctness. Frame this as expertise-driven, not AI-generated.

## Query naming convention

Short names: `hc-{category}-{check}` (e.g., `hc-staff-ghost`, `hc-list-blocked`, `hc-mail-drafts`)

## Health check categories

### Staff security
- Ghost staff (active, no login in 90+ days)
- Staff without 2FA
- Superuser count

### List health & deliverability
- Subscription status breakdown (subscribed/bounced/blocked/unsubscribed/never)
- Blocked users (paying for dead weight)
- Spam trap risk (subscribed, zero engagement 24+ months)
- Inactive subscribers (no engagement 12+ months)

### Fundraising
- Recurring profiles with recent failed payments
- Cards expiring next month
- Cancelled recurring profiles (last 90 days)

### Mailing hygiene
- Draft mailings older than 90 days
- Mailings sent without a wrapper
- Killed/died mailings (last 90 days)

### Data quality
- Subscribed users missing zip codes
- Orphaned custom user fields
- Partial refund report bug (reports using type='sale' without type IN ('sale','credit'))

## ClientCon plan

1. Build and test all queries
2. Build dashboard HTML
3. Install on Robotic Dogs for demo
4. Send queries to AK team for review before presenting
5. Present at show-and-tell: pull up dashboard, walk through findings
6. Share repo link afterward — anyone can install it

## Status

- [ ] Write SQL queries
- [ ] Test on MomsRising (EXPLAIN + results review)
- [ ] Build dashboard HTML
- [ ] Install on Robotic Dogs
- [ ] Send to AK team for review
- [ ] ClientCon show-and-tell prep
