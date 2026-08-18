-- ======================================================================
-- The Loudest Neighbor
-- ======================================================================
-- Difficulty : Hard
-- Company    : Deloitte
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/peak_concurrent_pods
-- ======================================================================

/*
In our multi-tenant Kubernetes cluster we hunt the noisy neighbor in each namespace: the pod using the most memory. Some pods are still starting up and haven't reported memory yet, so ignore those and list each namespace's top consumer with its memory, heaviest first.

Table: k8s_pods(pod_id, pod_name, nspace, status, restarts, cpu_used, mem_used)

Sample data - k8s_pods ['pod_id', 'pod_name', 'nspace', 'status', 'restarts', 'cpu_used', 'mem_used']:
  [2043, 'payment-003ef', 'production', 'Pending', 0, 0.011, 37]
  [2086, 'search-003f6', 'staging', 'CrashLoopBackOff', 0, 0.022, 74]
  [2129, 'gateway-003fd', 'monitoring', 'Completed', 0, 0.033, 111]
  [2172, 'worker-00404', 'kube-system', 'Error', 0, 0.044, 148]
  [2215, 'cron-0040b', 'default', 'Terminating', 0, 0.055, 185]

Expected output ['nspace', 'pod_name', 'mem_used']:
  ['default', 'worker-006a4', 3700]
  ['kube-system', 'gateway-0069d', 3663]
  ['monitoring', 'search-00696', 3626]
  ['staging', 'payment-0068f', 3589]
  ['production', 'gateway-00665', 3367]
*/


-- Write your SQL solution below:

SELECT nspace,
       pod_name,
       mem_used
FROM (
  SELECT nspace,
         pod_name,
         mem_used,
         ROW_NUMBER() OVER (
           PARTITION BY nspace
           ORDER BY mem_used DESC, pod_name
         ) AS mem_rank
  FROM k8s_pods
  WHERE mem_used IS NOT NULL
) ranked
WHERE mem_rank = 1
ORDER BY mem_used DESC, nspace
