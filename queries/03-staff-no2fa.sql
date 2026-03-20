-- =================================================================
-- AK Health Check: Staff without 2FA
-- Short name: hc_staff_no2fa
-- Category: Staff security
-- Description: Active staff accounts without a confirmed TOTP device.
--   Any staff account without 2FA is vulnerable to credential stuffing
--   and phishing attacks.
-- Reference: auth_user + otp_totp_totpdevice (django-otp)
-- Date bound: None (current state)
-- Returns: Detail (LIMIT 50)
--
-- NOTE: The otp_totp_totpdevice table may not be available in all
-- AK instances or in the read-only reporting connection. If this
-- query errors, the table is not exposed. Remove this report and
-- note the limitation in the dashboard.
-- =================================================================

SELECT
    au.username,
    au.first_name,
    au.last_name,
    au.email,
    au.last_login
FROM auth_user au
LEFT JOIN otp_totp_totpdevice td
    ON td.user_id = au.id
    AND td.confirmed = 1
WHERE au.is_active = 1
  AND au.is_staff = 1
  AND td.id IS NULL
ORDER BY au.last_login DESC
LIMIT 50
