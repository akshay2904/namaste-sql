-- ======================================================================
-- Top Regions by High CPU Nodes
-- ======================================================================
-- Difficulty : Hard
-- Company    : Yelp
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_regions_by_high_cpu_nodes
-- ======================================================================

/*
Capacity planning wants to know which regions have the most overloaded nodes. Return the top 5 regions by count of nodes running above 90% CPU. If regions are tied, they share the same rank without gaps. Include all regions within the top 5 ranks with their high-CPU node count.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['region', 'total_cpu_pct']:
  ['us-east-1', 1770]
  ['ap-south-1', 1746]
  ['eu-west-1', 1664]
  ['us-west-2', 1652]
  ['eu-central-1', 1558]
*/


-- Write your SQL solution below:

SELECT
    region,
    SUM(cpu_pct) AS total_cpu_pct
FROM infra_nodes
GROUP BY region
ORDER BY total_cpu_pct DESC
LIMIT 10
