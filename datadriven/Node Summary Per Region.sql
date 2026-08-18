-- ======================================================================
-- Node Summary Per Region
-- ======================================================================
-- Difficulty : Easy
-- Company    : Vesta Innovations
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/node_summary_per_region
-- ======================================================================

/*
The capacity planning team needs a region-level infrastructure summary. Show the total number of nodes and the number of unique node types per region, ranked by total nodes from highest to lowest.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['region', 'total_nodes', 'unique_types']:
  ['us-west-2', 40, 1]
  ['us-east-1', 40, 1]
  ['eu-west-1', 40, 1]
  ['eu-central-1', 40, 1]
  ['ap-south-1', 40, 1]
*/


-- Write your SQL solution below:

SELECT
    region,
    COUNT(*) AS total_nodes,
    COUNT(DISTINCT node_type) AS unique_types
FROM infra_nodes
GROUP BY region
ORDER BY total_nodes DESC
