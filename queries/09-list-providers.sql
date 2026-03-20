-- =================================================================
-- AK Health Check: Mailbox provider mix
-- Short name: hc_list_providers
-- Category: List health
-- Description: Subscribed users by mailbox provider. Understanding
--   your provider mix matters for deliverability — Gmail, Microsoft,
--   and Verizon Media Group each have different filtering rules and
--   reputation systems.
-- Reference: core_user + summary_user.mailbox_provider
-- Date bound: None (current state)
-- Returns: Grouped (4 rows). PieChart.
-- =================================================================

SELECT
    CASE su.mailbox_provider
        WHEN 'gmail' THEN 'Gmail'
        WHEN 'ms'    THEN 'Microsoft'
        WHEN 'vmg'   THEN 'Verizon Media'
        WHEN 'other' THEN 'Other'
        ELSE COALESCE(su.mailbox_provider, 'Unknown')
    END AS provider,
    COUNT(*) AS user_count
FROM core_user u
JOIN summary_user su ON su.user_id = u.id
WHERE u.subscription_status = 'subscribed'
GROUP BY su.mailbox_provider
ORDER BY user_count DESC
