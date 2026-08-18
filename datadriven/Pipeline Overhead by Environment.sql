-- ======================================================================
-- Pipeline Overhead by Environment
-- ======================================================================
-- Difficulty : Medium
-- Company    : EY
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/pipeline_overhead_by_environment
-- ======================================================================

/*
The data platform team wants to compare throughput overhead between pipelines that finished successfully and those still running. For each of those two states, work out the average size of the gap between rows read in and rows written out, then report how far apart those two averages are as a single number. Status is recorded with inconsistent capitalization, so spellings like 'success' and 'Success' should be counted as the same state.

Table: data_pipes(pipe_id, pipe_name, status, rows_in, rows_out, start_at, dur_secs)

Sample data - data_pipes ['pipe_id', 'pipe_name', 'status', 'rows_in', 'rows_out', 'start_at', 'dur_secs']:
  [131, 'etl_users', 'failed', 137, 97, '2026-02-02 01:00:00', 28]
  [162, 'etl_events', 'running', 274, 194, '2026-03-03 02:00:00', 51]
  [193, 'sync_crm', 'queued', 411, 291, '2026-04-04 03:00:00', 74]
  [224, 'agg_daily', 'skipped', 548, 388, '2026-05-05 04:00:00', 97]
  [255, 'agg_weekly', 'Success', 685, 485, '2026-06-06 05:00:00', None]

Expected output ['overhead_difference']:
  [267.0769230769231]
*/


-- Write your SQL solution below:

WITH per_state AS (
  SELECT
    AVG(CASE WHEN LOWER(status) = 'success' THEN ABS(rows_in - rows_out) END) AS success_overhead,
    AVG(CASE WHEN LOWER(status) = 'running' THEN ABS(rows_in - rows_out) END) AS running_overhead
  FROM data_pipes
  WHERE LOWER(status) IN ('success', 'running')
)
SELECT ABS(success_overhead - running_overhead) AS overhead_difference
FROM per_state;
