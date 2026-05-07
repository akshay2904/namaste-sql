-- ======================================================================
-- 58 - Final Account Balance
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Deloitte
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/58-final-account-balance
-- ======================================================================

/*
You are given history of your bank account for the year 2020. Each transaction is either a credit card payment or incoming transfer. There is a fee of holding a credit card which you have to pay every month, Fee is 5 per month. However, you are not charged for a given month if you made at least 2 credit card payments for a total cost of at least 100 within that month. Note that this fee is not included in the supplied history of transactions.
Each row in the table contains information about a single transaction. If the amount value is negative, it is a credit card payment otherwise it is an incoming transfer. At the beginning of the year, the balance of your account was 0 . Your task is to compute the balance at the end of the year. 

 

Table : Transactions 
+------------------+-----------+
| COLUMN_NAME      | DATA_TYPE |
+------------------+-----------+
| amount           | int       |
| transaction_date | date      |
+------------------+-----------+
*/


-- Write your SQL solution below:

```sql
WITH monthly_transactions AS (
  SELECT 
    EXTRACT(YEAR FROM transaction_date) AS year,
    EXTRACT(MONTH FROM transaction_date) AS month,
    SUM(amount) AS month_total,
    COUNT(CASE WHEN amount < 0 THEN 1 END) AS payment_count,
    SUM(CASE WHEN amount < 0 THEN ABS(amount) ELSE 0 END) AS total_payments
  FROM Transactions
  WHERE EXTRACT(YEAR FROM transaction_date) = 2020
  GROUP BY EXTRACT(YEAR FROM transaction_date), EXTRACT(MONTH FROM transaction_date)
),
monthly_fees AS (
  SELECT 
    month,
    CASE 
      WHEN payment_count >= 2 AND total_payments >= 100 THEN 0
      ELSE 5
    END AS fee
  FROM monthly_transactions
),
all_months AS (
  SELECT month FROM monthly_fees
  UNION ALL
  SELECT GENERATE_SERIES(1, 12) AS month
),
balance_calculation AS (
  SELECT 
    COALESCE(mt.month, am.month) AS month,
    COALESCE(mt.month_total, 0) AS transaction_amount,
    COALESCE(mf.fee, 5) AS monthly_fee
  FROM all_months am
  LEFT JOIN monthly_transactions mt ON am.month = mt.month
  LEFT JOIN monthly_fees mf ON am.month = mf.month
)
SELECT 
  SUM(transaction_amount) - SUM(monthly_fee) AS balance_end_of_year
FROM balance_calculation;
```
