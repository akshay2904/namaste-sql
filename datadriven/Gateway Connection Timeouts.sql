-- ======================================================================
-- Gateway Connection Timeouts
-- ======================================================================
-- Difficulty : Easy
-- Company    : TripAdvisor
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/gateway_connection_timeouts
-- ======================================================================

/*
During an on-call investigation, find all error tracking entries where the service name contains 'gateway' and the message contains the phrase 'timed out'.

Table: err_tracks(err_id, err_type, message, svc_name, severity, count, first_at)

Sample data - err_tracks ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at']:
  [137, 'TypeError', 'Cannot read property of undefined', 'payment-api', 'error', 8, '2026-02-02 01:11:00']
  [174, 'ConnectionTimeout', 'Connection timed out after 30s', 'user-svc', 'warning', 15, '2026-03-03 02:22:00']
  [211, 'OutOfMemory', 'Heap space exhausted', 'search-api', 'info', 22, '2026-04-04 03:33:00']
  [248, 'FileNotFound', 'File /tmp/data.csv not found', 'gateway', 'Fatal', 29, '2026-05-05 04:44:00']
  [285, 'PermissionDenied', 'Access denied for user root', 'worker', 'ERROR', 36, '2026-06-06 05:55:00']

Expected output ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at']:
  [914, 'ConnectionTimeout', 'Connection timed out after 30s', 'gateway', 'Fatal', 155, '2026-11-23 22:02:00']
  [2024, 'ConnectionTimeout', 'Connection timed out after 30s', 'gateway', 'Fatal', 365, '2026-05-25 04:32:00']
  [3134, 'ConnectionTimeout', 'Connection timed out after 30s', 'gateway', 'Fatal', 575, '2026-11-27 10:02:00']
*/


-- Write your SQL solution below:

SELECT *
FROM err_tracks
WHERE svc_name LIKE '%gateway%'
  AND message LIKE '%timed out%'
