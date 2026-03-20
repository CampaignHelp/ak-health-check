-- =================================================================
-- AK Health Check: Fundraising summary
-- Short name: hc_fund_summary
-- Category: Fundraising
-- Description: Single-row overview: active recurring profiles,
--   estimated monthly revenue (normalized across periods), profiles
--   expiring next month, and cancellations in last 90 days.
-- Reference: core_orderrecurring
-- Date bound: 90 days (for cancellation count), next month (for expiring)
-- Returns: Count (1 row)
-- =================================================================

SELECT
    FORMAT(SUM(orp.status = 'active'), 0) AS `Active profiles`,
    CONCAT('$', FORMAT(ROUND(SUM(
        CASE
            WHEN orp.status != 'active' THEN 0
            WHEN orp.period = 'months'   THEN orp.amount_converted
            WHEN orp.period = 'weeks'    THEN orp.amount_converted * 52 / 12
            WHEN orp.period = 'quarters' THEN orp.amount_converted / 3
            WHEN orp.period = 'years'    THEN orp.amount_converted / 12
            ELSE 0
        END
    ), 2), 2)) AS `Est. monthly revenue`,
    FORMAT(SUM(orp.status = 'active'
        AND orp.exp_date = CONCAT(
            LPAD(MONTH(DATE_ADD(NOW(), INTERVAL 1 MONTH)), 2, '0'),
            YEAR(DATE_ADD(NOW(), INTERVAL 1 MONTH))
        )
    ), 0) AS `Expiring next month`,
    FORMAT(SUM(orp.status LIKE 'canceled_%'
        AND orp.updated_at >= DATE_SUB(NOW(), INTERVAL 90 DAY)
    ), 0) AS `Canceled (90 days)`
FROM core_orderrecurring orp
