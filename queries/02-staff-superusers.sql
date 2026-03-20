-- =================================================================
-- AK Health Check: Superuser accounts
-- Short name: hc_staff_superusers
-- Category: Staff security
-- Description: All active superusers. Superusers can access everything
--   including SQL reports, user data, and configuration. Keep this
--   list as short as possible.
-- Reference: auth_user table (Django built-in)
-- Date bound: None (current state)
-- Returns: Detail (LIMIT 50)
-- =================================================================

SELECT
    au.username,
    au.first_name,
    au.last_name,
    au.email,
    au.last_login,
    au.date_joined
FROM auth_user au
WHERE au.is_active = 1
  AND au.is_superuser = 1
ORDER BY au.last_login DESC
LIMIT 50
