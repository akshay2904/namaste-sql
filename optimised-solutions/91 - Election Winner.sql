-- ======================================================================
-- 91 - Election Winner
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/91-election-winner
-- ======================================================================

/*
You are provided with election data from multiple districts in India. Each district conducted elections for selecting a representative from various political parties. Your task is to analyze the election results to determine the winning party at national levels.  Here are the steps to identify winner:

1- Determine the winning party in each district based on the candidate with the highest number of votes.
2- If multiple candidates from different parties have the same highest number of votes in a district
  , consider it a tie, and all tied candidates are declared winners for that district.
3- Calculate the total number of seats won by each party across all districts
4- A party wins the election if it secures more than 50% of the total seats available nationwide.
Display the total number of seats won by each party and a result column specifying Winner or Loser. Order the output by total seats won in descending order.
Table: elections
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| district_name | varchar(20) |
| candidate_id  | int         |
| party_name    | varchar(10) |
| votes         | int         |
+---------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH district_max AS (
    -- Find max votes per district using window function
    SELECT
        district_name,
        party_name,
        votes,
        MAX(votes) OVER (PARTITION BY district_name) AS max_votes
    FROM elections
),
district_winners AS (
    -- All candidates (possibly multiple) who tied for highest votes in their district
    SELECT DISTINCT
        district_name,
        party_name
    FROM district_max
    WHERE votes = max_votes
),
total_seats AS (
    -- Total number of districts = total seats available
    SELECT COUNT(DISTINCT district_name) AS total_districts
    FROM elections
),
party_seats AS (
    -- Count seats (district wins) per party
    SELECT
        party_name,
        COUNT(*) AS seats_won
    FROM district_winners
    GROUP BY party_name
)
SELECT
    ps.party_name,
    ps.seats_won,
    CASE
        WHEN ps.seats_won > ts.total_districts / 2.0 THEN 'Winner'
        ELSE 'Loser'
    END AS result
FROM party_seats ps
CROSS JOIN total_seats ts
ORDER BY ps.seats_won DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ps.party_name,
    ps.seats_won,
    CASE
        WHEN ps.seats_won > (
            -- Total distinct districts = total seats
            SELECT COUNT(DISTINCT district_name) FROM elections
        ) / 2.0 THEN 'Winner'
        ELSE 'Loser'
    END AS result
FROM (
    -- Count how many districts each party won
    SELECT
        party_name,
        COUNT(*) AS seats_won
    FROM (
        -- Get distinct party winners per district (handles ties)
        SELECT DISTINCT
            dw.district_name,
            dw.party_name
        FROM elections dw
        INNER JOIN (
            -- Find the max votes in each district
            SELECT
                district_name,
                MAX(votes) AS max_votes
            FROM elections
            GROUP BY district_name
        ) dm
            ON dw.district_name = dm.district_name
            AND dw.votes = dm.max_votes
    ) district_winners
    GROUP BY party_name
) ps
ORDER BY ps.seats_won DESC;
