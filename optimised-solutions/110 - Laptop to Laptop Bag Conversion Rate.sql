-- ======================================================================
-- 110 - Laptop to Laptop Bag Conversion Rate
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/110-laptop-to-laptop-bag-conversion-rate
-- ======================================================================

/*
The marketing team at a retail company wants to analyze customer purchasing behavior. They are particularly interested in understanding how many customers who bought a laptop later went on to purchase a laptop bag, with no intermediate purchases in between. Write an SQL to get number of customer in each country who bought laptop and number of customers who bought laptop bag just after buying a laptop. Order the result by country.

 
Table: transactions
+----------------------+------------+
| COLUMN_NAME          | DATA_TYPE  |
+----------------------+------------+
| transaction_id       | int        |
| customer_id          | date       |
| product_name         | varchar(10)|
| transaction_timestamp| datetime   |
| country              | varchar(5) |
+----------------------+------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_transactions AS (
    SELECT
        customer_id,
        country,
        product_name,
        transaction_timestamp,
        -- Get the next product purchased by each customer
        LEAD(product_name) OVER (
            PARTITION BY customer_id 
            ORDER BY transaction_timestamp
        ) AS next_product
    FROM transactions
),
laptop_buyers AS (
    SELECT
        country,
        COUNT(DISTINCT customer_id) AS laptop_customers
    FROM transactions
    WHERE product_name = 'Laptop'
    GROUP BY country
),
laptop_bag_after_laptop AS (
    -- Customers who bought laptop bag immediately after laptop
    SELECT
        country,
        COUNT(DISTINCT customer_id) AS laptop_then_bag_customers
    FROM ranked_transactions
    WHERE product_name = 'Laptop'
      AND next_product = 'Laptop Bag'
    GROUP BY country
)
SELECT
    lb.country,
    lb.laptop_customers,
    COALESCE(lbag.laptop_then_bag_customers, 0) AS laptop_then_bag_customers
FROM laptop_buyers lb
LEFT JOIN laptop_bag_after_laptop lbag
    ON lb.country = lbag.country
ORDER BY lb.country;


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    lb.country,
    lb.laptop_customers,
    COALESCE(lbag.laptop_then_bag_customers, 0) AS laptop_then_bag_customers
FROM (
    -- Count distinct customers who bought a laptop, per country
    SELECT
        country,
        COUNT(DISTINCT customer_id) AS laptop_customers
    FROM transactions
    WHERE product_name = 'Laptop'
    GROUP BY country
) lb
LEFT JOIN (
    -- Find customers where the very next purchase after a laptop is a laptop bag
    SELECT
        t1.country,
        COUNT(DISTINCT t1.customer_id) AS laptop_then_bag_customers
    FROM transactions t1
    INNER JOIN transactions t2
        ON t1.customer_id = t2.customer_id
        AND t1.country    = t2.country
        AND t1.product_name = 'Laptop'
        AND t2.product_name = 'Laptop Bag'
        AND t2.transaction_timestamp > t1.transaction_timestamp
    WHERE NOT EXISTS (
        -- No other transaction exists between the laptop and laptop bag purchase
        SELECT 1
        FROM transactions t3
        WHERE t3.customer_id = t1.customer_id
          AND t3.transaction_timestamp > t1.transaction_timestamp
          AND t3.transaction_timestamp < t2.transaction_timestamp
    )
    GROUP BY t1.country
) lbag
    ON lb.country = lbag.country
ORDER BY lb.country;
