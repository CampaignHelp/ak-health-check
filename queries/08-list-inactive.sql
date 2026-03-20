-- =================================================================
-- AK Health Check: Inactivity buckets
-- Short name: hc_list_inactive
-- Category: List health
-- Description: Subscribed users grouped by last engagement window.
--   Uses most recent of last_open, last_click, last_mailing_action
--   from summary_user. Shows how much of your list is actively
--   engaged vs drifting toward inactivity.
-- Reference: core_user + summary_user
-- Date bound: None (current state, buckets at 12 and 24 months)
-- Returns: Grouped (3 rows). BarChart.
-- =================================================================

SELECT
    CASE
        WHEN GREATEST(
            COALESCE(su.last_open, '2000-01-01'),
            COALESCE(su.last_click, '2000-01-01'),
            COALESCE(su.last_mailing_action, '2000-01-01')
        ) >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
        THEN 'Active (under 12 mo)'
        WHEN GREATEST(
            COALESCE(su.last_open, '2000-01-01'),
            COALESCE(su.last_click, '2000-01-01'),
            COALESCE(su.last_mailing_action, '2000-01-01')
        ) >= DATE_SUB(NOW(), INTERVAL 24 MONTH)
        THEN 'Inactive (12-24 mo)'
        ELSE 'Disengaged (24+ mo)'
    END AS engagement_bucket,
    COUNT(*) AS user_count
FROM core_user u
JOIN summary_user su ON su.user_id = u.id
WHERE u.subscription_status = 'subscribed'
GROUP BY engagement_bucket
ORDER BY FIELD(engagement_bucket,
    'Active (under 12 mo)',
    'Inactive (12-24 mo)',
    'Disengaged (24+ mo)')
