-- ======================================================================
-- 51 - Balanced Team
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Kpmg
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/51-balanced-team
-- ======================================================================

/*
Suppose you are a manager of a data analytics company. You are tasked to build a new team consists of senior and junior data analysts. The total budget for the salaries is 70000.  You need to use the below criterion for hiring:

 
1- Keep hiring the seniors with the smallest salaries until you cannot hire anymore seniors.
2- Use the remaining budget to hire the juniors with the smallest salaries until you cannot hire anymore juniors.
Display employee id, experience and salary. Sort in decreasing order of salary.

 
Table: candidates
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| emp_id      | int         |
| experience  | varchar(6) |
| salary      | int         |
+-------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        emp_id,
        experience,
        salary,
        -- Running cumulative salary within each experience group, ordered by salary asc
        SUM(salary) OVER (
            PARTITION BY experience
            ORDER BY salary ASC, emp_id ASC
        ) AS running_total
    FROM candidates
),
senior_budget AS (
    -- Total spent on seniors (only those we can afford)
    SELECT COALESCE(MAX(running_total), 0) AS spent
    FROM ranked
    WHERE experience = 'Senior'
      AND running_total <= 70000
),
hired_seniors AS (
    SELECT r.emp_id, r.experience, r.salary
    FROM ranked r
    CROSS JOIN senior_budget sb
    WHERE r.experience = 'Senior'
      AND r.running_total <= 70000
),
hired_juniors AS (
    SELECT r.emp_id, r.experience, r.salary
    FROM ranked r
    CROSS JOIN senior_budget sb
    WHERE r.experience = 'Junior'
      AND r.running_total <= (70000 - sb.spent)
)
SELECT emp_id, experience, salary
FROM (
    SELECT * FROM hired_seniors
    UNION ALL
    SELECT * FROM hired_juniors
) combined
ORDER BY salary DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Step 1: Find the remaining budget after hiring seniors
-- A senior is affordable if the sum of all seniors with lower (or equal) salary fits in 70000

SELECT emp_id, experience, salary
FROM candidates
WHERE experience = 'Senior'
  AND (
      -- All seniors with salary <= this senior's salary (cumulative) must fit in budget
      SELECT COALESCE(SUM(s2.salary), 0)
      FROM candidates s2
      WHERE s2.experience = 'Senior'
        AND (s2.salary < candidates.salary
             OR (s2.salary = candidates.salary AND s2.emp_id <= candidates.emp_id))
  ) <= 70000

UNION ALL

SELECT emp_id, experience, salary
FROM candidates
WHERE experience = 'Junior'
  AND (
      SELECT COALESCE(SUM(j2.salary), 0)
      FROM candidates j2
      WHERE j2.experience = 'Junior'
        AND (j2.salary < candidates.salary
             OR (j2.salary = candidates.salary AND j2.emp_id <= candidates.emp_id))
  ) <= (
      -- Remaining budget after seniors
      70000 - (
          SELECT COALESCE(SUM(salary), 0)
          FROM candidates
          WHERE experience = 'Senior'
            AND (
                SELECT COALESCE(SUM(s2.salary), 0)
                FROM candidates s2
                WHERE s2.experience = 'Senior'
                  AND (s2.salary < candidates.salary
                       OR (s2.salary = candidates.salary AND s2.emp_id <= candidates.emp_id))
            ) <= 70000
      )
  )

ORDER BY salary DESC;
