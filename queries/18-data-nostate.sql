-- =================================================================
-- AK Health Check: Has zip but missing state
-- Short name: hc_data_nostate
-- Category: Data quality
-- Description: Subscribed users who have a zip code but no state.
--   These users cannot be included in state-targeted mailings even
--   though AK could derive their state from zip. This typically
--   happens with imported records. Fixable via a user update or
--   geocode backfill.
-- Reference: core_user.state, core_user.zip
-- Date bound: None (current state)
-- Returns: Count (1 row)
-- =================================================================

SELECT FORMAT(COUNT(*), 0) AS missing_state
FROM core_user u
WHERE u.subscription_status = 'subscribed'
  AND COALESCE(u.state, '') = ''
  AND u.zip > ''
