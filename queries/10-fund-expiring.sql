-- =================================================================
-- AK Health Check: Cards expiring next month
-- Short name: hc_fund_expiring
-- Category: Fundraising
-- Description: Active recurring profiles with cards expiring next
--   month. These donors will churn unless they update their payment
--   info. Adapted from AK built-in cards_about_to_expire report.
-- Reference: core_orderrecurring.exp_date (format: MMyyyy)
-- Date bound: Next calendar month
-- Returns: Detail (LIMIT 50)
-- =================================================================

SELECT
    u.email,
    u.first_name,
    u.last_name,
    orp.amount,
    orp.currency,
    orp.period,
    orp.card_num AS last_four,
    orp.exp_date
FROM core_orderrecurring orp
JOIN core_user u ON u.id = orp.user_id
WHERE orp.status = 'active'
  AND orp.exp_date = CONCAT(
      LPAD(MONTH(DATE_ADD(NOW(), INTERVAL 1 MONTH)), 2, '0'),
      YEAR(DATE_ADD(NOW(), INTERVAL 1 MONTH))
  )
ORDER BY orp.amount DESC
LIMIT 50
