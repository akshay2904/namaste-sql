-- ======================================================================
-- When It Rains
-- ======================================================================
-- Difficulty : Medium
-- Company    : Lyft
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/rows_with_multiple_flag_conditions
-- ======================================================================

/*
The SRE team is hunting compound failures, the records where several independent alarms trip at once. Surface every error record where at least two of these markers appear: 'Error' in the type name, 'null' in the message, 'api' in the service name, or a severity of 'error' or 'ERROR'.

Table: err_tracks(err_id, err_type, message, svc_name, severity, count, first_at)

Sample data - err_tracks ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at']:
  [137, 'TypeError', 'Cannot read property of undefined', 'payment-api', 'error', 8, '2026-02-02 01:11:00']
  [174, 'ConnectionTimeout', 'Connection timed out after 30s', 'user-svc', 'warning', 15, '2026-03-03 02:22:00']
  [211, 'OutOfMemory', 'Heap space exhausted', 'search-api', 'info', 22, '2026-04-04 03:33:00']
  [248, 'FileNotFound', 'File /tmp/data.csv not found', 'gateway', 'Fatal', 29, '2026-05-05 04:44:00']
  [285, 'PermissionDenied', 'Access denied for user root', 'worker', 'ERROR', 36, '2026-06-06 05:55:00']

Expected output ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at']:
  [137, 'TypeError', 'Cannot read property of undefined', 'payment-api', 'error', 8, '2026-02-02 01:11:00']
  [359, 'ParseError', 'Malformed JSON in request body', 'payment-api', 'error', 50, '2026-08-08 07:17:00']
  [433, 'TYPEERROR', 'Division by zero', 'search-api', 'info', 64, '2026-10-10 09:39:00']
  [581, 'OutOfMemory', 'Heap space exhausted', 'payment-api', 'error', 92, '2026-02-14 13:23:00']
  [1025, 'PermissionDenied', 'Access denied for user root', 'payment-api', 'error', 176, '2026-02-26 01:35:00']
*/


-- Write your SQL solution below:

SELECT err_id, err_type, message, svc_name, severity, count, first_at
FROM err_tracks
WHERE (CASE WHEN err_type LIKE '%Error%' THEN 1 ELSE 0 END
     + CASE WHEN message LIKE '%null%' THEN 1 ELSE 0 END
     + CASE WHEN svc_name LIKE '%api%' THEN 1 ELSE 0 END
     + CASE WHEN severity IN ('error', 'ERROR') THEN 1 ELSE 0 END) > 1
