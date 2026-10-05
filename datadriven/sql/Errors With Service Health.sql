-- ======================================================================
-- Errors With Service Health
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/errors_with_service_health
-- ======================================================================

/*
For each error record, pair it with the corresponding service's current status, latency, and uptime from the service health table. Include the error ID, error type, message, service name, severity, count, first occurrence, service status, latency, and uptime.

Table: err_tracks(err_id, err_type, message, svc_name, severity, count, first_at)

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - err_tracks ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at']:
  [137, 'TypeError', 'Cannot read property of undefined', 'payment-api', 'error', 8, '2026-02-02 01:11:00']
  [174, 'ConnectionTimeout', 'Connection timed out after 30s', 'user-svc', 'warning', 15, '2026-03-03 02:22:00']
  [211, 'OutOfMemory', 'Heap space exhausted', 'search-api', 'info', 22, '2026-04-04 03:33:00']
  [248, 'FileNotFound', 'File /tmp/data.csv not found', 'gateway', 'Fatal', 29, '2026-05-05 04:44:00']
  [285, 'PermissionDenied', 'Access denied for user root', 'worker', 'ERROR', 36, '2026-06-06 05:55:00']

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at', 'status', 'latency', 'uptime']:
  [137, 'TypeError', 'Cannot read property of undefined', 'payment-api', 'error', 8, '2026-02-02 01:11:00', 'DEGRADED', 34.6, None]
  [174, 'ConnectionTimeout', 'Connection timed out after 30s', 'user-svc', 'warning', 15, '2026-03-03 02:22:00', 'DEGRADED', None, 97.55]
  [211, 'OutOfMemory', 'Heap space exhausted', 'search-api', 'info', 22, '2026-04-04 03:33:00', 'DEGRADED', 71.8, 91.69]
  [248, 'FileNotFound', 'File /tmp/data.csv not found', 'gateway', 'Fatal', 29, '2026-05-05 04:44:00', 'DEGRADED', None, 91.65]
  [322, 'RateLimitExceeded', 'Too many requests from 10.0.0.1', 'auth-svc', 'fatal', 43, '2026-07-07 06:06:00', 'DEGRADED', None, 91.45]
*/


-- Write your SQL solution below:

SELECT e.err_id, e.err_type, e.message, e.svc_name,
       e.severity, e.count, e.first_at,
       s.status, s.latency, s.uptime
FROM err_tracks e
JOIN svc_health s ON e.svc_name = s.svc_name
ORDER BY e.err_id
