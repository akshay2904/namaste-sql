-- ======================================================================
-- 138 - Customer Data Cleaning
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Tiger analytics
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/138-customer-data-cleaning
-- ======================================================================

/*
You are given a table with customers information that contains inconsistent and messy data. Your task is to clean the data by writing an SQL query to:

 

1- Trim extra spaces from the customer name and email fields.
2- Convert all email addresses to lowercase for consistency.
3- Remove duplicate records based on email address (keep the record with lower customer id).
4- Standardize the phone number format to only contain digits (remove dashes, spaces, and special characters).
5- Replace NULL values in address with 'Unknown'.

Sort the output by customer id.

 
Table: customers
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| customer_id   | int      |
| customer_name | varchar  | 
| email         | varchar  | 
| phone         | varchar  | 
| address       | varchar  | 
+---------------+----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH cleaned AS (
    SELECT
        customer_id,
        TRIM(customer_name)                          AS customer_name,
        LOWER(TRIM(email))                           AS email,
        REGEXP_REPLACE(phone, '[^0-9]', '', 'g')     AS phone,
        COALESCE(address, 'Unknown')                 AS address
    FROM customers
),
deduped AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY email
            ORDER BY customer_id ASC              -- keep the lowest customer_id per email
        ) AS rn
    FROM cleaned
)
SELECT
    customer_id,
    customer_name,
    email,
    phone,
    address
FROM deduped
WHERE rn = 1
ORDER BY customer_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    c.customer_id,
    TRIM(c.customer_name)                       AS customer_name,
    LOWER(TRIM(c.email))                        AS email,
    REGEXP_REPLACE(c.phone, '[^0-9]', '', 'g')  AS phone,
    COALESCE(c.address, 'Unknown')              AS address
FROM customers c
-- keep only the row with the minimum customer_id for each (cleaned) email
WHERE c.customer_id = (
    SELECT MIN(c2.customer_id)
    FROM customers c2
    WHERE LOWER(TRIM(c2.email)) = LOWER(TRIM(c.email))  -- match on normalized email
)
ORDER BY c.customer_id;
