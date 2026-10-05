-- ======================================================================
-- Unique Hostnames per Region
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/unique_hostnames_per_region
-- ======================================================================

/*
Our infrastructure inventory uses hostnames that share prefixes. Count unique hostnames per region, using only the first word of the hostname (case insensitive), so entries like 'web-server-01' and 'Web-server-02' share the same prefix. If reversed forms exist (like 'prod-db' and 'db-prod'), count them as the same. Return results by count descending, then region ascending.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['region', 'unique_hostname_count']:
  ['ap-south-1', 6]
  ['eu-central-1', 6]
  ['eu-west-1', 6]
  ['us-east-1', 6]
  ['us-west-2', 6]
*/


-- Write your SQL solution below:

WITH base AS (
  SELECT DISTINCT
         region,
         LOWER(hostname) AS h,
         LOWER(SUBSTR(hostname, 1, INSTR(hostname, '-') - 1)) AS first_word,
         LOWER(SUBSTR(hostname, INSTR(hostname, '-') + 1))    AS rest
  FROM infra_nodes
  WHERE INSTR(hostname, '-') > 0
),
canon AS (
  SELECT
    b.region,
    CASE
      WHEN EXISTS (
        SELECT 1 FROM base r
        WHERE r.h = b.rest || '-' || b.first_word
      )
      THEN MIN(b.first_word, b.rest)
      ELSE b.first_word
    END AS prefix_word
  FROM base b
)
SELECT region, COUNT(DISTINCT prefix_word) AS unique_hostname_count
FROM canon
GROUP BY region
ORDER BY unique_hostname_count DESC, region ASC
