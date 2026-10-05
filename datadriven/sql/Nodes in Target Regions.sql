-- ======================================================================
-- Nodes in Target Regions
-- ======================================================================
-- Difficulty : Easy
-- Company    : Vesta Innovations
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/nodes_in_target_regions
-- ======================================================================

/*
A cross-region latency audit needs the full node record for every infrastructure node in 'us-east-1', 'us-west-2', or 'eu-west-1'.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']
  [1222, 'cache-01', 'us-west-2', 'memory', 78, 14, 'running']
  [1259, 'worker-01', 'eu-west-1', 'storage', None, None, 'stopped']
*/


-- Write your SQL solution below:

SELECT *
FROM infra_nodes
WHERE region IN ('us-east-1', 'us-west-2', 'eu-west-1')
