-- ======================================================================
-- Overloaded Infrastructure Nodes
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/overloaded_infrastructure_nodes
-- ======================================================================

/*
A node is considered overloaded if its CPU exceeds 90% or its memory exceeds 85%. Surface each unique overloaded node's hostname, region, and node type.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['hostname', 'region', 'node_type']:
  ['db-replica', 'us-east-1', 'compute']
  ['Api-03', 'ap-south-1', 'gpu']
  ['api-01', 'us-west-2', 'memory']
  ['Api-03', 'eu-west-1', 'storage']
  ['gpu-node-01', 'eu-central-1', 'general']
*/


-- Write your SQL solution below:

SELECT DISTINCT hostname, region, node_type
FROM infra_nodes
WHERE cpu_pct > 90 OR mem_pct > 85
