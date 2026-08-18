-- ======================================================================
-- Regions With 5+ Nodes
-- ======================================================================
-- Difficulty : Easy
-- Company    : Burtch Works
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/regions_with_5_nodes
-- ======================================================================

/*
The infrastructure team is enforcing a minimum cluster size policy: any region with fewer than 5 running nodes needs additional provisioning. Show the regions that already meet the threshold.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['region', 'node_count']:
  ['ap-south-1', 12]
  ['eu-central-1', 14]
  ['eu-west-1', 12]
  ['us-east-1', 14]
  ['us-west-2', 14]
*/


-- Write your SQL solution below:

SELECT region, COUNT(*) AS node_count
FROM infra_nodes
WHERE LOWER(status) = 'running'
GROUP BY region
HAVING COUNT(*) >= 5
