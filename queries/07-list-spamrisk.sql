-- =================================================================
-- AK Health Check: Spam trap risk
-- Short name: hc_list_spamrisk
-- Category: List health
-- Description: Subscribed users with zero engagement in 24+ months.
--   These addresses are candidates for recycled spam traps. Mailbox
--   providers convert abandoned addresses into traps that flag
--   senders as spammers. Consider a re-engagement campaign or
--   suppression.
-- Reference: core_user + summary_user (last_open, last_click)
-- Date bound: 24 months
-- Returns: Count (1 row)
-- =================================================================

SELECT FORMAT(COUNT(*), 0) AS spam_risk_users
FROM summary_user su
JOIN core_user u ON u.id = su.user_id
WHERE u.subscription_status = 'subscribed'
  AND GREATEST(
      COALESCE(su.last_open, '2000-01-01'),
      COALESCE(su.last_click, '2000-01-01'),
      COALESCE(su.last_mailing_action, '2000-01-01')
  ) < DATE_SUB(NOW(), INTERVAL 24 MONTH)
