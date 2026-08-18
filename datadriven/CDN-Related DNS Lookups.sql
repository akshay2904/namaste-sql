-- ======================================================================
-- CDN-Related DNS Lookups
-- ======================================================================
-- Difficulty : Easy
-- Company    : Oracle
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cdn_related_dns_lookups
-- ======================================================================

/*
The network team is tracking down CDN-related DNS resolution issues. Pull all lookup records where the domain contains 'cdn' regardless of casing, ordered by domain.

Table: dns_lookups(lookup_id, domain, rec_type, ttl_secs, status, latency, looked_at)

Sample data - dns_lookups ['lookup_id', 'domain', 'rec_type', 'ttl_secs', 'status', 'latency', 'looked_at']:
  [129, 'cdn.example.com', 'AAAA', 47, 'NXDOMAIN', 0.47, '2026-02-02 01:03:00']
  [158, 'auth.example.com', 'CNAME', 64, 'SERVFAIL', 0.84, '2026-03-03 02:06:00']
  [187, 'search.example.com', 'MX', 81, 'TIMEOUT', 1.21, '2026-04-04 03:09:00']
  [216, 'db.internal.net', 'TXT', 98, 'REFUSED', 1.58, '2026-05-05 04:12:00']
  [245, 'cache.internal.net', 'NS', 115, 'NOERROR', 1.95, '2026-06-06 05:15:00']

Expected output ['lookup_id', 'domain', 'rec_type', 'ttl_secs', 'status', 'latency', 'looked_at']:
  [361, 'Cdn.Example.Com', 'MX', 183, 'REFUSED', 3.43, '2026-10-10 09:27:00']
  [651, 'Cdn.Example.Com', 'AAAA', 353, 'REFUSED', 7.13, '2026-08-20 19:57:00']
  [941, 'Cdn.Example.Com', 'NS', 523, 'REFUSED', 10.83, '2026-06-02 05:27:00']
  [129, 'cdn.example.com', 'AAAA', 47, 'NXDOMAIN', 0.47, '2026-02-02 01:03:00']
  [419, 'cdn.example.com', 'NS', 217, 'NXDOMAIN', 4.17, '2026-12-12 11:33:00']
*/


-- Write your SQL solution below:

SELECT *
FROM dns_lookups
WHERE LOWER(domain) LIKE '%cdn%'
ORDER BY domain
