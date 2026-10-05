-- ======================================================================
-- The Footprint
-- ======================================================================
-- Difficulty : Medium
-- Company    : Forbes
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/region_with_most_nodes
-- ======================================================================

/*
Capacity planning is reviewing how the server fleet spreads across regions. Show the node count for each region, from the most to the fewest.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['region', 'node_count']:
  ['ap-south-1', 40]
  ['eu-central-1', 40]
  ['eu-west-1', 40]
  ['us-east-1', 40]
  ['us-west-2', 40]
*/


-- Write your SQL solution below:

SELECT region, COUNT(*) AS node_count
FROM infra_nodes
GROUP BY region
ORDER BY node_count DESC, region
