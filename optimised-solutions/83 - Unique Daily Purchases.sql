-- ======================================================================
-- 83 - Unique Daily Purchases
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/83-unique-daily-purchases
-- ======================================================================

/*
Suppose you are analyzing the purchase history of customers in an e-commerce platform. Your task is to identify customers who have bought different products on different dates.
Write an SQL to find customers who have bought different products on different dates, means product purchased on a given day is not repeated on any other day by the customer. Also note that for the customer to qualify he should have made purchases on at least 2 distinct dates. Please note that customer can purchase same product more than once on the same day and that doesn't disqualify him. Output should contain customer id and number of products bought by the customer in ascending order of userid.

 
Table: purchase_history 
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| userid       | int       |
| productid    | int       |
| purchasedate | date      |
+--------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH distinct_purchases AS (
    -- Get distinct (userid, productid, purchasedate) combinations
    -- (same product on same day by same customer counts as one)
    SELECT DISTINCT userid, productid, purchasedate
    FROM purchase_history
),
product_date_counts AS (
    -- Count how many distinct dates each customer bought each product
    SELECT 
        userid,
        productid,
        COUNT(DISTINCT purchasedate) AS date_count
    FROM distinct_purchases
    GROUP BY userid, productid
),
qualified_customers AS (
    -- A customer qualifies only if EVERY product they bought
    -- appears on exactly 1 distinct date (no product repeated on another day)
    -- AND they have purchases on at least 2 distinct dates
    SELECT 
        userid,
        COUNT(DISTINCT productid) AS num_products,
        -- Check that no product was bought on more than 1 distinct date
        MAX(date_count) AS max_date_per_product
    FROM product_date_counts
    GROUP BY userid
    HAVING MAX(date_count) = 1  -- no product repeated across different dates
),
customers_with_2plus_dates AS (
    -- Ensure the customer made purchases on at least 2 distinct dates
    SELECT userid, COUNT(DISTINCT purchasedate) AS distinct_dates
    FROM purchase_history
    GROUP BY userid
    HAVING COUNT(DISTINCT purchasedate) >= 2
)
SELECT 
    qc.userid,
    qc.num_products
FROM qualified_customers qc
INNER JOIN customers_with_2plus_dates cd ON qc.userid = cd.userid
ORDER BY qc.userid ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    userid,
    COUNT(DISTINCT productid) AS num_products
FROM purchase_history
WHERE userid IN (
    -- Customers who purchased on at least 2 distinct dates
    SELECT userid
    FROM purchase_history
    GROUP BY userid
    HAVING COUNT(DISTINCT purchasedate) >= 2
)
AND userid NOT IN (
    -- Exclude customers where any product appears on more than 1 distinct date
    -- (i.e., same product bought on different days)
    SELECT userid
    FROM purchase_history
    GROUP BY userid, productid
    HAVING COUNT(DISTINCT purchasedate) > 1
)
GROUP BY userid
ORDER BY userid ASC;
