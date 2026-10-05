-- ======================================================================
-- Auth Service Health Checks
-- ======================================================================
-- Difficulty : Easy
-- Company    : Vesta Innovations
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/auth_service_health_checks
-- ======================================================================

/*
The SRE team is investigating recent instability in the authentication service. Pull all health check records for 'auth-svc', including every available field.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [470, 'auth-svc', 'Healthy', 31.5, 90.3, '2026-11-11 10:50:00', 'us-east-1']
  [840, 'auth-svc', 'unhealthy', 62.5, 90.6, '2026-09-21 20:40:00', 'us-east-1']
  [1210, 'auth-svc', 'healthy', 93.5, 90.9, '2026-07-03 06:30:00', 'us-east-1']
  [4873, 'auth-svc', 'DEGRADED', 529.9, 91.45, '2026-04-20 09:03:00', 'eu-west-1']
  [5243, 'auth-svc', 'timeout', 570.9, 93.95, '2026-02-18 19:13:00', 'eu-west-1']
*/


-- Write your SQL solution below:

SELECT *
FROM svc_health
WHERE svc_name = 'auth-svc'
