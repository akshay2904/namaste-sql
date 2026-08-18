-- ======================================================================
-- Lowest CPU Pods per Namespace
-- ======================================================================
-- Difficulty : Hard
-- Company    : City and County of San Francisco
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/lowest_cpu_pods_per_namespace
-- ======================================================================

/*
For each Kubernetes namespace, surface the 5 pods with the lowest CPU usage. If pods are tied, they should share the same rank without creating gaps. Show each pod's name, namespace, CPU, and memory usage.

Table: k8s_pods(pod_id, pod_name, nspace, status, restarts, cpu_used, mem_used)

Sample data - k8s_pods ['pod_id', 'pod_name', 'nspace', 'status', 'restarts', 'cpu_used', 'mem_used']:
  [2043, 'payment-003ef', 'production', 'Pending', 0, 0.011, 37]
  [2086, 'search-003f6', 'staging', 'CrashLoopBackOff', 0, 0.022, 74]
  [2129, 'gateway-003fd', 'monitoring', 'Completed', 0, 0.033, 111]
  [2172, 'worker-00404', 'kube-system', 'Error', 0, 0.044, 148]
  [2215, 'cron-0040b', 'default', 'Terminating', 0, 0.055, 185]

Expected output ['pod_name', 'nspace', 'cpu_used', 'mem_used']:
  ['ml-serve-004ba', 'default', None, None]
  ['auth-00490', 'kube-system', None, None]
  ['search-00466', 'monitoring', None, None]
  ['ml-serve-00412', 'production', None, None]
  ['worker-0043c', 'staging', None, None]
*/


-- Write your SQL solution below:

SELECT pod_name, nspace, cpu_used, mem_used
FROM (
    SELECT pod_name, nspace, cpu_used, mem_used,
        DENSE_RANK() OVER (PARTITION BY nspace ORDER BY cpu_used ASC) AS rnk
    FROM k8s_pods
) ranked
WHERE rnk <= 5
ORDER BY nspace, rnk
