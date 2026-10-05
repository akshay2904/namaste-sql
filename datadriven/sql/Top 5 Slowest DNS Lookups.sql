-- ======================================================================
-- Top 5 Slowest DNS Lookups
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_5_slowest_dns_lookups
-- ======================================================================

/*
We are investigating DNS performance. Find the top 5 unique domain and record type pairs by their maximum latency. If pairs tie at the cutoff, include all of them. Rank from longest to shortest.

Table: dns_lookups(lookup_id, domain, rec_type, ttl_secs, status, latency, looked_at)

Sample data - dns_lookups ['lookup_id', 'domain', 'rec_type', 'ttl_secs', 'status', 'latency', 'looked_at']:
  [129, 'cdn.example.com', 'AAAA', 47, 'NXDOMAIN', 0.47, '2026-02-02 01:03:00']
  [158, 'auth.example.com', 'CNAME', 64, 'SERVFAIL', 0.84, '2026-03-03 02:06:00']
  [187, 'search.example.com', 'MX', 81, 'TIMEOUT', 1.21, '2026-04-04 03:09:00']
  [216, 'db.internal.net', 'TXT', 98, 'REFUSED', 1.58, '2026-05-05 04:12:00']
  [245, 'cache.internal.net', 'NS', 115, 'NOERROR', 1.95, '2026-06-06 05:15:00']

Expected output ['domain', 'rec_type', 'max_latency']:
  ['Cdn.Example.Com', 'MX', 36.73]
  ['API.example.com', 'CNAME', 36.36]
  ['www.example.com', 'AAAA', 35.99]
  ['example.com', 'A', 35.62]
  ['cache.internal.net', 'NS', 35.25]
*/


-- Write your SQL solution below:

WITH ranked AS (
  SELECT domain,
         rec_type,
         MAX(latency) AS max_latency,
         DENSE_RANK() OVER (ORDER BY MAX(latency) DESC) AS rnk
  FROM dns_lookups
  GROUP BY domain, rec_type
)
SELECT domain, rec_type, max_latency
FROM ranked
WHERE rnk <= 5
ORDER BY max_latency DESC, domain, rec_type;
