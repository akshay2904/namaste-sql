-- ======================================================================
-- Hottest Regions by CPU
-- ======================================================================
-- Difficulty : Medium
-- Company    : Visa
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/highest_node_density_regions
-- ======================================================================

/*
Capacity planning wants the three regions running hottest on average. For each region, compute the average CPU percentage across its nodes, and return the top 3 regions by that average, highest first.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['region', 'avg_cpu']:
  ['ap-south-1', 51.35]
  ['us-east-1', 49.17]
  ['eu-west-1', 48.94]
*/


-- Write your SQL solution below:

SELECT region, ROUND(AVG(cpu_pct),2) AS avg_cpu FROM infra_nodes GROUP BY region ORDER BY avg_cpu DESC LIMIT 3
