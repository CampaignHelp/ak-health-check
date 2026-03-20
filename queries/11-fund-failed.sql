-- =================================================================
-- AK Health Check: Failed recurring — no other active profile
-- Short name: hc_fund_failed
-- Category: Fundraising
-- Description: Recurring profiles in failed or past_due status where
--   the donor has no other active profile. These donors have
--   completely dropped out of the recurring program. Adapted from
--   AK built-in cards_recently_failed report.
-- Reference: core_orderrecurring
-- Date bound: None (current status)
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
    orp.exp_date,
    orp.status
FROM core_orderrecurring orp
JOIN core_user u ON u.id = orp.user_id
WHERE orp.status IN ('failed', 'past_due')
  AND NOT EXISTS (
      SELECT 1
      FROM core_orderrecurring orp2
      WHERE orp2.user_id = orp.user_id
        AND orp2.status = 'active'
  )
ORDER BY orp.amount DESC
LIMIT 50
