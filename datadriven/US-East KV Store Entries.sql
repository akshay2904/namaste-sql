-- ======================================================================
-- US-East KV Store Entries
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/us_east_kv_store_entries
-- ======================================================================

/*
Pull every KV store entry in the us-east-1 region. For each entry, return the entry ID, key, value, TTL in seconds, region, creation time, and expiration time.

Table: kv_store(entry_id, kv_key, kv_value, ttl_secs, region, created, expires)

Sample data - kv_store ['entry_id', 'kv_key', 'kv_value', 'ttl_secs', 'region', 'created', 'expires']:
  [141, 'cache:1001', '42', 97, 'us-west-2', '2026-02-02 01:00:00', '2026-03-02 06:00:00']
  [182, 'config:1002', 'active', 134, 'eu-west-1', '2026-03-03 02:00:00', '2026-04-03 07:00:00']
  [223, 'lock:1003', '{"user_id": 3, "role": "admin"}', 171, 'ap-south-1', '2026-04-04 03:00:00', '2026-05-04 08:00:00']
  [264, 'rate:1004', '168', 208, 'us-east-1', '2026-05-05 04:00:00', '2026-06-05 09:00:00']
  [305, 'user:1005', 'active', None, 'us-west-2', '2026-06-06 05:00:00', None]

Expected output ['entry_id', 'kv_key', 'kv_value', 'ttl_secs', 'region', 'created', 'expires']:
  [264, 'rate:1004', '168', 208, 'us-east-1', '2026-05-05 04:00:00', '2026-06-05 09:00:00']
  [428, 'session:1008', 'active', 356, 'us-east-1', '2026-09-09 08:00:00', '2026-10-09 13:00:00']
  [592, 'rate:1012', '{"user_id": 12, "role": "admin"}', 504, 'us-east-1', '2026-01-13 12:00:00', '2026-02-13 17:00:00']
  [756, 'session:1016', '672', 652, 'us-east-1', '2026-05-17 16:00:00', '2026-06-17 21:00:00']
  [920, 'rate:1020', 'active', None, 'us-east-1', '2026-09-21 20:00:00', None]
*/


-- Write your SQL solution below:

SELECT entry_id, kv_key, kv_value, ttl_secs, region, created, expires
FROM kv_store
WHERE region = 'us-east-1'
