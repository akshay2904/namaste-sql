-- ======================================================================
-- CPU Utilization Summary
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cpu_utilization_summary
-- ======================================================================

/*
The capacity planning team wants a one-line summary of fleet-wide CPU health: the minimum, average, and maximum CPU utilization across all infrastructure nodes.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['min_cpu', 'avg_cpu', 'max_cpu']:
  [0, 48.77906976744186, 99]
*/


-- Write your SQL solution below:

SELECT
    MIN(cpu_pct) AS min_cpu,
    AVG(cpu_pct) AS avg_cpu,
    MAX(cpu_pct) AS max_cpu
FROM infra_nodes
