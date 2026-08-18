-- ======================================================================
-- Top CPU Pods per Namespace
-- ======================================================================
-- Difficulty : Hard
-- Company    : City and County of San Francisco
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_cpu_pods_per_namespace
-- ======================================================================

/*
Pivot the two highest-CPU pods in each namespace so each row is a namespace with its top and second-place pod names as separate columns.

Table: k8s_pods(pod_id, pod_name, nspace, status, restarts, cpu_used, mem_used)

Sample data - k8s_pods ['pod_id', 'pod_name', 'nspace', 'status', 'restarts', 'cpu_used', 'mem_used']:
  [2043, 'payment-003ef', 'production', 'Pending', 0, 0.011, 37]
  [2086, 'search-003f6', 'staging', 'CrashLoopBackOff', 0, 0.022, 74]
  [2129, 'gateway-003fd', 'monitoring', 'Completed', 0, 0.033, 111]
  [2172, 'worker-00404', 'kube-system', 'Error', 0, 0.044, 148]
  [2215, 'cron-0040b', 'default', 'Terminating', 0, 0.055, 185]

Expected output ['nspace', 'highest_cpu_pod', 'second_highest_cpu_pod']:
  ['default', 'worker-006a4', 'cache-00681']
  ['kube-system', 'gateway-0069d', 'ml-serve-0067a']
  ['monitoring', 'search-00696', 'cron-00673']
  ['production', 'gateway-00665', 'ml-serve-00642']
  ['staging', 'payment-0068f', 'worker-0066c']
*/


-- Write your SQL solution below:

WITH pod_cpu AS (
    SELECT nspace, pod_name, MAX(cpu_used) AS cpu_used
    FROM k8s_pods
    GROUP BY nspace, pod_name
),
ranked AS (
    SELECT nspace, pod_name, cpu_used,
           ROW_NUMBER() OVER (
               PARTITION BY nspace
               ORDER BY cpu_used DESC, pod_name ASC
           ) AS rn
    FROM pod_cpu
)
SELECT nspace,
       MAX(CASE WHEN rn = 1 THEN pod_name END) AS highest_cpu_pod,
       MAX(CASE WHEN rn = 2 THEN pod_name END) AS second_highest_cpu_pod
FROM ranked
WHERE rn <= 2
GROUP BY nspace
ORDER BY nspace
