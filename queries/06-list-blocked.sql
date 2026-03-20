-- =================================================================
-- AK Health Check: Blocked users
-- Short name: hc_list_blocked
-- Category: List health
-- Description: Count of users with subscription_status = 'blocked'.
--   Blocked users cannot receive email but still count toward your
--   AK billing. A high number inflates costs with zero return.
-- Reference: core_user.subscription_status
-- Date bound: None (current state)
-- Returns: Count (1 row)
-- =================================================================

SELECT FORMAT(COUNT(*), 0) AS blocked_users
FROM core_user u
WHERE u.subscription_status = 'blocked'
