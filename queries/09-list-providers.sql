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
    CASE
        WHEN su.mailbox_provider = 'gmail' THEN 'Gmail'
        WHEN su.mailbox_provider = 'ms'    THEN 'Microsoft'
        WHEN su.mailbox_provider = 'vmg'   THEN 'Verizon Media'
        ELSE 'Other'
    END AS provider,
    COUNT(*) AS user_count
FROM summary_user su
JOIN core_user u ON u.id = su.user_id
WHERE u.subscription_status = 'subscribed'
GROUP BY 1
ORDER BY user_count DESC
