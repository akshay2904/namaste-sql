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

```sql
SELECT 
    userid,
    COUNT(DISTINCT productid) as num_products
FROM 
    purchase_history
GROUP BY 
    userid
HAVING 
    -- Customer must have purchases on at least 2 distinct dates
    COUNT(DISTINCT purchasedate) >= 2
    -- For each product, it should only appear on one unique date
    AND COUNT(DISTINCT productid) = COUNT(DISTINCT CONCAT(productid, '|', purchasedate))
ORDER BY 
    userid ASC;
```

Wait, let me reconsider the logic. The requirement is that a product purchased on a given day should not be repeated on any other day. Let me use a better approach:

```sql
SELECT 
    userid,
    COUNT(DISTINCT productid) as num_products
FROM 
    purchase_history
GROUP BY 
    userid
HAVING 
    -- Customer must have purchases on at least 2 distinct dates
    COUNT(DISTINCT purchasedate) >= 2
    -- Each product should appear on exactly one date (no product appears on multiple dates)
    AND COUNT(DISTINCT productid) = (
        SELECT COUNT(DISTINCT productid) 
        FROM purchase_history ph2 
        WHERE ph2.userid = purchase_history.userid
        GROUP BY ph2.productid 
        HAVING COUNT(DISTINCT purchasedate) = 1
    )
ORDER BY 
    userid ASC;
```

Actually, a cleaner approach:

```sql
WITH product_dates AS (
    -- For each customer-product combination, count how many distinct dates it appears on
    SELECT 
        userid,
        productid,
        COUNT(DISTINCT purchasedate) as date_count
    FROM 
        purchase_history
    GROUP BY 
        userid,
        productid
)
SELECT 
    userid,
    COUNT(DISTINCT productid) as num_products
FROM 
    purchase_history
WHERE 
    userid IN (
        -- Filter to customers where all their products appear on exactly 1 date
        SELECT userid
        FROM product_dates
        GROUP BY userid
        HAVING 
            COUNT(DISTINCT purchasedate) >= 2
            AND SUM(CASE WHEN date_count > 1 THEN 1 ELSE 0 END) = 0
    )
GROUP BY 
    userid
ORDER BY 
    userid ASC;
```

Let me simplify further:

```sql
WITH product_dates AS (
    SELECT 
        userid,
        productid,
        COUNT(DISTINCT purchasedate) as date_count
    FROM 
        purchase_history
    GROUP BY 
        userid,
        productid
)
SELECT 
    userid,
    COUNT(DISTINCT productid) as num_products
FROM 
    product_dates
GROUP BY 
    userid
HAVING 
    -- No product appears on multiple dates for this customer
    SUM(CASE WHEN date_count > 1 THEN 1 ELSE 0 END) = 0
    -- Customer must have purchases on at least 2 distinct dates
    AND COUNT(DISTINCT (
        SELECT COUNT(DISTINCT purchasedate) FROM purchase_history WHERE userid = product_dates.userid
    )) >= 2
ORDER BY 
    userid ASC;
```

Better version:

```sql
WITH product_dates AS (
    SELECT 
        userid,
        productid,
        COUNT(DISTINCT purchasedate) as date_count
    FROM 
        purchase_history
    GROUP BY 
        userid,
        productid
),
customer_summary AS (
    SELECT 
        userid,
        COUNT(DISTINCT productid) as num_products,
        MAX(date_count) as max_date_count
    FROM 
        product_dates
    GROUP BY 
        userid
)
SELECT 
    cs.userid,
    cs.num_products
FROM 
    customer_summary cs
WHERE 
    cs.max_date_count = 1
    AND cs.userid IN (
        SELECT userid 
        FROM purchase_history 
        GROUP BY userid 
        HAVING COUNT(DISTINCT purchasedate) >= 2
    )
ORDER BY 
    cs.userid ASC;
```
