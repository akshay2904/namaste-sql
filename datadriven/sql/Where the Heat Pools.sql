-- ======================================================================
-- Where the Heat Pools
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/satisfaction_score_by_region
-- ======================================================================

/*
The infra team is comparing CPU load across the node fleet by region. Show each region with its average CPU utilization, listed alphabetically.

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Table: k8s_pods(pod_id, pod_name, nspace, status, restarts, cpu_used, mem_used)

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Sample data - k8s_pods ['pod_id', 'pod_name', 'nspace', 'status', 'restarts', 'cpu_used', 'mem_used']:
  [2043, 'payment-003ef', 'production', 'Pending', 0, 0.011, 37]
  [2086, 'search-003f6', 'staging', 'CrashLoopBackOff', 0, 0.022, 74]
  [2129, 'gateway-003fd', 'monitoring', 'Completed', 0, 0.033, 111]
  [2172, 'worker-00404', 'kube-system', 'Error', 0, 0.044, 148]
  [2215, 'cron-0040b', 'default', 'Terminating', 0, 0.055, 185]

Expected output ['region', 'avg_cpu']:
  ['ap-south-1', 51.35294117647059]
  ['eu-central-1', 45.8235294117647]
  ['eu-west-1', 48.94117647058823]
  ['us-east-1', 49.166666666666664]
  ['us-west-2', 48.588235294117645]
*/


-- Write your SQL solution below:

SELECT region, AVG(cpu_pct) AS avg_cpu
FROM infra_nodes
GROUP BY region
ORDER BY region;
