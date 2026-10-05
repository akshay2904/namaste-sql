-- ======================================================================
-- The Stable and the Restless
-- ======================================================================
-- Difficulty : Easy
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/pod_distribution_by_restart_count
-- ======================================================================

/*
The reliability team is auditing pods that have never restarted. Break those down by status, showing how many fall into each, most common first.

Table: k8s_pods(pod_id, pod_name, nspace, status, restarts, cpu_used, mem_used)

Sample data - k8s_pods ['pod_id', 'pod_name', 'nspace', 'status', 'restarts', 'cpu_used', 'mem_used']:
  [2043, 'payment-003ef', 'production', 'Pending', 0, 0.011, 37]
  [2086, 'search-003f6', 'staging', 'CrashLoopBackOff', 0, 0.022, 74]
  [2129, 'gateway-003fd', 'monitoring', 'Completed', 0, 0.033, 111]
  [2172, 'worker-00404', 'kube-system', 'Error', 0, 0.044, 148]
  [2215, 'cron-0040b', 'default', 'Terminating', 0, 0.055, 185]

Expected output ['status', 'pod_count']:
  ['CrashLoopBackOff', 32]
  ['Pending', 32]
  ['Completed', 30]
  ['Error', 30]
  ['Terminating', 28]
*/


-- Write your SQL solution below:

SELECT status, COUNT(*) AS pod_count
FROM k8s_pods
WHERE restarts = 0
GROUP BY status
ORDER BY pod_count DESC, status
