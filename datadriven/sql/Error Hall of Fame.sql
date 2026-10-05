-- ======================================================================
-- Error Hall of Fame
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/error_hall_of_fame
-- ======================================================================

/*
The error_logs table captures events from 2025. Show each error type and how many times it occurred, sorted from most frequent to least.

Table: err_tracks(err_id, err_type, message, svc_name, severity, count, first_at)

Sample data - err_tracks ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at']:
  [137, 'TypeError', 'Cannot read property of undefined', 'payment-api', 'error', 8, '2026-02-02 01:11:00']
  [174, 'ConnectionTimeout', 'Connection timed out after 30s', 'user-svc', 'warning', 15, '2026-03-03 02:22:00']
  [211, 'OutOfMemory', 'Heap space exhausted', 'search-api', 'info', 22, '2026-04-04 03:33:00']
  [248, 'FileNotFound', 'File /tmp/data.csv not found', 'gateway', 'Fatal', 29, '2026-05-05 04:44:00']
  [285, 'PermissionDenied', 'Access denied for user root', 'worker', 'ERROR', 36, '2026-06-06 05:55:00']

Expected output ['error_type', 'occurrences']:
  ['typeerror', 39489]
  ['nullpointerexception', 34252]
  ['connectiontimeout', 19370]
  ['permissiondenied', 18765]
  ['parseerror', 18553]
*/


-- Write your SQL solution below:

SELECT
  LOWER(err_type) AS error_type,
  SUM(count)      AS occurrences
FROM err_tracks
GROUP BY LOWER(err_type)
ORDER BY occurrences DESC, error_type ASC;
