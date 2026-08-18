-- ======================================================================
-- Prime Real Estate
-- ======================================================================
-- Difficulty : Easy
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/device_types_with_chrome_users
-- ======================================================================

/*
The frontend team is choosing which device types to prioritize for a Chrome-only optimization. Find the device types with at least two Chrome users and how many each has, largest first.

Table: devices(device_id, device_type, os_name, os_version, browser)

Sample data - devices ['device_id', 'device_type', 'os_name', 'os_version', 'browser']:
  [201, 'desktop', 'Android', '15.1', 'Chrome']
  [230, 'tablet', 'Windows', '16.2', 'Firefox']
  [259, 'smart_tv', 'macOS', '17.0', 'Edge']
  [288, 'wearable', 'Linux', '11', 'Opera']
  [317, 'mobile', 'tvOS', '12', 'Samsung Internet']

Expected output ['device_type', 'chrome_users']:
  ['tablet', 6]
  ['smart_tv', 6]
  ['mobile', 6]
  ['desktop', 6]
  ['wearable', 5]
*/


-- Write your SQL solution below:

SELECT device_type, COUNT(*) AS chrome_users
FROM devices
WHERE browser = 'Chrome'
GROUP BY device_type
HAVING COUNT(*) >= 2
ORDER BY chrome_users DESC
