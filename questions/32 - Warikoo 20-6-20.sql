-- ======================================================================
-- 32 - Warikoo 20-6-20
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Accenture
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/32-warikoo-20-6-20
-- ======================================================================

/*
Ankur Warikoo, an influential figure in Indian social media, shares a guideline in one of his videos called the 20-6-20 rule for determining whether one can afford to buy a phone or not. The rule for affordability entails three conditions:

 
1. Having enough savings to cover a 20 percent down payment.
2. Utilizing a maximum 6-month EMI plan (no-cost) for the remaining cost.
3. Monthly EMI should not exceed 20 percent of one's monthly salary.
Given the salary and savings of various users, along with data on phone costs, the task is to write an SQL to generate a list of phones (comma-separated) that each user can afford based on these criteria, display the output in ascending order of the user name.

 
Table: users
+----------------+-------------+
| COLUMN_NAME    | DATA_TYPE   |
+----------------+-------------+
| user_name      | varchar(10) |
| monthly_salary | int         |
| savings        | int         |
+----------------+-------------+Table: phones
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| cost        | int         |
| phone_name  | varchar(15) |
+-------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    u.user_name,
    STRING_AGG(p.phone_name, ', ' ORDER BY p.phone_name) AS affordable_phones
FROM users u
CROSS JOIN phones p
WHERE 
    -- Condition 1: Savings >= 20% of phone cost
    u.savings >= (p.cost * 0.20)
    -- Condition 2: Remaining cost can be covered by 6-month EMI
    AND (p.cost - u.savings * 0.20) <= (u.monthly_salary * 0.20 * 6)
    -- Condition 3: Monthly EMI <= 20% of monthly salary
    AND ((p.cost - u.savings * 0.20) / 6) <= (u.monthly_salary * 0.20)
GROUP BY u.user_name
ORDER BY u.user_name ASC;
```
