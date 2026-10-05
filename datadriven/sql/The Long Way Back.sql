-- ======================================================================
-- The Long Way Back
-- ======================================================================
-- Difficulty : Hard
-- Company    : Visa
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/service_uptime_turnaround
-- ======================================================================

/*
From our service health checks we track each service's monthly average uptime, and we want the services that slid downhill and then clawed their way back. Reading one service's months in time order, treat each unbroken run of consecutive falling months as a single decline stretch and each unbroken run of consecutive rising months as a single recovery stretch; a month whose average equals the one before it belongs to neither and ends whichever stretch was open. Match every decline stretch with each recovery stretch that starts after the decline stretch's final month, and for each pairing report the month each stretch began along with how far the service climbed: the highest monthly average anywhere in the recovery stretch minus the lowest anywhere in the decline stretch, over that lowest.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'decline_start', 'growth_start', 'growth_ratio']:
  ['auth-svc', '2026-03', '2026-04', 0.010497237569060805]
  ['auth-svc', '2026-03', '2026-07', 0.003314917127071949]
  ['auth-svc', '2026-03', '2026-10', 0.0823204419889503]
  ['auth-svc', '2026-03', '2026-12', 0.05469613259668511]
  ['auth-svc', '2026-05', '2026-07', 0.009449694274597093]
*/


-- Write your SQL solution below:

$1b
