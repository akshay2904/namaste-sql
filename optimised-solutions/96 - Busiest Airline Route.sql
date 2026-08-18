-- ======================================================================
-- 96 - Busiest Airline Route
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Deloitte
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/96-busiest-airline-route
-- ======================================================================

/*
You are given a table named "tickets" containing information about airline tickets sold. Write an SQL query to find the busiest route based on the total number of tickets sold. Also display total ticket count for that route.
oneway_round ='O' -> One Way Trip 
oneway_round ='R' -> Round Trip 
Note: DEL -> BOM is different route from BOM -> DEL

 
Tables: tickets
+----------------+-------------+
| COLUMN_NAME    | DATA_TYPE   |
+----------------+-------------+
| airline_number | varchar(10) |
| origin         | varchar(3)  |
| destination    | varchar(3)  |
| oneway_round   | char(1)     |
| ticket_count   | int         |
+----------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH route_totals AS (
    SELECT
        origin,
        destination,
        SUM(ticket_count) AS total_tickets,
        RANK() OVER (ORDER BY SUM(ticket_count) DESC) AS rnk
    FROM tickets
    GROUP BY origin, destination
)
SELECT
    origin,
    destination,
    total_tickets
FROM route_totals
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    origin,
    destination,
    SUM(ticket_count) AS total_tickets
FROM tickets
GROUP BY origin, destination
HAVING SUM(ticket_count) = (
    -- Find the maximum total tickets across all routes
    SELECT MAX(route_sum)
    FROM (
        SELECT SUM(ticket_count) AS route_sum
        FROM tickets
        GROUP BY origin, destination
    ) AS sub
);
