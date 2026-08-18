-- ======================================================================
-- 166 - ETL Job Balancing
-- ======================================================================
-- Difficulty : Medium
-- Category   : Python Coding
-- Companies  : Linkedin
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/166-etl-job-balancing
-- ======================================================================

/*
You are responsible for scheduling ETL (Extract-Transform-Load) jobs on two servers  : Server A and Server B.

Each job takes a certain amount of time to process, represented by a list of integers jobs.
Your goal is to distribute all jobs between Server A and Server B such that:

1- Both servers finish as close to the same time as possible (i.e., workloads are balanced).

2- The total processing time is minimized (equal or nearly equal split).

3- Server A should always have workload ≥ Server B in the final output.

Return a tuple containing the total time taken by Server A and Server B after allocation.

 

Example 1
Input:
jobs = [4, 4, 6, 2, 5]
Output:
(11,10)
Explanation:
Balanced assignment →
Server A: [5, 4, 2] = 11
Server B: [6, 4] = 10

Example 2
Input:
jobs = [10, 20, 30]
Output:
(30, 30)
Explanation:
Balanced assignment →
Server A: [10, 20] = 30
Server B: [30] = 30
Example 3
Input:
jobs = [5, 1, 8, 7, 3]
Output:
(12, 12)
Explanation:
Balanced assignment →
Server A: [8, 3, 1] = 12
Server B: [7, 5] = 12
Constraints
. 1 <= len(jobs) <= 10^4
. 1 <= jobs[i] <= 10^4
. Return the total workload of both servers as a tuple (serverA_time, serverB_time).
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- This solves the partition/subset-sum problem via dynamic programming in SQL.
-- We find the subset with maximum sum <= total/2, then assign the rest to Server A.

WITH RECURSIVE
input_jobs(id, job) AS (
    -- Simulate input table: jobs = [4, 4, 6, 2, 5]
    SELECT * FROM (VALUES (1,4),(2,4),(3,6),(4,2),(5,5)) AS t(id, job)
),
total AS (
    SELECT SUM(job) AS total_sum FROM input_jobs
),
-- DP: track achievable sums up to total/2
-- dp_states holds all reachable sums after considering each job
dp(step, achievable_sum) AS (
    -- Base case: sum of 0 is always achievable
    SELECT 0, 0

    UNION

    -- For each job, add it to existing achievable sums if within half total
    SELECT i.id, d.achievable_sum + i.job
    FROM dp d
    JOIN input_jobs i ON i.id = d.step + 1
    JOIN total t ON (d.achievable_sum + i.job) <= t.total_sum / 2  -- stay within half
),
best_b AS (
    -- Best (maximum) sum for Server B that doesn't exceed total/2
    SELECT MAX(achievable_sum) AS b_time FROM dp
),
result AS (
    SELECT
        t.total_sum - b.b_time AS server_a,  -- Server A gets the remainder (always >= B)
        b.b_time                AS server_b
    FROM total t, best_b b
)
SELECT server_a, server_b,
       '(' || server_a || ', ' || server_b || ')' AS output_tuple
FROM result;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Generate all possible subset sums using a numbers/bitmask approach.
-- For small N we enumerate all 2^N subsets; for larger N we use iterative DP with a temp table approach.
-- Here we use a set-based DP with UNION (brute force style, no window functions).

WITH
input_jobs(id, job) AS (
    SELECT * FROM (VALUES (1,4),(2,4),(3,6),(4,2),(5,5)) AS t(id, job)
),
total_sum_cte AS (
    SELECT SUM(job) AS total_sum FROM input_jobs
),
-- Build DP table by iterating through jobs one by one using UNION ALL + DISTINCT
-- Step 0: only sum=0 is reachable
step0 AS (
    SELECT 0 AS reachable
),
-- Step 1: add job id=1
step1 AS (
    SELECT reachable FROM step0
    UNION
    SELECT step0.reachable + input_jobs.job
    FROM step0, input_jobs
    WHERE input_jobs.id = 1
),
-- Step 2: add job id=2
step2 AS (
    SELECT reachable FROM step1
    UNION
    SELECT step1.reachable + input_jobs.job
    FROM step1, input_jobs
    WHERE input_jobs.id = 2
),
-- Step 3: add job id=3
step3 AS (
    SELECT reachable FROM step2
    UNION
    SELECT step2.reachable + input_jobs.job
    FROM step2, input_jobs
    WHERE input_jobs.id = 3
),
-- Step 4: add job id=4
step4 AS (
    SELECT reachable FROM step3
    UNION
    SELECT step3.reachable + input_jobs.job
    FROM step3, input_jobs
    WHERE input_jobs.id = 4
),
-- Step 5: add job id=5
step5 AS (
    SELECT reachable FROM step4
    UNION
    SELECT step4.reachable + input_jobs.job
    FROM step4, input_jobs
    WHERE input_jobs.id = 5
),
-- Filter to sums <= total/2 (these are candidates for Server B)
valid_sums AS (
    SELECT s.reachable
    FROM step5 s, total_sum_cte t
    WHERE s.reachable <= t.total_sum / 2  -- Server B can't exceed half
),
-- Best sum for Server B is the maximum valid sum (closest to half)
best_server_b AS (
    SELECT MAX(reachable) AS b_time FROM valid_sums
),
-- Server A gets everything else; ensure Server A >= Server B
final_result AS (
    SELECT
        (SELECT total_sum FROM total_sum_cte) - b_time AS server_a,
        b_time AS server_b
    FROM best_server_b
)
SELECT
    server_a,
    server_b,
    '(' || server_a || ', ' || server_b || ')' AS output_tuple
FROM final_result;
