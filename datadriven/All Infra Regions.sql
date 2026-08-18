-- ======================================================================
-- All Infra Regions
-- ======================================================================
-- Difficulty : Easy
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/all_infra_regions
-- ======================================================================

/*
Before provisioning a new availability zone, the infrastructure team needs to know which regions already have node presence. Pull a deduplicated list of every region currently represented in the node inventory.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['region']:
  ['ap-south-1']
  ['eu-central-1']
  ['eu-west-1']
  ['us-east-1']
  ['us-west-2']
*/


-- Write your SQL solution below:

SELECT DISTINCT region
FROM infra_nodes
ORDER BY region
