-- ======================================================================
-- The Legacy Hunt
-- ======================================================================
-- Difficulty : Easy
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_legacy_hunt
-- ======================================================================

/*
The data engineering team is sunsetting pipelines that predate a recent infrastructure migration. Surface every unique pipeline name that had at least one run before July 1, 2026.

Table: data_pipes(pipe_id, pipe_name, status, rows_in, rows_out, start_at, dur_secs)

Sample data - data_pipes ['pipe_id', 'pipe_name', 'status', 'rows_in', 'rows_out', 'start_at', 'dur_secs']:
  [131, 'etl_users', 'failed', 137, 97, '2026-02-02 01:00:00', 28]
  [162, 'etl_events', 'running', 274, 194, '2026-03-03 02:00:00', 51]
  [193, 'sync_crm', 'queued', 411, 291, '2026-04-04 03:00:00', 74]
  [224, 'agg_daily', 'skipped', 548, 388, '2026-05-05 04:00:00', 97]
  [255, 'agg_weekly', 'Success', 685, 485, '2026-06-06 05:00:00', None]

Expected output ['pipe_name']:
  ['etl_users']
  ['etl_events']
  ['sync_crm']
  ['agg_daily']
  ['agg_weekly']
*/


-- Write your SQL solution below:

SELECT DISTINCT pipe_name
FROM data_pipes
WHERE start_at < '2026-07-01';
