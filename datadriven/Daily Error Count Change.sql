-- ======================================================================
-- Daily Error Count Change
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/daily_error_count_change
-- ======================================================================

/*
SRE wants a daily trend chart for error volume. For each day errors were recorded, show the number of errors that landed that day, how many landed the day before, and how much it moved. Order from earliest day to latest. The first day on record has no prior day to compare against.

Table: err_tracks(err_id, err_type, message, svc_name, severity, count, first_at)

Sample data - err_tracks ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at']:
  [137, 'TypeError', 'Cannot read property of undefined', 'payment-api', 'error', 8, '2026-02-02 01:11:00']
  [174, 'ConnectionTimeout', 'Connection timed out after 30s', 'user-svc', 'warning', 15, '2026-03-03 02:22:00']
  [211, 'OutOfMemory', 'Heap space exhausted', 'search-api', 'info', 22, '2026-04-04 03:33:00']
  [248, 'FileNotFound', 'File /tmp/data.csv not found', 'gateway', 'Fatal', 29, '2026-05-05 04:44:00']
  [285, 'PermissionDenied', 'Access denied for user root', 'worker', 'ERROR', 36, '2026-06-06 05:55:00']

Expected output ['error_date', 'error_count', 'prev_count', 'day_over_day_change']:
  ['2026-01-01', 2, None, None]
  ['2026-01-05', 2, 2, 0]
  ['2026-01-09', 2, 2, 0]
  ['2026-01-13', 3, 2, 1]
  ['2026-01-25', 3, 2, 1]
*/


-- Write your SQL solution below:

WITH daily_errors AS (
    SELECT
        DATE(first_at) AS error_date,
        COUNT(*) AS error_count
    FROM err_tracks
    GROUP BY DATE(first_at)
),
with_lag AS (
    SELECT
        error_date,
        error_count,
        LAG(error_count) OVER (ORDER BY error_date) AS prev_count
    FROM daily_errors
)
SELECT
    error_date,
    error_count,
    prev_count,
    error_count - prev_count AS day_over_day_change
FROM with_lag
ORDER BY error_date
