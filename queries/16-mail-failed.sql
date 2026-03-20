-- =================================================================
-- AK Health Check: Stopped or died mailings
-- Short name: hc_mail_failed
-- Category: Mailing hygiene
-- Description: Mailings that stopped or died in the last 90 days.
--   A "stopped" mailing was manually halted by staff. A "died"
--   mailing was killed by AK due to high bounce rates or other
--   problems. Both warrant investigation.
-- Reference: core_mailing.status, core_mailingsubject
-- Date bound: 90 days
-- Returns: Detail (LIMIT 50)
-- =================================================================

SELECT
    m.id,
    m.status,
    (SELECT ms.text
     FROM core_mailingsubject ms
     WHERE ms.mailing_id = m.id
     LIMIT 1) AS subject,
    au.username AS sent_by,
    m.started_at,
    m.progress,
    m.expected_send_count
FROM core_mailing m
LEFT JOIN auth_user au ON au.id = m.submitter_id
WHERE m.status IN ('stopped', 'died')
  AND m.started_at >= DATE_SUB(NOW(), INTERVAL 90 DAY)
  AND m.hidden = 0
ORDER BY m.started_at DESC
LIMIT 50
