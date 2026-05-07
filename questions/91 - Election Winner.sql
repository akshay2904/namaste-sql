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

```sql
WITH district_max_votes AS (
  -- Find the maximum votes in each district
  SELECT 
    district_name,
    MAX(votes) AS max_votes
  FROM elections
  GROUP BY district_name
),
district_winners AS (
  -- Identify all candidates who won in each district (handling ties)
  SELECT 
    e.district_name,
    e.party_name,
    e.votes
  FROM elections e
  INNER JOIN district_max_votes dmv
    ON e.district_name = dmv.district_name
    AND e.votes = dmv.max_votes
),
party_seats AS (
  -- Count total seats won by each party across all districts
  SELECT 
    party_name,
    COUNT(DISTINCT district_name) AS total_seats
  FROM district_winners
  GROUP BY party_name
),
total_seats_available AS (
  -- Calculate total number of districts (seats available)
  SELECT COUNT(DISTINCT district_name) AS total_districts
  FROM elections
),
party_results AS (
  -- Determine winner or loser based on 50% threshold
  SELECT 
    ps.party_name,
    ps.total_seats,
    tsa.total_districts,
    CASE 
      WHEN ps.total_seats > (tsa.total_districts / 2.0) THEN 'Winner'
      ELSE 'Loser'
    END AS result
  FROM party_seats ps
  CROSS JOIN total_seats_available tsa
)
SELECT 
  party_name,
  total_seats,
  result
FROM party_results
ORDER BY total_seats DESC;
```
