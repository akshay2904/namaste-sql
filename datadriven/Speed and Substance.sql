-- ======================================================================
-- Speed and Substance
-- ======================================================================
-- Difficulty : Hard
-- Company    : Kabbage
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/pipeline_duration_vs_throughput
-- ======================================================================

/*
We're building an observability view over pipeline runs and want a single figure for how tightly a pipeline's speed tracks its throughput. Collapse each pipeline to one point: its average run duration paired with its average net row output, where a run's net output is `rows_out` minus 10 percent of `rows_in`. There is no correlation function to lean on here, so compute the Pearson correlation between those two per-pipeline figures directly from its definition, rounded to two decimals.

Table: data_pipes(pipe_id, pipe_name, status, rows_in, rows_out, start_at, dur_secs)

Sample data - data_pipes ['pipe_id', 'pipe_name', 'status', 'rows_in', 'rows_out', 'start_at', 'dur_secs']:
  [131, 'etl_users', 'failed', 137, 97, '2026-02-02 01:00:00', 28]
  [162, 'etl_events', 'running', 274, 194, '2026-03-03 02:00:00', 51]
  [193, 'sync_crm', 'queued', 411, 291, '2026-04-04 03:00:00', 74]
  [224, 'agg_daily', 'skipped', 548, 388, '2026-05-05 04:00:00', 97]
  [255, 'agg_weekly', 'Success', 685, 485, '2026-06-06 05:00:00', None]

Expected output ['correlation']:
  [0.64]
*/


-- Write your SQL solution below:

WITH pipe_stats AS (
    SELECT pipe_name,
           AVG(dur_secs)                      AS avg_dur,
           AVG(rows_out - 0.1 * rows_in)      AS avg_net_output
    FROM data_pipes
    GROUP BY pipe_name
),
means AS (
    SELECT AVG(avg_dur) AS dur_mean,
           AVG(avg_net_output) AS out_mean
    FROM pipe_stats
)
SELECT ROUND(
    SUM((ps.avg_dur - m.dur_mean) * (ps.avg_net_output - m.out_mean))
    / (SQRT(SUM((ps.avg_dur - m.dur_mean) * (ps.avg_dur - m.dur_mean)))
       * SQRT(SUM((ps.avg_net_output - m.out_mean) * (ps.avg_net_output - m.out_mean)))),
    2
) AS correlation
FROM pipe_stats ps
CROSS JOIN means m
