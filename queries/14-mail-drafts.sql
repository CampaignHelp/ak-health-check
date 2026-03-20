-- =================================================================
-- AK Health Check: Stale draft mailings
-- Short name: hc_mail_drafts
-- Category: Mailing hygiene
-- Description: Draft mailings older than 90 days. Old drafts clutter
--   the mailing list and can be accidentally sent with outdated
--   content. Review and delete or send.
-- Reference: core_mailing.status, core_mailingsubject
-- Date bound: 90 days
-- Returns: Detail (LIMIT 50)
-- =================================================================

SELECT
    m.id,
    (SELECT ms.text
     FROM core_mailingsubject ms
     WHERE ms.mailing_id = m.id
     LIMIT 1) AS subject,
    au.username AS created_by,
    m.created_at
FROM core_mailing m
LEFT JOIN auth_user au ON au.id = m.submitter_id
WHERE m.status = 'draft'
  AND m.created_at < DATE_SUB(NOW(), INTERVAL 90 DAY)
  AND m.hidden = 0
ORDER BY m.created_at ASC
LIMIT 50
