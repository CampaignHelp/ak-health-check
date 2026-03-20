-- =================================================================
-- AK Health Check: Data quality summary
-- Short name: hc_data_summary
-- Category: Data quality
-- Description: Single-row overview of data completeness for
--   subscribed users: total count and how many are missing zip,
--   state, or country fields.
-- Reference: core_user
-- Date bound: None (current state)
-- Returns: Count (1 row)
-- =================================================================

SELECT
    FORMAT(COUNT(*), 0) AS `Total subscribed`,
    FORMAT(SUM(u.zip IS NULL OR u.zip = ''), 0) AS `No zip`,
    FORMAT(SUM((u.state IS NULL OR u.state = '')
        AND u.zip IS NOT NULL AND u.zip != ''
    ), 0) AS `Has zip, no state`,
    FORMAT(SUM(u.state IS NULL OR u.state = ''), 0) AS `No state (total)`
FROM core_user u
WHERE u.subscription_status = 'subscribed'
