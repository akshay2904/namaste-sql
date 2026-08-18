-- ======================================================================
-- Average Node CPU by Region
-- ======================================================================
-- Difficulty : Easy
-- Company    : phData
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_node_cpu_by_region
-- ======================================================================

/*
Capacity planning is evaluating whether to add nodes in specific regions, but they only care about regions that are actually running workloads. Using the pod assignment records, show the average CPU utilization of nodes in each region where at least one pod has been scheduled.

Table: pod_assignments(assignment_id, node_id, pod_id, svc_name, assigned_at, status)

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - pod_assignments ['assignment_id', 'node_id', 'pod_id', 'svc_name', 'assigned_at', 'status']:
  [8047, 1148, 2344, 'payment-api', '2026-02-02 01:11:00', 'draining']
  [8094, 1259, 2645, 'user-svc', '2026-03-03 02:22:00', 'pending']
  [8141, 1370, 2946, 'search-api', '2026-04-04 03:33:00', 'terminated']
  [8188, 1481, 3247, 'gateway', '2026-05-05 04:44:00', 'Active']
  [8235, 1592, 3548, 'notif-svc', '2026-06-06 05:55:00', 'ACTIVE']

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['region', 'avg_cpu']:
  ['ap-south-1', 51.35294117647059]
  ['us-east-1', 49.166666666666664]
  ['eu-west-1', 48.94117647058823]
  ['us-west-2', 48.588235294117645]
  ['eu-central-1', 45.8235294117647]
*/


-- Write your SQL solution below:

SELECT n.region, AVG(n.cpu_pct) AS avg_cpu
FROM infra_nodes n
WHERE n.node_id IN (SELECT node_id FROM pod_assignments)
GROUP BY n.region
ORDER BY avg_cpu DESC, n.region;
