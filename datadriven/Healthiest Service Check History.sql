-- ======================================================================
-- Healthiest Service Check History
-- ======================================================================
-- Difficulty : Hard
-- Company    : Vesta Innovations
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/healthiest_service_check_history
-- ======================================================================

/*
Find the service(s) with the highest-ever uptime score, then for those services show each check date, the previous check date, and the gap in days between them. Results should be ordered by check date, most recent first.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'checked', 'prev_checked', 'days_diff']:
  ['cache-svc', '2026-12-20 23:55:00', '2026-10-02 09:45:00', 79.59027777798474]
  ['cache-svc', '2026-10-02 09:45:00', '2026-08-12 19:35:00', 50.59027777798474]
  ['cache-svc', '2026-08-12 19:35:00', '2026-08-08 07:35:00', 4.5]
  ['cache-svc', '2026-08-08 07:35:00', '2026-06-22 05:25:00', 47.09027777751908]
  ['cache-svc', '2026-06-22 05:25:00', '2026-06-18 17:25:00', 3.5]
*/


-- Write your SQL solution below:

WITH healthiest AS (
    SELECT DISTINCT svc_name
    FROM svc_health
    WHERE uptime = (SELECT MAX(uptime) FROM svc_health)
)
SELECT
    s.svc_name,
    s.checked,
    LAG(s.checked) OVER (PARTITION BY s.svc_name ORDER BY s.checked) AS prev_checked,
    JULIANDAY(s.checked)
    - JULIANDAY(LAG(s.checked) OVER (PARTITION BY s.svc_name ORDER BY s.checked)) AS days_diff
FROM svc_health s
WHERE s.svc_name IN (SELECT svc_name FROM healthiest)
ORDER BY s.checked DESC
