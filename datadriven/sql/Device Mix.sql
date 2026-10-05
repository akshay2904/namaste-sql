-- ======================================================================
-- Device Mix
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/device_mix
-- ======================================================================

/*
The product team is deciding whether to invest in a mobile redesign and needs to understand the current device landscape. For each combination of device type and operating system, show how many devices are registered. Only include combinations that have at least three registrations, ordered from most common to least.

Table: devices(device_id, device_type, os_name, os_version, browser)

Sample data - devices ['device_id', 'device_type', 'os_name', 'os_version', 'browser']:
  [201, 'desktop', 'Android', '15.1', 'Chrome']
  [230, 'tablet', 'Windows', '16.2', 'Firefox']
  [259, 'smart_tv', 'macOS', '17.0', 'Edge']
  [288, 'wearable', 'Linux', '11', 'Opera']
  [317, 'mobile', 'tvOS', '12', 'Samsung Internet']

Expected output ['device_type', 'os_name', 'device_count']:
  ['desktop', 'Android', 6]
  ['mobile', 'Android', 6]
  ['smart_tv', 'Linux', 6]
  ['tablet', 'Android', 6]
  ['wearable', 'Android', 6]
*/


-- Write your SQL solution below:

SELECT device_type, os_name, COUNT(*) AS device_count
FROM devices
GROUP BY device_type, os_name
HAVING COUNT(*) >= 3
ORDER BY device_count DESC
