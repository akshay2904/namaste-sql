-- ======================================================================
-- 160 - IPv4 Validator
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/160-ipv4-validator
-- ======================================================================

/*
You are given a table logins containing IP addresses as plain text strings.
Each row represents an IP address from a user login attempt. Your task is to validate whether the IP address is a valid IPv4 address or not based on the following criteria:

1- The IP address must contain exactly 4 parts, separated by 3 dots (.).
2- Each part must consist of only numeric digits (no letters or special characters).
3- Each numeric part must be within the inclusive range of 0 to 255.
4- No part should contain leading zeros unless the value is exactly 0.

 
Table: logins
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| ip_address  | VARCHAR  |
+-------------+----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH parsed AS (
    SELECT
        ip_address,
        -- Split into exactly 4 parts using string functions
        SPLIT_PART(ip_address, '.', 1) AS p1,
        SPLIT_PART(ip_address, '.', 2) AS p2,
        SPLIT_PART(ip_address, '.', 3) AS p3,
        SPLIT_PART(ip_address, '.', 4) AS p4,
        -- Count dots to ensure exactly 3
        LENGTH(ip_address) - LENGTH(REPLACE(ip_address, '.', '')) AS dot_count
    FROM logins
),
validated AS (
    SELECT
        ip_address,
        CASE
            WHEN dot_count != 3 THEN 'Invalid'
            -- Each part must be non-empty, purely numeric
            WHEN p1 = '' OR p2 = '' OR p3 = '' OR p4 = '' THEN 'Invalid'
            -- No extra parts (5th part must be empty)
            WHEN SPLIT_PART(ip_address, '.', 5) != '' THEN 'Invalid'
            -- Each part must match only digits via regex
            WHEN p1 !~ '^\d+$' OR p2 !~ '^\d+$' OR p3 !~ '^\d+$' OR p4 !~ '^\d+$' THEN 'Invalid'
            -- No leading zeros unless value is exactly '0'
            WHEN (LENGTH(p1) > 1 AND LEFT(p1, 1) = '0') OR
                 (LENGTH(p2) > 1 AND LEFT(p2, 1) = '0') OR
                 (LENGTH(p3) > 1 AND LEFT(p3, 1) = '0') OR
                 (LENGTH(p4) > 1 AND LEFT(p4, 1) = '0') THEN 'Invalid'
            -- Each part must be between 0 and 255
            WHEN p1::INT NOT BETWEEN 0 AND 255 OR
                 p2::INT NOT BETWEEN 0 AND 255 OR
                 p3::INT NOT BETWEEN 0 AND 255 OR
                 p4::INT NOT BETWEEN 0 AND 255 THEN 'Invalid'
            ELSE 'Valid'
        END AS status
    FROM parsed
)
SELECT ip_address, status
FROM validated
ORDER BY ip_address;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ip_address,
    CASE
        -- Must have exactly 3 dots
        WHEN LENGTH(ip_address) - LENGTH(REPLACE(ip_address, '.', '')) != 3
            THEN 'Invalid'

        -- No 5th segment allowed
        WHEN SPLIT_PART(ip_address, '.', 5) != ''
            THEN 'Invalid'

        -- All 4 parts must be non-empty
        WHEN SPLIT_PART(ip_address, '.', 1) = ''
          OR SPLIT_PART(ip_address, '.', 2) = ''
          OR SPLIT_PART(ip_address, '.', 3) = ''
          OR SPLIT_PART(ip_address, '.', 4) = ''
            THEN 'Invalid'

        -- All parts must be purely numeric
        WHEN SPLIT_PART(ip_address, '.', 1) !~ '^\d+$'
          OR SPLIT_PART(ip_address, '.', 2) !~ '^\d+$'
          OR SPLIT_PART(ip_address, '.', 3) !~ '^\d+$'
          OR SPLIT_PART(ip_address, '.', 4) !~ '^\d+$'
            THEN 'Invalid'

        -- No leading zeros (e.g. '01', '001' are invalid, but '0' is valid)
        WHEN (LENGTH(SPLIT_PART(ip_address, '.', 1)) > 1 AND LEFT(SPLIT_PART(ip_address, '.', 1), 1) = '0')
          OR (LENGTH(SPLIT_PART(ip_address, '.', 2)) > 1 AND LEFT(SPLIT_PART(ip_address, '.', 2), 1) = '0')
          OR (LENGTH(SPLIT_PART(ip_address, '.', 3)) > 1 AND LEFT(SPLIT_PART(ip_address, '.', 3), 1) = '0')
          OR (LENGTH(SPLIT_PART(ip_address, '.', 4)) > 1 AND LEFT(SPLIT_PART(ip_address, '.', 4), 1) = '0')
            THEN 'Invalid'

        -- Each octet must be between 0 and 255
        WHEN CAST(SPLIT_PART(ip_address, '.', 1) AS INTEGER) NOT BETWEEN 0 AND 255
          OR CAST(SPLIT_PART(ip_address, '.', 2) AS INTEGER) NOT BETWEEN 0 AND 255
          OR CAST(SPLIT_PART(ip_address, '.', 3) AS INTEGER) NOT BETWEEN 0 AND 255
          OR CAST(SPLIT_PART(ip_address, '.', 4) AS INTEGER) NOT BETWEEN 0 AND 255
            THEN 'Invalid'

        ELSE 'Valid'
    END AS status
FROM logins
ORDER BY ip_address;
