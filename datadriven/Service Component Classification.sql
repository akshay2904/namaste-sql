-- ======================================================================
-- Service Component Classification
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/service_component_classification
-- ======================================================================

/*
We're enriching the service catalog. If a service name contains '/', classify it as 'Multi-Component'; otherwise classify it as 'Single-Component'. Show each unique service name with its classification.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'svc_class']:
  ['payment-api', 'Single-Component']
  ['user-svc', 'Single-Component']
  ['search-api', 'Single-Component']
  ['gateway', 'Single-Component']
  ['notif-svc', 'Single-Component']
*/


-- Write your SQL solution below:

SELECT DISTINCT svc_name, CASE WHEN svc_name LIKE '%/%' THEN 'Multi-Component' ELSE 'Single-Component' END AS svc_class
FROM svc_health
