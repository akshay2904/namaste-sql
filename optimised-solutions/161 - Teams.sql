-- ======================================================================
-- 161 - Teams
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Linkedin
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/161-teams
-- ======================================================================

/*
Write a query to return a list of teams for each city. Teams are formed within these rules :

1. team members must live in the city they represent.
2. for each city, create teams of 3 until there are fewer than 3 who are unassigned.
3. when there are fewer than 3 people unassigned in a city, they form a team.

Report requirements :

1. There should be 3 columns : city name, a comma-delimited list of up to 3 players and the team's name.
2. the city should be ordered alphabetically
3. Players are selected in the order they occur in the table.
4. Player names should be ordered alphabetically within the comma-delimited list.
5. Team names are 'Team' plus a number.
For example, the first row's team is Team1, then Team2 and so on….

 
Table: emp_details
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| emp_name    | VARCHAR  |
| city        | VARCHAR  |
+-------------+----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    -- Assign row number per city (order of occurrence in table)
    SELECT
        emp_name,
        city,
        ROW_NUMBER() OVER (PARTITION BY city ORDER BY (SELECT NULL)) AS rn
    FROM emp_details
),
team_assigned AS (
    SELECT
        emp_name,
        city,
        rn,
        -- Team number within city: 1-based group of 3
        CEIL(rn / 3.0) AS city_team_num
    FROM ranked
),
city_team_global AS (
    SELECT
        emp_name,
        city,
        rn,
        city_team_num,
        -- Global team number across all cities ordered alphabetically
        DENSE_RANK() OVER (
            ORDER BY city, city_team_num
        ) AS global_team_num
    FROM team_assigned
)
SELECT
    city,
    -- Alphabetically ordered player names within the team
    STRING_AGG(emp_name, ', ' ORDER BY emp_name) AS players,
    'Team' || global_team_num AS team_name
FROM city_team_global
GROUP BY city, city_team_num, global_team_num
ORDER BY city, city_team_num;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH ranked AS (
    -- Assign sequential row number per city based on table order
    SELECT
        emp_name,
        city,
        ROW_NUMBER() OVER (PARTITION BY city ORDER BY (SELECT NULL)) AS rn
    FROM emp_details
),
team_assigned AS (
    SELECT
        emp_name,
        city,
        -- Team number within the city (group of 3)
        ((rn - 1) / 3) + 1 AS city_team_num
    FROM ranked
),
-- Get distinct city+team combinations ordered by city alphabetically
city_teams AS (
    SELECT
        city,
        city_team_num,
        -- Generate a global sequential team number
        ROW_NUMBER() OVER (ORDER BY city, city_team_num) AS global_team_num
    FROM (
        SELECT DISTINCT city, city_team_num
        FROM team_assigned
    ) dt
)
SELECT
    t.city,
    -- Aggregate player names alphabetically within each team
    STRING_AGG(t.emp_name, ', ' ORDER BY t.emp_name) AS players,
    'Team' || ct.global_team_num AS team_name
FROM team_assigned t
JOIN city_teams ct
    ON t.city = ct.city
    AND t.city_team_num = ct.city_team_num
GROUP BY t.city, t.city_team_num, ct.global_team_num
ORDER BY t.city, t.city_team_num;
