-- =================================================================
-- AK Health Check: Missing zip codes
-- Short name: hc_data_nozip
-- Category: Data quality
-- Description: Count of subscribed users with no zip code. Zip codes
--   drive congressional district targeting for advocacy campaigns.
--   Missing zips mean these users cannot be included in targeted
--   actions.
-- Reference: core_user.zip
-- Date bound: None (current state)
-- Returns: Count (1 row)
-- =================================================================

SELECT FORMAT(COUNT(*), 0) AS missing_zip
FROM core_user u
WHERE u.subscription_status = 'subscribed'
  AND (u.zip IS NULL OR u.zip = '')
