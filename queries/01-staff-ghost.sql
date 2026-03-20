-- =================================================================
-- AK Health Check: Ghost staff accounts
-- Short name: hc_staff_ghost
-- Category: Staff security
-- Description: Active staff accounts with no login in 90+ days.
--   These accounts can be exploited if credentials are compromised.
--   Review and deactivate accounts that are no longer needed.
-- Reference: auth_user table (Django built-in)
-- Date bound: 90 days
-- Returns: Detail (LIMIT 50)
-- =================================================================

SELECT
    au.username,
    au.first_name,
    au.last_name,
    au.email,
    au.last_login,
    au.date_joined,
    au.is_superuser
FROM auth_user au
WHERE au.is_active = 1
  AND au.is_staff = 1
  AND (au.last_login IS NULL
       OR au.last_login < DATE_SUB(NOW(), INTERVAL 90 DAY))
ORDER BY au.last_login ASC
LIMIT 50
