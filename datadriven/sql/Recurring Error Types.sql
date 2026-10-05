-- ======================================================================
-- Recurring Error Types
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/recurring_error_types
-- ======================================================================

/*
After the latest incident, the on-call SRE needs to identify recurring error types. Find all error types that appear more than once. Show just the error type.

Table: err_tracks(err_id, err_type, message, svc_name, severity, count, first_at)

Sample data - err_tracks ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at']:
  [137, 'TypeError', 'Cannot read property of undefined', 'payment-api', 'error', 8, '2026-02-02 01:11:00']
  [174, 'ConnectionTimeout', 'Connection timed out after 30s', 'user-svc', 'warning', 15, '2026-03-03 02:22:00']
  [211, 'OutOfMemory', 'Heap space exhausted', 'search-api', 'info', 22, '2026-04-04 03:33:00']
  [248, 'FileNotFound', 'File /tmp/data.csv not found', 'gateway', 'Fatal', 29, '2026-05-05 04:44:00']
  [285, 'PermissionDenied', 'Access denied for user root', 'worker', 'ERROR', 36, '2026-06-06 05:55:00']

Expected output ['err_type']:
  ['ConnectionTimeout']
  ['FileNotFound']
  ['NullPointerException']
  ['OutOfMemory']
  ['ParseError']
*/


-- Write your SQL solution below:

SELECT err_type
FROM err_tracks
GROUP BY err_type
HAVING COUNT(*) > 1
