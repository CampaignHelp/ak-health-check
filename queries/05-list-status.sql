-- =================================================================
-- AK Health Check: Subscription status breakdown
-- Short name: hc_list_status
-- Category: List health
-- Description: Count of users by subscription status. Shows the
--   composition of your user table: subscribed, unsubscribed,
--   bounced, blocked, and never-subscribed.
-- Reference: core_user.subscription_status
-- Date bound: None (current state)
-- Returns: Grouped (5 rows). PieChart.
-- =================================================================

SELECT
    CASE u.subscription_status
        WHEN 'subscribed'   THEN 'Subscribed'
        WHEN 'unsubscribed' THEN 'Unsubscribed'
        WHEN 'bounced'      THEN 'Bounced'
        WHEN 'blocked'      THEN 'Blocked'
        WHEN 'never'        THEN 'Never subscribed'
        ELSE u.subscription_status
    END AS status,
    COUNT(*) AS user_count
FROM core_user u
GROUP BY u.subscription_status
ORDER BY user_count DESC
