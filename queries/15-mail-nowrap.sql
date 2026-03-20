-- =================================================================
-- AK Health Check: Mailings sent without a wrapper
-- Short name: hc_mail_nowrap
-- Category: Mailing hygiene
-- Description: Completed mailings in the last 12 months that were
--   sent without an email wrapper. Missing wrappers mean no
--   unsubscribe link, no physical address, and potential CAN-SPAM
--   violations.
-- Reference: core_mailing.emailwrapper_id, core_mailingsubject
-- Date bound: 12 months
-- Returns: Detail (LIMIT 50)
-- =================================================================

SELECT
    m.id,
    (SELECT ms.text
     FROM core_mailingsubject ms
     WHERE ms.mailing_id = m.id
     LIMIT 1) AS subject,
    au.username AS sent_by,
    m.started_at,
    m.expected_send_count
FROM core_mailing m
LEFT JOIN auth_user au ON au.id = m.submitter_id
WHERE m.status = 'completed'
  AND (m.emailwrapper_id IS NULL OR m.emailwrapper_id = 0)
  AND m.started_at >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
  AND m.hidden = 0
ORDER BY m.started_at DESC
LIMIT 50
