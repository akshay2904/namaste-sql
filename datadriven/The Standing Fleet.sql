-- ======================================================================
-- The Standing Fleet
-- ======================================================================
-- Difficulty : Easy
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/unique_hosts_by_node_type
-- ======================================================================

/*
We're taking inventory of the `compute`, `storage`, and `gpu` tiers of our node fleet. Count how many different hosts run across those tiers, counting a host that appears in more than one tier only once.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['unique_hosts']:
  [12]
*/


-- Write your SQL solution below:

SELECT COUNT(DISTINCT hostname) AS unique_hosts
FROM infra_nodes
WHERE node_type IN ('compute', 'storage', 'gpu')
