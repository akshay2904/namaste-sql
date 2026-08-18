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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_accrual AS (
    -- Generate monthly accrual of 1.5 leaves for each month in 2024
    SELECT generate_series(1, 12) AS month_num
),
employee_monthly_balance AS (
    -- For each employee, calculate cumulative balance at start of each month
    -- Balance at start of month M = carry_over + 1.5 * M (months 1..M have been credited)
    SELECT 
        e.employee_id,
        e.leave_balance_from_2023,
        ma.month_num,
        -- At the START of month M, accruals for months 1..M have been added
        e.leave_balance_from_2023 + (1.5 * ma.month_num) AS accrued_before_requests
    FROM employees e
    CROSS JOIN monthly_accrual ma
),
ordered_requests AS (
    -- Order leave requests per employee by start date to process sequentially
    SELECT 
        lr.request_id,
        lr.employee_id,
        lr.leave_start_date,
        lr.leave_end_date,
        (lr.leave_end_date - lr.leave_start_date + 1) AS leave_days,
        ROW_NUMBER() OVER (PARTITION BY lr.employee_id ORDER BY lr.leave_start_date, lr.request_id) AS rn
    FROM leave_requests lr
),
-- Iteratively process each leave request using recursive CTE
recursive_approval AS (
    -- Base case: first leave request per employee
    SELECT 
        r.request_id,
        r.employee_id,
        r.leave_start_date,
        r.leave_end_date,
        r.leave_days,
        r.rn,
        -- Available balance at the start of the leave month
        (e.leave_balance_from_2023 + 1.5 * EXTRACT(MONTH FROM r.leave_start_date)) AS balance_at_start,
        CASE 
            WHEN (e.leave_balance_from_2023 + 1.5 * EXTRACT(MONTH FROM r.leave_start_date)) >= r.leave_days
            THEN 'Approved'
            ELSE 'Rejected'
        END AS status,
        -- Running balance after this request
        CASE 
            WHEN (e.leave_balance_from_2023 + 1.5 * EXTRACT(MONTH FROM r.leave_start_date)) >= r.leave_days
            THEN (e.leave_balance_from_2023 + 1.5 * EXTRACT(MONTH FROM r.leave_start_date)) - r.leave_days
            ELSE (e.leave_balance_from_2023 + 1.5 * EXTRACT(MONTH FROM r.leave_start_date))
        END AS remaining_balance
    FROM ordered_requests r
    JOIN employees e ON r.employee_id = e.employee_id
    WHERE r.rn = 1

    UNION ALL

    -- Recursive case: subsequent requests, carry forward remaining balance
    SELECT 
        r.request_id,
        r.employee_id,
        r.leave_start_date,
        r.leave_end_date,
        r.leave_days,
        r.rn,
        -- Add accruals for months between previous leave start and current leave start
        -- Balance = remaining + accruals earned between prev_start_month and current_start_month
        ra.remaining_balance + 
            1.5 * (EXTRACT(MONTH FROM r.leave_start_date) - EXTRACT(MONTH FROM ra.leave_start_date)) AS balance_at_start,
        CASE 
            WHEN (ra.remaining_balance + 
                  1.5 * (EXTRACT(MONTH FROM r.leave_start_date) - EXTRACT(MONTH FROM ra.leave_start_date))) >= r.leave_days
            THEN 'Approved'
            ELSE 'Rejected'
        END AS status,
        CASE 
            WHEN (ra.remaining_balance + 
                  1.5 * (EXTRACT(MONTH FROM r.leave_start_date) - EXTRACT(MONTH FROM ra.leave_start_date))) >= r.leave_days
            THEN (ra.remaining_balance + 
                  1.5 * (EXTRACT(MONTH FROM r.leave_start_date) - EXTRACT(MONTH FROM ra.leave_start_date))) - r.leave_days
            ELSE (ra.remaining_balance + 
                  1.5 * (EXTRACT(MONTH FROM r.leave_start_date) - EXTRACT(MONTH FROM ra.leave_start_date)))
        END AS remaining_balance
    FROM ordered_requests r
    JOIN recursive_approval ra 
        ON r.employee_id = ra.employee_id 
        AND r.rn = ra.rn + 1
)
SELECT 
    request_id,
    employee_id,
    leave_start_date,
    leave_end_date,
    status
FROM recursive_approval
ORDER BY request_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH ordered_requests AS (
    -- Assign sequential row numbers manually using correlated subquery logic
    SELECT 
        lr1.request_id,
        lr1.employee_id,
        lr1.leave_start_date,
        lr1.leave_end_date,
        (lr1.leave_end_date - lr1.leave_start_date + 1) AS leave_days,
        -- Row number = count of requests for same employee that start earlier (or same date, smaller id)
        (SELECT COUNT(*) + 1 
         FROM leave_requests lr2 
         WHERE lr2.employee_id = lr1.employee_id 
           AND (lr2.leave_start_date < lr1.leave_start_date 
                OR (lr2.leave_start_date = lr1.leave_start_date AND lr2.request_id < lr1.request_id))
        ) AS rn
    FROM leave_requests lr1
),
recursive_approval AS (
    -- Base case
    SELECT 
        r.request_id,
        r.employee_id,
        r.leave_start_date,
        r.leave_end_date,
        r.leave_days,
        r.rn,
        (e.leave_balance_from_2023 + 1.5 * EXTRACT(MONTH FROM r.leave_start_date)) AS balance_at_start,
        CASE 
            WHEN (e.leave_balance_from_2023 + 1.5 * EXTRACT(MONTH FROM r.leave_start_date)) >= r.leave_days
            THEN 'Approved'
            ELSE 'Rejected'
        END AS status,
        CASE 
            WHEN (e.leave_balance_from_2023 + 1.5 * EXTRACT(MONTH FROM r.leave_start_date)) >= r.leave_days
            THEN (e.leave_balance_from_2023 + 1.5 * EXTRACT(MONTH FROM r.leave_start_date)) - r.leave_days
            ELSE (e.leave_balance_from_2023 + 1.5 * EXTRACT(MONTH FROM r.leave_start_date))
        END AS remaining_balance
    FROM ordered_requests r
    JOIN employees e ON r.employee_id = e.employee_id
    WHERE r.rn = 1

    UNION ALL

    SELECT 
        r.request_id,
        r.employee_id,
        r.leave_start_date,
        r.leave_end_date,
        r.leave_days,
        r.rn,
        ra.remaining_balance + 
            1.5 * (EXTRACT(MONTH FROM r.leave_start_date) - EXTRACT(MONTH FROM ra.leave_start_date)) AS balance_at_start,
        CASE 
            WHEN (ra.remaining_balance + 
                  1.5 * (EXTRACT(
