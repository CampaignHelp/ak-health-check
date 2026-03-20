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
FROM core_user u
JOIN summary_user su ON su.user_id = u.id
WHERE u.subscription_status = 'subscribed'
  AND (su.last_open IS NULL
       OR su.last_open < DATE_SUB(NOW(), INTERVAL 24 MONTH))
  AND (su.last_click IS NULL
       OR su.last_click < DATE_SUB(NOW(), INTERVAL 24 MONTH))
  AND (su.last_mailing_action IS NULL
       OR su.last_mailing_action < DATE_SUB(NOW(), INTERVAL 24 MONTH))
