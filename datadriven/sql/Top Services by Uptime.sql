-- ======================================================================
-- Top Services by Uptime
-- ======================================================================
-- Difficulty : Medium
-- Company    : Amazon
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_services_by_uptime
-- ======================================================================

/*
The SRE team maintains an uptime leaderboard. Rank services by average uptime, but only include services with at least 5 health checks. Tied services share the same rank with no gaps. Return the top 3 ranks, including ties. Round to 2 decimal places.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'avg_uptime', 'rank']:
  ['gateway', 97.53, 1]
  ['cache-svc', 97.43, 2]
  ['queue-worker', 95.59, 3]
*/


-- Write your SQL solution below:

WITH svc_avg AS (
    SELECT
        svc_name,
        ROUND(AVG(uptime), 2) AS avg_uptime
    FROM svc_health
    GROUP BY svc_name
    HAVING COUNT(*) >= 5
),
ranked AS (
    SELECT
        svc_name,
        avg_uptime,
        DENSE_RANK() OVER (ORDER BY avg_uptime DESC) AS rank
    FROM svc_avg
)
SELECT svc_name, avg_uptime, rank
FROM ranked
WHERE rank <= 3
ORDER BY rank ASC, svc_name ASC;
