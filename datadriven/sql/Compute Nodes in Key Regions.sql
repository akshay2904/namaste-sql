-- ======================================================================
-- Compute Nodes in Key Regions
-- ======================================================================
-- Difficulty : Easy
-- Company    : Forbes
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/compute_nodes_in_key_regions
-- ======================================================================

/*
The infrastructure team is auditing compute capacity in the primary US and EU regions. List all nodes classified as 'compute' in either 'us-east-1' or 'eu-west-1'.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']
  [1370, 'WEB-03', 'us-east-1', 'compute', 30, 90, 'Running']
  [1555, 'api-02', 'us-east-1', 'compute', 95, 85, 'offline']
  [1740, 'worker-02', 'us-east-1', 'compute', 60, 80, 'draining']
  [1925, 'web-02', 'us-east-1', 'compute', 25, 75, 'stopped']
*/


-- Write your SQL solution below:

SELECT *
FROM infra_nodes
WHERE node_type = 'compute'
  AND region IN ('us-east-1', 'eu-west-1')
