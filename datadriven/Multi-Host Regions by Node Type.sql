-- ======================================================================
-- Multi-Host Regions by Node Type
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/multi_host_regions_by_node_type
-- ======================================================================

/*
The capacity planning team is assessing regional infrastructure density. Which regions have more than 2 unique hostnames across compute, storage, network, and GPU node types?

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['region']:
  ['ap-south-1']
  ['eu-west-1']
  ['us-east-1']
*/


-- Write your SQL solution below:

SELECT region
FROM infra_nodes
WHERE node_type IN ('compute', 'storage', 'network', 'gpu')
GROUP BY region
HAVING COUNT(DISTINCT hostname) > 2
ORDER BY region
