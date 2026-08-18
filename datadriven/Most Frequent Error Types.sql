-- ======================================================================
-- Most Frequent Error Types
-- ======================================================================
-- Difficulty : Medium
-- Company    : Forbes
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/most_frequent_error_types
-- ======================================================================

/*
During an incident postmortem, on-call wants the error types showing up most often in the tracking table. Give the number of logged reports for each error type, from the most to the fewest.

Table: err_tracks(err_id, err_type, message, svc_name, severity, count, first_at)

Sample data - err_tracks ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at']:
  [137, 'TypeError', 'Cannot read property of undefined', 'payment-api', 'error', 8, '2026-02-02 01:11:00']
  [174, 'ConnectionTimeout', 'Connection timed out after 30s', 'user-svc', 'warning', 15, '2026-03-03 02:22:00']
  [211, 'OutOfMemory', 'Heap space exhausted', 'search-api', 'info', 22, '2026-04-04 03:33:00']
  [248, 'FileNotFound', 'File /tmp/data.csv not found', 'gateway', 'Fatal', 29, '2026-05-05 04:44:00']
  [285, 'PermissionDenied', 'Access denied for user root', 'worker', 'ERROR', 36, '2026-06-06 05:55:00']

Expected output ['err_type', 'err_count']:
  ['nullpointerexception', 20]
  ['TypeError', 20]
  ['TYPEERROR', 20]
  ['RateLimitExceeded', 20]
  ['PermissionDenied', 20]
*/


-- Write your SQL solution below:

SELECT
    err_type,
    COUNT(*) AS err_count
FROM err_tracks
GROUP BY err_type
ORDER BY err_count DESC
