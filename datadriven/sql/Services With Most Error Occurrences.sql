-- ======================================================================
-- Services With Most Error Occurrences
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/services_with_most_error_occurrences
-- ======================================================================

/*
For each service in 2026, surface its peak error count, sorted from most to least.

Table: err_tracks(err_id, err_type, message, svc_name, severity, count, first_at)

Sample data - err_tracks ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at']:
  [137, 'TypeError', 'Cannot read property of undefined', 'payment-api', 'error', 8, '2026-02-02 01:11:00']
  [174, 'ConnectionTimeout', 'Connection timed out after 30s', 'user-svc', 'warning', 15, '2026-03-03 02:22:00']
  [211, 'OutOfMemory', 'Heap space exhausted', 'search-api', 'info', 22, '2026-04-04 03:33:00']
  [248, 'FileNotFound', 'File /tmp/data.csv not found', 'gateway', 'Fatal', 29, '2026-05-05 04:44:00']
  [285, 'PermissionDenied', 'Access denied for user root', 'worker', 'ERROR', 36, '2026-06-06 05:55:00']

Expected output ['svc_name', 'max_error_count']:
  ['search-api', 2201]
  ['user-svc', 2190]
  ['payment-api', 2179]
  ['auth-svc', 2168]
  ['worker', 2157]
*/


-- Write your SQL solution below:

SELECT svc_name, MAX(count) AS max_error_count
FROM err_tracks
WHERE strftime('%Y', first_at) = '2026'
GROUP BY svc_name
ORDER BY max_error_count DESC
