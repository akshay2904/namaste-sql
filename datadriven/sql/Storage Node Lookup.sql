-- ======================================================================
-- Storage Node Lookup
-- ======================================================================
-- Difficulty : Easy
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/storage_node_lookup
-- ======================================================================

/*
Find all nodes with a storage-type designation, along with each node's hostname and CPU percentage.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['hostname', 'cpu_pct']:
  ['api-01', 26]
  ['worker-01', None]
  ['web-01', 56]
  ['db-replica', 21]
  ['WEB-03', 86]
*/


-- Write your SQL solution below:

SELECT hostname, cpu_pct
FROM infra_nodes
WHERE LOWER(node_type) = 'storage'
