-- ======================================================================
-- 196 - Tax Calculation
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Hackerrank
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/196-tax-calculation
-- ======================================================================

/*
In the evolving landscape of financial technology, quickly assessing financial performance over time is crucial. A development team is enhancing a tax calculation application to include a dashboard feature. This feature will provide users with a clear view of their financial inflows over the quarters of 2023, facilitating better financial planning and tax calculation.

 

The dashboard will display the total income for each account, segmented by the four quarters of 2023, and will also include the total yearly income. This breakdown will help users understand their earnings pattern and prepare for tax calculations.

 

The result should have the following columns: 
email, q1_income, q2_income, q3_income, q4_income, total_yearly_income

email - the email associated with the account
q1_income .. q4_income - the total income for the specific quarter, with two decimal places
total_yearly_income - the sum of all quarters’ incomes for the year, with two decimal places
 

The results should be sorted in ascending order by email.

Note:

Only income recorded in 2023 should be included.

 
Table: accounts
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| id          | INT          |
| email       | VARCHAR(30)  |
+-------------+--------------+
Table: reports
+-------------+----------------+
| COLUMN_NAME | DATA_TYPE      |
+-------------+----------------+
| account_id  | INT            |
| dt          | VARCHAR(19)    |
| amount      | DECIMAL(6,2)   |
+-------------+----------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
  a.email,
  ROUND(COALESCE(SUM(CASE WHEN QUARTER(STR_TO_DATE(r.dt, '%Y-%m-%d %H:%i:%s')) = 1 THEN r.amount ELSE 0 END), 0), 2) AS q1_income,
  ROUND(COALESCE(SUM(CASE WHEN QUARTER(STR_TO_DATE(r.dt, '%Y-%m-%d %H:%i:%s')) = 2 THEN r.amount ELSE 0 END), 0), 2) AS q2_income,
  ROUND(COALESCE(SUM(CASE WHEN QUARTER(STR_TO_DATE(r.dt, '%Y-%m-%d %H:%i:%s')) = 3 THEN r.amount ELSE 0 END), 0), 2) AS q3_income,
  ROUND(COALESCE(SUM(CASE WHEN QUARTER(STR_TO_DATE(r.dt, '%Y-%m-%d %H:%i:%s')) = 4 THEN r.amount ELSE 0 END), 0), 2) AS q4_income,
  ROUND(COALESCE(SUM(r.amount), 0), 2) AS total_yearly_income
FROM accounts a
LEFT JOIN reports r ON a.id = r.account_id 
  AND YEAR(STR_TO_DATE(r.dt, '%Y-%m-%d %H:%i:%s')) = 2023
GROUP BY a.id, a.email
ORDER BY a.email ASC;
```
