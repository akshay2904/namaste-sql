-- ======================================================================
-- Pod CPU to Memory Ratio
-- ======================================================================
-- Difficulty : Medium
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/pod_cpu_to_memory_ratio
-- ======================================================================

/*
For pending pods in each namespace, what is the average ratio of CPU used to memory used? Rank from highest ratio to lowest.

Table: k8s_pods(pod_id, pod_name, nspace, status, restarts, cpu_used, mem_used)

Sample data - k8s_pods ['pod_id', 'pod_name', 'nspace', 'status', 'restarts', 'cpu_used', 'mem_used']:
  [2043, 'payment-003ef', 'production', 'Pending', 0, 0.011, 37]
  [2086, 'search-003f6', 'staging', 'CrashLoopBackOff', 0, 0.022, 74]
  [2129, 'gateway-003fd', 'monitoring', 'Completed', 0, 0.033, 111]
  [2172, 'worker-00404', 'kube-system', 'Error', 0, 0.044, 148]
  [2215, 'cron-0040b', 'default', 'Terminating', 0, 0.055, 185]

Expected output ['nspace', 'avg_cpu_mem_ratio']:
  ['staging', 0.0002972972972972973]
  ['production', 0.0002972972972972973]
  ['monitoring', 0.00029729729729729726]
  ['kube-system', 0.00029729729729729726]
  ['default', 0.00029729729729729726]
*/


-- Write your SQL solution below:

SELECT
    nspace,
    AVG(cpu_used / mem_used) AS avg_cpu_mem_ratio
FROM k8s_pods
WHERE status = 'Pending'
  AND mem_used > 0
GROUP BY nspace
ORDER BY avg_cpu_mem_ratio DESC
