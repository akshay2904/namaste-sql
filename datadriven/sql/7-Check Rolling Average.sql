-- ======================================================================
-- 7-Check Rolling Average
-- ======================================================================
-- Difficulty : Medium
-- Company    : Goldman Sachs
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/7_check_rolling_average
-- ======================================================================

/*
The platform reliability team monitors latency trends per service. For each service's health check history, compute a 7-check rolling average of latency using the current check and the 6 checks immediately before it, ordered by check timestamp. Return the service name, check timestamp, raw latency, and the rolling average.

Table: svc_health(check_id, svc_name, latency, checked)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'checked', 'latency', 'rolling_avg']:
  ['auth-svc', '2026-01-05 12:00:00', 186.5, 186.5]
  ['auth-svc', '2026-02-06 07:13:00', 816.9, 501.7]
  ['auth-svc', '2026-02-18 19:13:00', 570.9, 524.7666666666667]
  ['auth-svc', '2026-03-23 02:10:00', 155.5, 432.45]
  ['auth-svc', '2026-04-08 21:03:00', None, 432.45]
*/


-- Write your SQL solution below:

SELECT
    svc_name,
    checked,
    latency,
    AVG(latency) OVER (
    PARTITION BY svc_name
    ORDER BY checked
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_avg
FROM svc_health
ORDER BY    svc_name, checked
