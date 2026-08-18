-- ======================================================================
-- Average GPU Node CPU Usage
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_gpu_node_cpu_usage
-- ======================================================================

/*
The ML training cluster has been throttling jobs and the infrastructure team suspects the GPU nodes are saturated. What is the average CPU percentage across all infrastructure nodes classified as 'gpu'?

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['avg_cpu_pct']:
  [51.35294117647059]
*/


-- Write your SQL solution below:

SELECT AVG(cpu_pct) AS avg_cpu_pct
FROM infra_nodes
WHERE node_type = 'gpu';
