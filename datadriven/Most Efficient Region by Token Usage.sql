-- ======================================================================
-- Most Efficient Region by Token Usage
-- ======================================================================
-- Difficulty : Hard
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/most_efficient_region_by_token_usage
-- ======================================================================

/*
Our API tokens have issued and expiration dates plus a request count. For each region, compute the average token lifetime in days (expires minus issued) and the average number of requests. Then calculate the ratio of average requests to average lifetime, ranked highest first. Return the region, average lifetime in days, average requests, and the requests-per-day ratio.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['region', 'avg_lifetime_days', 'avg_requests', 'requests_per_day_ratio']:
  ['full_access', 365, 2465.3636363636365, 6.7544209215442095]
  ['admin', 365, 2339.153846153846, 6.408640674394099]
  ['read', 365, 2165.9166666666665, 5.934018264840182]
  ['read:analytics', 365, 2157.7272727272725, 5.911581569115815]
  ['write', 365, 2039.076923076923, 5.586512118018967]
*/


-- Write your SQL solution below:

SELECT
  scope AS region,
  CAST(AVG(JULIANDAY(expires) - JULIANDAY(issued)) AS REAL) AS avg_lifetime_days,
  AVG(requests) AS avg_requests,
  CAST(AVG(requests) AS REAL)
    / CAST(AVG(JULIANDAY(expires) - JULIANDAY(issued)) AS REAL)
    AS requests_per_day_ratio
FROM api_tokens
WHERE expires IS NOT NULL
GROUP BY scope
ORDER BY requests_per_day_ratio DESC;
