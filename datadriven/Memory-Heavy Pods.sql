-- ======================================================================
-- Memory-Heavy Pods
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/memory_heavy_pods
-- ======================================================================

/*
The SRE team is profiling mid-range memory consumers across the Kubernetes cluster. Pull all unique pod names where memory usage falls between 100 and 500.

Table: k8s_pods(pod_id, pod_name, nspace, status, restarts, cpu_used, mem_used)

Sample data - k8s_pods ['pod_id', 'pod_name', 'nspace', 'status', 'restarts', 'cpu_used', 'mem_used']:
  [2043, 'payment-003ef', 'production', 'Pending', 0, 0.011, 37]
  [2086, 'search-003f6', 'staging', 'CrashLoopBackOff', 0, 0.022, 74]
  [2129, 'gateway-003fd', 'monitoring', 'Completed', 0, 0.033, 111]
  [2172, 'worker-00404', 'kube-system', 'Error', 0, 0.044, 148]
  [2215, 'cron-0040b', 'default', 'Terminating', 0, 0.055, 185]

Expected output ['pod_name']:
  ['gateway-003fd']
  ['worker-00404']
  ['cron-0040b']
  ['cache-00419']
  ['auth-00420']
*/


-- Write your SQL solution below:

SELECT DISTINCT pod_name
FROM k8s_pods
WHERE mem_used BETWEEN 100 AND 500
