-- ======================================================================
-- Top Error-Service Pair
-- ======================================================================
-- Difficulty : Medium
-- Company    : Merilytics
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_error_service_pair
-- ======================================================================

/*
During an incident postmortem, you need to find the error-service combination responsible for the most resolved incidents. Build an identifier by combining the error type and service name from the error tracker, then count how many unique errors that combination produced where the corresponding alert was eventually resolved. Return only the top-ranked combinations, including ties, sequenced alphabetically.

Table: err_tracks(err_id, err_type, message, svc_name, severity, count, first_at)

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Sample data - err_tracks ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at']:
  [137, 'TypeError', 'Cannot read property of undefined', 'payment-api', 'error', 8, '2026-02-02 01:11:00']
  [174, 'ConnectionTimeout', 'Connection timed out after 30s', 'user-svc', 'warning', 15, '2026-03-03 02:22:00']
  [211, 'OutOfMemory', 'Heap space exhausted', 'search-api', 'info', 22, '2026-04-04 03:33:00']
  [248, 'FileNotFound', 'File /tmp/data.csv not found', 'gateway', 'Fatal', 29, '2026-05-05 04:44:00']
  [285, 'PermissionDenied', 'Access denied for user root', 'worker', 'ERROR', 36, '2026-06-06 05:55:00']

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['reporter_identity', 'distinct_errors']:
  ['ConnectionTimeout-auth-svc', 7]
  ['ConnectionTimeout-user-svc', 7]
  ['FileNotFound-gateway', 7]
  ['FileNotFound-user-svc', 7]
  ['NullPointerException-gateway', 7]
*/


-- Write your SQL solution below:

SELECT reporter_identity, distinct_errors
FROM (
  SELECT e.err_type || '-' || e.svc_name AS reporter_identity,
         COUNT(DISTINCT e.err_id) AS distinct_errors,
         RANK() OVER (ORDER BY COUNT(DISTINCT e.err_id) DESC) AS rnk
  FROM err_tracks e
  JOIN alert_events a ON e.svc_name = a.svc_name
  WHERE a.resolved IS NOT NULL
  GROUP BY e.err_type || '-' || e.svc_name
) ranked
WHERE rnk = 1
ORDER BY reporter_identity
