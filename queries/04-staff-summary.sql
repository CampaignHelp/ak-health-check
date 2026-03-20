-- =================================================================
-- AK Health Check: Staff summary
-- Short name: hc_staff_summary
-- Category: Staff security
-- Description: Single-row overview of staff account counts: active,
--   superusers, ghost (no login 90+ days), and deactivated.
-- Reference: auth_user table (Django built-in)
-- Date bound: 90 days (for ghost count)
-- Returns: Count (1 row)
-- =================================================================

SELECT
    FORMAT(SUM(au.is_active = 1), 0) AS `Active staff`,
    FORMAT(SUM(au.is_active = 1 AND au.is_superuser = 1), 0) AS `Superusers`,
    FORMAT(SUM(au.is_active = 1
        AND (au.last_login IS NULL
             OR au.last_login < DATE_SUB(NOW(), INTERVAL 90 DAY))
    ), 0) AS `Ghost accounts`,
    FORMAT(SUM(au.is_active = 0), 0) AS `Deactivated`
FROM auth_user au
WHERE au.is_staff = 1
