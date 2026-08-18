-- ======================================================================
-- First and Last Timeout Per Service
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/first_and_last_timeout_per_service
-- ======================================================================

/*
Surface the first and last times each service experienced a connection timeout. Only look at error messages that mention 'timed out', and results should be ordered by service name.

Table: err_tracks(err_id, err_type, message, svc_name, severity, count, first_at)

Sample data - err_tracks ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at']:
  [137, 'TypeError', 'Cannot read property of undefined', 'payment-api', 'error', 8, '2026-02-02 01:11:00']
  [174, 'ConnectionTimeout', 'Connection timed out after 30s', 'user-svc', 'warning', 15, '2026-03-03 02:22:00']
  [211, 'OutOfMemory', 'Heap space exhausted', 'search-api', 'info', 22, '2026-04-04 03:33:00']
  [248, 'FileNotFound', 'File /tmp/data.csv not found', 'gateway', 'Fatal', 29, '2026-05-05 04:44:00']
  [285, 'PermissionDenied', 'Access denied for user root', 'worker', 'ERROR', 36, '2026-06-06 05:55:00']

Expected output ['svc_name', 'earliest_timeout', 'latest_timeout']:
  ['auth-svc', '2026-01-13 12:12:00', '2026-07-15 18:42:00']
  ['gateway', '2026-05-25 04:32:00', '2026-11-27 10:02:00']
  ['payment-api', '2026-01-09 00:00:00', '2026-07-11 06:30:00']
  ['search-api', '2026-03-03 02:50:00', '2026-09-05 08:20:00']
  ['user-svc', '2026-03-03 02:22:00', '2026-09-09 20:52:00']
*/


-- Write your SQL solution below:

SELECT
  svc_name,
  MIN(first_at) AS earliest_timeout,
  MAX(first_at) AS latest_timeout
FROM err_tracks
WHERE message LIKE '%timed out%'
GROUP BY svc_name
ORDER BY svc_name;
