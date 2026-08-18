-- ======================================================================
-- Heavy Namespaces
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/heavy_namespaces
-- ======================================================================

/*
The SRE team suspects a few Kubernetes namespaces are absorbing most of the cluster's pod capacity. Show namespaces that have more than 3 pods along with their pod count.

Table: k8s_pods(pod_id, pod_name, nspace, status, restarts, cpu_used, mem_used)

Sample data - k8s_pods ['pod_id', 'pod_name', 'nspace', 'status', 'restarts', 'cpu_used', 'mem_used']:
  [2043, 'payment-003ef', 'production', 'Pending', 0, 0.011, 37]
  [2086, 'search-003f6', 'staging', 'CrashLoopBackOff', 0, 0.022, 74]
  [2129, 'gateway-003fd', 'monitoring', 'Completed', 0, 0.033, 111]
  [2172, 'worker-00404', 'kube-system', 'Error', 0, 0.044, 148]
  [2215, 'cron-0040b', 'default', 'Terminating', 0, 0.055, 185]

Expected output ['nspace', 'pod_count']:
  ['default', 40]
  ['kube-system', 40]
  ['monitoring', 40]
  ['production', 40]
  ['staging', 40]
*/


-- Write your SQL solution below:

SELECT nspace,
       COUNT(*) AS pod_count
FROM k8s_pods
GROUP BY nspace
HAVING COUNT(*) > 3
