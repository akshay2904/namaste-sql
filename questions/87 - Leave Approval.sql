-- ======================================================================
-- 87 - Leave Approval
-- ======================================================================
-- Difficulty : Extreme Hard
-- Category   : Analytics
-- Companies  : Deloitte
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/87-leave-approval
-- ======================================================================

/*
You are tasked with writing an SQL query to determine whether a leave request can be approved for each employee based on their available leave balance for 2024. Employees receive 1.5 leaves at the start of each month, and they may have some balance leaves carried over from the previous year 2023(available in employees table). A leave request can only be approved if the employee has a sufficient leave balance at the start date of planned leave period. 

Write an SQL to derive a new status column stating if leave request is Approved or Rejected for each leave request. Sort the output by request id. Consider the following assumptions:

 
1- If a leave request is eligible for approval, then it will always be taken by employee and leave balance will be deducted as per the leave period. If the leave is rejected then the balance will not be deducted.
2- A leave will either be fully approved or cancelled. No partial approvals possible.
3- If a weekend is falling between the leave start and end date then do consider them when calculating the leave days, Meaning no exclusion of weekends.Tables:employees
+-------------------------+-------------+
| COLUMN_NAME             | DATA_TYPE   |
+-------------------------+-------------+
| employee_id             | int         |
| leave_balance_from_2023 | int         |
| name                    | varchar(20) |
+-------------------------+-------------+Tables:leave_requests
+------------------+-----------+
| COLUMN_NAME      | DATA_TYPE |
+------------------+-----------+
| request_id       | int       |
| employee_id      | int       |
| leave_start_date | date      |
| leave_end_date   | date      |
+------------------+-----------+
*/


-- Write your SQL solution below:

```sql
WITH leave_days_calc AS (
  -- Calculate the number of leave days for each request (inclusive of both start and end dates)
  SELECT 
    request_id,
    employee_id,
    leave_start_date,
    leave_end_date,
    CAST(leave_end_date - leave_start_date AS INT) + 1 AS leave_days
  FROM leave_requests
),
monthly_accrual AS (
  -- Calculate total leave accrued by the start date of each leave request
  -- Employees get 1.5 leaves at the start of each month
  SELECT 
    ldc.request_id,
    ldc.employee_id,
    e.leave_balance_from_2023,
    (EXTRACT(YEAR FROM ldc.leave_start_date) - 2024) * 12 * 1.5 +
    (EXTRACT(MONTH FROM ldc.leave_start_date) - 1) * 1.5 +
    CASE 
      WHEN EXTRACT(YEAR FROM ldc.leave_start_date) = 2024 THEN 1.5
      ELSE 0
    END AS total_accrued,
    ldc.leave_days,
    ldc.leave_start_date
  FROM leave_days_calc ldc
  JOIN employees e ON ldc.employee_id = e.employee_id
),
running_balance AS (
  -- Calculate running balance considering all previously approved leaves in chronological order
  SELECT 
    ma.request_id,
    ma.employee_id,
    ma.leave_balance_from_2023,
    ma.total_accrued,
    ma.leave_days,
    ma.leave_start_date,
    (ma.leave_balance_from_2023 + ma.total_accrued - COALESCE(SUM(CASE 
      WHEN ma2.leave_start_date < ma.leave_start_date 
           OR (ma2.leave_start_date = ma.leave_start_date AND ma2.request_id < ma.request_id)
      THEN ma2.leave_days 
      ELSE 0 
    END) OVER (PARTITION BY ma.employee_id), 0)) AS available_balance
  FROM monthly_accrual ma
  LEFT JOIN monthly_accrual ma2 ON ma.employee_id = ma2.employee_id
)
SELECT 
  request_id,
  employee_id,
  leave_start_date,
  leave_end_date,
  leave_days,
  available_balance,
  CASE 
    WHEN available_balance >= leave_days THEN 'Approved'
    ELSE 'Rejected'
  END AS status
FROM running_balance
ORDER BY request_id;
```
