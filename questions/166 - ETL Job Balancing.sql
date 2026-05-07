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

```sql
WITH sorted_jobs AS (
  -- Sort jobs in descending order for greedy allocation
  SELECT job_value, ROW_NUMBER() OVER (ORDER BY job_value DESC) as rn
  FROM (
    SELECT UNNEST(ARRAY[4, 4, 6, 2, 5]) as job_value
  ) jobs
),
allocation AS (
  -- Greedy approach: assign each job to the server with less current load
  SELECT 
    job_value,
    rn,
    SUM(CASE WHEN server = 'A' THEN job_value ELSE 0 END) 
      OVER (ORDER BY rn) as server_a_load,
    SUM(CASE WHEN server = 'B' THEN job_value ELSE 0 END) 
      OVER (ORDER BY rn) as server_b_load
  FROM (
    SELECT 
      job_value,
      rn,
      CASE 
        WHEN SUM(job_value) FILTER (WHERE server = 'A') 
             OVER (ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) 
          <= SUM(job_value) FILTER (WHERE server = 'B') 
             OVER (ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)
        THEN 'A'
        ELSE 'B'
      END as server
    FROM (
      SELECT job_value, rn
      FROM sorted_jobs
    ) j
    CROSS JOIN LATERAL (
      SELECT 'A' as server UNION ALL SELECT 'B'
    ) servers
  ) allocation_attempt
)
SELECT 
  COALESCE(SUM(CASE WHEN server = 'A' THEN job_value ELSE 0 END), 0) as server_a_time,
  COALESCE(SUM(CASE WHEN server = 'B' THEN job_value ELSE 0 END), 0) as server_b_time
FROM allocation
GROUP BY server;
```

Actually, let me provide a cleaner solution using a proper greedy algorithm:

```sql
WITH RECURSIVE sorted_jobs AS (
  -- Sort jobs in descending order
  SELECT job_value, ROW_NUMBER() OVER (ORDER BY job_value DESC) as job_id
  FROM (
    SELECT UNNEST(ARRAY[4, 4, 6, 2, 5]) as job_value
  ) jobs
),
allocation AS (
  -- Greedy allocation: assign each job to server with lower load
  SELECT 
    job_id,
    job_value,
    0 as server_a_load,
    0 as server_b_load
  FROM sorted_jobs
  WHERE job_id = 1
  
  UNION ALL
  
  SELECT 
    j.job_id,
    j.job_value,
    CASE 
      WHEN a.server_a_load <= a.server_b_load 
      THEN a.server_a_load + j.job_value
      ELSE a.server_a_load
    END as server_a_load,
    CASE 
      WHEN a.server_a_load <= a.server_b_load 
      THEN a.server_b_load
      ELSE a.server_b_load + j.job_value
    END as server_b_load
  FROM allocation a
  JOIN sorted_jobs j ON j.job_id = a.job_id + 1
)
SELECT 
  MAX(CASE WHEN server_a_load >= server_b_load THEN server_a_load ELSE server_b_load END) as server_a_time,
  MAX(CASE WHEN server_a_load >= server_b_load THEN server_b_load ELSE server_a_load END) as server_b_time
FROM allocation
WHERE job_id = (SELECT MAX(job_id) FROM sorted_jobs);
```

The simplest and most practical approach for this problem:

```sql
WITH RECURSIVE sorted_jobs AS (
  SELECT job_value, ROW_NUMBER() OVER (ORDER BY job_value DESC) as job_id
