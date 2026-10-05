-- ======================================================================
-- Average Node Utilization
-- ======================================================================
-- Difficulty : Easy
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_node_utilization
-- ======================================================================

/*
The quarterly capacity review is tomorrow and the VP wants a utilization heatmap by region and node type. Show average CPU and memory utilization for each combination so the team can spot over- and under-provisioned segments.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['region', 'node_type', 'avg_cpu_pct', 'avg_mem_pct']:
  ['ap-south-1', 'gpu', 51.35294117647059, 47]
  ['eu-central-1', 'general', 45.8235294117647, 45.705882352941174]
  ['eu-west-1', 'storage', 48.94117647058823, 48]
  ['us-east-1', 'compute', 49.166666666666664, 47.5]
  ['us-west-2', 'memory', 48.588235294117645, 49.294117647058826]
*/


-- Write your SQL solution below:

SELECT
    region,
    node_type,
    AVG(cpu_pct) AS avg_cpu_pct,
    AVG(mem_pct) AS avg_mem_pct
FROM infra_nodes
GROUP BY region, node_type
