-- ======================================================================
-- 117 - Currency Conversion to USD
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Paytm
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/117-currency-conversion-to-usd
-- ======================================================================

/*
You are given two tables, sales_amount and exchange_rate. The sales_amount table contains sales transactions in various currencies, and the exchange_rate table provides the exchange rates for converting different currencies into USD, along with the dates when these rates became effective.

Your task is to write an SQL query that converts all sales amounts into USD using the most recent applicable exchange rate that was effective on or before the sale date. Then, calculate the total sales in USD for each sale date.

Table: sales_amount  
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| sale_date   | int      |    
| sales_amount| int      |
| currency    | varchar  |
+-------------+----------+Table: exchange_rate  
+-----------------+----------+
| COLUMN_NAME     | DATA_TYPE|
+---------------+------------+
| from_currency | varchar    |    
| to_currency   | varchar    |
| exchange_rate | decimal    |
| effective_date| date       |
+-------------+--------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_rates AS (
    SELECT
        s.sale_date,
        s.sales_amount,
        s.currency,
        er.exchange_rate,
        -- Rank exchange rates per sale + currency, most recent effective date first
        ROW_NUMBER() OVER (
            PARTITION BY s.sale_date, s.sales_amount, s.currency, er.from_currency
            ORDER BY er.effective_date DESC
        ) AS rn
    FROM sales_amount s
    JOIN exchange_rate er
        ON er.from_currency = s.currency
        AND er.to_currency = 'USD'
        AND er.effective_date <= s.sale_date  -- only rates effective on or before sale date
)
SELECT
    sale_date,
    SUM(sales_amount * exchange_rate) AS total_sales_usd
FROM ranked_rates
WHERE rn = 1  -- keep only the most recent applicable rate
GROUP BY sale_date
ORDER BY sale_date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    s.sale_date,
    SUM(s.sales_amount * er.exchange_rate) AS total_sales_usd
FROM sales_amount s
JOIN exchange_rate er
    ON er.from_currency = s.currency
    AND er.to_currency = 'USD'
    -- The effective date must be on or before the sale date
    AND er.effective_date = (
        -- Subquery: find the most recent effective date for this currency pair
        -- that is on or before the sale date
        SELECT MAX(er2.effective_date)
        FROM exchange_rate er2
        WHERE er2.from_currency = s.currency
          AND er2.to_currency = 'USD'
          AND er2.effective_date <= s.sale_date
    )
GROUP BY s.sale_date
ORDER BY s.sale_date;
