-- ======================================================================
-- 90 - Calculate Customer Interest
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Jp morgan
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/90-calculate-customer-interest
-- ======================================================================

/*
You are tasked with analyzing the interest earned by customers based on their account balances and transaction history. Each customer's account accrues interest based on their balance and prevailing interest rates. The interest is calculated for the ending balance on each day. Your goal is to determine the total interest earned by each customer for the month of March-2024. The interest rates (per day) are given in the interest table as per the balance amount range. 

 

Please assume that the account balance for each customer was 0 at the start of March 2024.  Write an SQL to calculate interest earned by each customer from March 1st 2024 to March 31st 2024, display the output in ascending order of customer id.

 
Table: transactions
+------------------+-----------+
| COLUMN_NAME      | DATA_TYPE |
+------------------+-----------+
| transaction_id   | int       |
| customer_id      | int       |
| transaction_date | date      |
| amount           | int       |
+------------------+-----------+Table: interestrates
+---------------+--------------+
| COLUMN_NAME   | DATA_TYPE    |
+---------------+--------------+
| rate_id       | int          |
| max_balance   | int          |
| min_balance   | int          |
| interest_rate | decimal(5,4) |
+---------------+--------------+
*/


-- Write your SQL solution below:

```sql
WITH date_series AS (
  -- Generate all dates in March 2024
  SELECT DATE '2024-03-01' + (row_number() OVER () - 1) AS calc_date
  FROM (
    SELECT generate_series(0, 30) AS day_num
  ) AS series
),
daily_balances AS (
  -- Calculate cumulative balance for each customer at end of each day
  SELECT 
    ds.calc_date,
    c.customer_id,
    COALESCE(SUM(t.amount), 0) AS daily_balance
  FROM (
    SELECT DISTINCT customer_id FROM transactions
    WHERE transaction_date BETWEEN '2024-03-01' AND '2024-03-31'
    UNION
    SELECT DISTINCT customer_id FROM (SELECT 1 AS customer_id) dummy
  ) c
  CROSS JOIN date_series ds
  LEFT JOIN transactions t 
    ON c.customer_id = t.customer_id 
    AND t.transaction_date <= ds.calc_date
    AND t.transaction_date >= '2024-03-01'
  GROUP BY ds.calc_date, c.customer_id
),
interest_earned AS (
  -- Calculate daily interest based on applicable rate
  SELECT 
    db.customer_id,
    db.calc_date,
    db.daily_balance,
    ir.interest_rate,
    (db.daily_balance * ir.interest_rate) AS daily_interest
  FROM daily_balances db
  LEFT JOIN interestrates ir 
    ON db.daily_balance >= ir.min_balance 
    AND db.daily_balance < ir.max_balance
)
SELECT 
  customer_id,
  ROUND(SUM(COALESCE(daily_interest, 0)), 2) AS total_interest_earned
FROM interest_earned
GROUP BY customer_id
ORDER BY customer_id ASC;
```
