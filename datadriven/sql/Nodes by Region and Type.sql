-- ======================================================================
-- Nodes by Region and Type
-- ======================================================================
-- Difficulty : Medium
-- Company    : Apple
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/nodes_by_region_and_type
-- ======================================================================

/*
The capacity team is mapping fleet composition and needs node counts broken down by region and node type, listed alphabetically by region.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['region', 'node_type', 'node_count']:
  ['ap-south-1', 'gpu', 40]
  ['eu-central-1', 'general', 40]
  ['eu-west-1', 'storage', 40]
  ['us-east-1', 'compute', 40]
  ['us-west-2', 'memory', 40]
*/


-- Write your SQL solution below:

SELECT region, node_type, COUNT(*) AS node_count
FROM infra_nodes
GROUP BY region, node_type
ORDER BY region
