-- ======================================================================
-- 5 - CIBIL Score
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Paypal
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/5-cibil-score
-- ======================================================================

/*
CIBIL score, often referred to as a credit score, is a numerical representation of an individual's credit worthiness. While the exact formula used by credit bureaus like CIBIL may not be publicly disclosed and can vary slightly between bureaus, the following are some common factors that typically influence the calculation of a credit score:

 

1- Payment History: This accounts for the largest portion of your credit score. 

It includes factors such as whether you pay your bills on time, any late payments, defaults, bankruptcies, etc.

Assume this accounts for 70 percent of your credit score.

 

2- Credit Utilization Ratio: This is the ratio of your credit card balances to your credit limits.

Keeping this ratio low (ideally below 30%) indicates responsible credit usage. 

Assume it accounts for 30% of your score and below logic to calculate it:  

Utilization below 30% = 1

Utilization between 30% and 50% = 0.7

Utilization above 50% = 0.5

Write an SQL to Calculate credit utilization ratio. Round the result to 1 decimal place.

 

Final Credit score formula = (on_time_loan_or_bill_payment)/total_bills_and_loans * 70 + Credit Utilization Ratio * 30 

Display the output in ascending order of customer id.

 
Table: customers
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| customer_id  | int       |
| credit_limit | int       |
+--------------+-----------+

Table: loans
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| customer_id   | int       |
| loan_id       | int       |
| loan_due_date | date      |
+---------------+-----------+

Table: credit_card_bills
+----------------+-----------+
| COLUMN_NAME    | DATA_TYPE |
+----------------+-----------+
| bill_amount    | int       |
| bill_due_date  | date      |
| bill_id        | int       |
| customer_id    | int       |
+----------------+-----------+

Table: customer_transactions
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| loan_bill_id     | int         |
| transaction_date | date        |
| transaction_type | varchar(10) |
+------------------+-------------+
*/


-- Write your SQL solution below:

```sql
WITH payment_summary AS (
  -- Calculate on-time payments and total bills/loans
  SELECT 
    c.customer_id,
    c.credit_limit,
    COUNT(DISTINCT CASE 
      WHEN ct.transaction_type = 'payment' AND ct.transaction_date <= ccb.bill_due_date 
      THEN ccb.bill_id 
    END) as on_time_cc_payments,
    COUNT(DISTINCT CASE 
      WHEN ct.transaction_type = 'payment' AND ct.transaction_date <= l.loan_due_date 
      THEN l.loan_id 
    END) as on_time_loan_payments,
    COUNT(DISTINCT ccb.bill_id) as total_cc_bills,
    COUNT(DISTINCT l.loan_id) as total_loans,
    COALESCE(SUM(ccb.bill_amount), 0) as total_cc_balance
  FROM customers c
  LEFT JOIN credit_card_bills ccb ON c.customer_id = ccb.customer_id
  LEFT JOIN customer_transactions ct ON ccb.bill_id = ct.loan_bill_id
  LEFT JOIN loans l ON c.customer_id = l.customer_id
  GROUP BY c.customer_id, c.credit_limit
),
utilization_calc AS (
  SELECT 
    customer_id,
    credit_limit,
    on_time_cc_payments,
    on_time_loan_payments,
    total_cc_bills,
    total_loans,
    total_cc_balance,
    CASE 
      WHEN credit_limit > 0 THEN ROUND(CAST(total_cc_balance AS FLOAT) / credit_limit * 100, 1)
      ELSE 0
    END as utilization_ratio,
    CASE 
      WHEN credit_limit > 0 AND CAST(total_cc_balance AS FLOAT) / credit_limit < 0.3 THEN 1
      WHEN credit_limit > 0 AND CAST(total_cc_balance AS FLOAT) / credit_limit < 0.5 THEN 0.7
      ELSE 0.5
    END as utilization_score
  FROM payment_summary
)
SELECT 
  customer_id,
  utilization_ratio,
  ROUND(
    CASE 
      WHEN (total_cc_bills + total_loans) > 0 
        THEN ((on_time_cc_payments + on_time_loan_payments) / CAST(total_cc_bills + total_loans AS FLOAT)) * 70
      ELSE 0
    END + (utilization_score * 30),
    1
  ) as credit_score
FROM utilization_calc
ORDER BY customer_id ASC;
```
