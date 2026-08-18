-- ======================================================================
-- Top 10 CPU-Heavy Nodes
-- ======================================================================
-- Difficulty : Medium
-- Company    : Asana
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_10_cpu_heavy_nodes
-- ======================================================================

/*
Our infrastructure metrics table tracks CPU usage per node. Show the ten nodes consuming the most CPU, with their node ID, hostname, and CPU percentage, sorted from highest utilization to lowest.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['node_id', 'hostname', 'cpu_pct']:
  [1851, 'Api-03', 99]
  [2702, 'WEB-03', 98]
  [3553, 'gpu-node-01', 97]
  [4404, 'worker-02', 96]
  [1555, 'api-02', 95]
*/


-- Write your SQL solution below:

SELECT node_id, hostname, cpu_pct FROM infra_nodes ORDER BY cpu_pct DESC, node_id ASC LIMIT 10
