-- ======================================================================
-- 52 - Loan Repayment
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Deloitte
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/52-loan-repayment
-- ======================================================================

/*
You're working for a large financial institution that provides various types of loans to customers. Your task is to analyze loan repayment data to assess credit risk and improve risk management strategies.

Write an SQL to create 2 flags for each loan as per below rules. Display loan id, loan amount , due date and the 2 flags.

 
1- fully_paid_flag: 1 if the loan was fully repaid irrespective of payment date else it should be 0.
2- on_time_flag : 1 if the loan was fully repaid on or before due date else 0.Table: loans
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| loan_id     | int       |
| customer_id | int       |
| loan_amount | int       |
| due_date    | date      |
+-------------+-----------+Table: payments
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| amount_paid  | int       |
| loan_id      | int       |
| payment_date | date      |
| payment_id   | int       |
+--------------+-----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    l.loan_id,
    l.loan_amount,
    l.due_date,
    CASE WHEN COALESCE(SUM(p.amount_paid), 0) >= l.loan_amount THEN 1 ELSE 0 END AS fully_paid_flag,
    CASE 
        WHEN COALESCE(SUM(p.amount_paid), 0) >= l.loan_amount 
             AND MIN(p.payment_date) <= l.due_date THEN 1 
        ELSE 0 
    END AS on_time_flag
FROM loans l
LEFT JOIN payments p ON l.loan_id = p.loan_id
GROUP BY l.loan_id, l.loan_amount, l.due_date
ORDER BY l.loan_id;
```
