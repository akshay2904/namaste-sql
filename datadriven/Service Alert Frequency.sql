-- ======================================================================
-- Service Alert Frequency
-- ======================================================================
-- Difficulty : Easy
-- Company    : Spotify
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/service_alert_frequency
-- ======================================================================

/*
The incident response team is prioritizing which services need the most reliability investment. Show each service alongside its alert count and its rank by volume, sorted from most to least.

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['svc_name', 'occurrence_count', 'rnk']:
  ['user-svc', 26, 1]
  ['search-api', 26, 1]
  ['payment-api', 26, 1]
  ['notif-svc', 24, 2]
  ['db-primary', 24, 2]
*/


-- Write your SQL solution below:

SELECT svc_name, COUNT(*) AS occurrence_count,
       DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
FROM alert_events
GROUP BY svc_name
ORDER BY occurrence_count DESC
