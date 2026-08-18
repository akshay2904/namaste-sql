-- ======================================================================
-- 157 - Salary Growth Analysis
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/157-salary-growth-analysis
-- ======================================================================

/*
The HR analytics team wants to evaluate employee performance based on their salary progression and promotion history. Write a query to return a summary for each employee with the following:

 

 1. `employee_id`
 2. `latest_salary`: most recent salary value
 3. `total_promotions`: number of times the employee got a promotion 
 4. `max_perc_change`: the maximum percentage increase between any two salary changes (round to 2 decimal places)
 5. `never_decreased`: 'Y' if salary never decreased, else 'N'
 6. `RankByGrowth`: rank of the employee based on salary growth (latest_salary / first_salary), tie-breaker = earliest join date

 
Table: employees
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| employee_id   | INT      | 
| name          | VARCHAR  | 
| join_date     | DATE     | 
| department    | VARCHAR  |  
| intial_salary | INT      | 
+--------------------------+Table: salary_history
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| employee_id  | INT      | 
| change_date  | DATE     |
| salary       | INT      | 
| promotion    | VARCHAR  | 
+-------------------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH salary_with_lag AS (
    SELECT
        sh.employee_id,
        sh.salary,
        sh.change_date,
        sh.promotion,
        -- Previous salary: use initial_salary for first record, else prior salary
        LAG(sh.salary) OVER (PARTITION BY sh.employee_id ORDER BY sh.change_date) AS prev_salary,
        ROW_NUMBER() OVER (PARTITION BY sh.employee_id ORDER BY sh.change_date DESC) AS rn_latest,
        ROW_NUMBER() OVER (PARTITION BY sh.employee_id ORDER BY sh.change_date ASC)  AS rn_first
    FROM salary_history sh
),
employee_stats AS (
    SELECT
        s.employee_id,
        -- Latest salary
        MAX(CASE WHEN s.rn_latest = 1 THEN s.salary END) AS latest_salary,
        -- First salary from salary_history
        MAX(CASE WHEN s.rn_first = 1 THEN s.salary END)  AS first_salary_hist,
        -- Total promotions
        SUM(CASE WHEN s.promotion = 'Y' THEN 1 ELSE 0 END) AS total_promotions,
        -- Max % change between consecutive salaries (only where prev_salary exists)
        ROUND(
            MAX(
                CASE
                    WHEN s.prev_salary IS NOT NULL AND s.prev_salary <> 0
                    THEN ((s.salary - s.prev_salary) * 100.0 / s.prev_salary)
                END
            ), 2
        ) AS max_perc_change,
        -- Never decreased: 'Y' if no record has salary < previous salary
        CASE
            WHEN MIN(
                CASE
                    WHEN s.prev_salary IS NOT NULL
                    THEN (s.salary - s.prev_salary)
                    ELSE 0
                END
            ) < 0 THEN 'N'
            ELSE 'Y'
        END AS never_decreased
    FROM salary_with_lag s
    GROUP BY s.employee_id
),
combined AS (
    SELECT
        e.employee_id,
        es.latest_salary,
        es.total_promotions,
        es.max_perc_change,
        es.never_decreased,
        -- Salary growth = latest_salary / first salary (initial_salary from employees table as baseline)
        es.latest_salary * 1.0 / NULLIF(e.intial_salary, 0) AS salary_growth,
        e.join_date
    FROM employees e
    JOIN employee_stats es ON e.employee_id = es.employee_id
)
SELECT
    employee_id,
    latest_salary,
    total_promotions,
    max_perc_change,
    never_decreased,
    -- Rank by growth descending; tie-break by earliest join_date ascending
    RANK() OVER (ORDER BY salary_growth DESC, join_date ASC) AS RankByGrowth
FROM combined
ORDER BY RankByGrowth;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    e.employee_id,

    -- Latest salary
    (SELECT sh.salary
     FROM salary_history sh
     WHERE sh.employee_id = e.employee_id
     ORDER BY sh.change_date DESC
     LIMIT 1) AS latest_salary,

    -- Total promotions
    (SELECT COUNT(*)
     FROM salary_history sh
     WHERE sh.employee_id = e.employee_id
       AND sh.promotion = 'Y') AS total_promotions,

    -- Max percentage change between consecutive salary entries
    (SELECT ROUND(MAX(
                ((sh.salary - prev_sh.salary) * 100.0 / NULLIF(prev_sh.salary, 0))
            ), 2)
     FROM salary_history sh
     JOIN salary_history prev_sh
       ON prev_sh.employee_id = sh.employee_id
      -- prev_sh is the immediately preceding record
      AND prev_sh.change_date = (
            SELECT MAX(sh2.change_date)
            FROM salary_history sh2
            WHERE sh2.employee_id = sh.employee_id
              AND sh2.change_date < sh.change_date
          )
     WHERE sh.employee_id = e.employee_id) AS max_perc_change,

    -- Never decreased
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM salary_history sh
            JOIN salary_history prev_sh
              ON prev_sh.employee_id = sh.employee_id
             AND prev_sh.change_date = (
                    SELECT MAX(sh2.change_date)
                    FROM salary_history sh2
                    WHERE sh2.employee_id = sh.employee_id
                      AND sh2.change_date < sh.change_date
                 )
            WHERE sh.employee_id = e.employee_id
              AND sh.salary < prev_sh.salary
        ) THEN 'N'
        ELSE 'Y'
    END AS never_decreased,

    -- Rank by salary growth (latest / initial), tie-break by earliest join_date
    (SELECT COUNT(*) + 1
     FROM employees e2
     WHERE (
               (SELECT sh.salary FROM salary_history sh
                WHERE sh.employee_id = e2.employee_id
                ORDER BY sh.change_date DESC LIMIT 1) * 1.0
               / NULLIF(e2.intial_salary, 0)
           ) >
           (
               (SELECT sh.salary FROM salary_history sh
                WHERE sh.employee_id = e.employee_id
                ORDER BY sh.change_date DESC LIMIT 1) * 1.0
               / NULLIF(e.intial_salary, 0)
           )
        OR (
               (SELECT sh.salary FROM salary_history sh
                WHERE sh.employee_id = e2.employee_id
                ORDER BY sh.change_date DESC LIMIT 1) * 1.0
               / NULLIF(e2.intial_salary, 0)
           ) =
           (
               (SELECT sh.salary FROM salary_history sh
                WHERE sh.employee_id = e.employee_id
                ORDER BY sh.change_date DESC LIMIT 1) * 1.0
               / NULLIF(e.intial_salary, 0)
           )
           AND e2.join_date < e.join_date
    ) AS RankByGrowth

FROM employees e
ORDER BY RankByGrowth;
