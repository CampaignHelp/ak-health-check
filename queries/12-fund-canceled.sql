-- =================================================================
-- AK Health Check: Cancellations by reason
-- Short name: hc_fund_canceled
-- Category: Fundraising
-- Description: Recurring profile cancellations in the last 90 days,
--   grouped by reason. High "canceled_by_failure" or
--   "canceled_by_expired" counts signal payment infrastructure
--   problems. High "canceled_by_user" may signal donor dissatisfaction.
-- Reference: core_orderrecurring.status, core_orderrecurring.updated_at
-- Date bound: 90 days
-- Returns: Grouped (N rows). BarChart.
-- =================================================================

SELECT
    CASE orp.status
        WHEN 'canceled_by_admin'     THEN 'Admin'
        WHEN 'canceled_by_expired'   THEN 'Card expired'
        WHEN 'canceled_by_failure'   THEN 'Payment failure'
        WHEN 'canceled_by_processor' THEN 'Processor'
        WHEN 'canceled_by_user'      THEN 'User request'
        ELSE orp.status
    END AS cancel_reason,
    COUNT(*) AS profile_count
FROM core_orderrecurring orp
WHERE orp.status LIKE 'canceled_%'
  AND orp.updated_at >= DATE_SUB(NOW(), INTERVAL 90 DAY)
GROUP BY orp.status
ORDER BY profile_count DESC
