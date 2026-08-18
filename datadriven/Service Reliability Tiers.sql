-- ======================================================================
-- Service Reliability Tiers
-- ======================================================================
-- Difficulty : Medium
-- Company    : Airbnb
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/service_reliability_tiers
-- ======================================================================

/*
Classify services by uptime into reliability tiers: 99.9%+ is 'Platinum', 99.0 to 99.89% is 'Gold', 95.0 to 98.99% is 'Silver', below 95% is 'Bronze'. For each tier, show the minimum, average, and maximum latency. Exclude any checks where the status mentions 'maintenance'. Results should go from highest average latency to lowest.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['tier', 'min_latency', 'avg_latency', 'max_latency']:
  ['Bronze', 6.7, 385.9022222222222, 816.9]
  ['Gold', 53.2, 374.87692307692305, 792.3]
  ['Silver', 3.6, 307.16301369863015, 808.7]
  ['Platinum', 301.2, 301.2, 301.2]
*/


-- Write your SQL solution below:

SELECT CASE WHEN uptime >= 99.9 THEN 'Platinum' WHEN uptime >= 99.0 THEN 'Gold' WHEN uptime >= 95.0 THEN 'Silver' ELSE 'Bronze' END AS tier, MIN(latency) AS min_latency, AVG(latency) AS avg_latency, MAX(latency) AS max_latency
FROM svc_health
WHERE status NOT LIKE '%maintenance%'
GROUP BY tier
ORDER BY avg_latency DESC
