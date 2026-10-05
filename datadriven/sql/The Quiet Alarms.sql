-- ======================================================================
-- The Quiet Alarms
-- ======================================================================
-- Difficulty : Medium
-- Company    : Vesta Innovations
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_quiet_alarms
-- ======================================================================

/*
Before tightening severity thresholds, the data quality team needs to know how much volume the 'low' severity tier accounted for in 2026.

Table: dq_checks(check_id, tbl_name, col_name, rule, passed, fail_pct, run_at, severity)

Sample data - dq_checks ['check_id', 'tbl_name', 'col_name', 'rule', 'passed', 'fail_pct', 'run_at', 'severity']:
  [131, 'users', 'email', 'unique', 1, None, '2026-02-02 01:00:00', 'high']
  [162, 'products', 'amount', 'range', 1, None, '2026-03-03 02:00:00', 'medium']
  [193, 'transactions', 'status', 'format', 1, None, '2026-04-04 03:00:00', 'low']
  [224, 'events', 'created_at', 'referential', 1, None, '2026-05-05 04:00:00', 'Critical']
  [255, 'sessions', 'price', 'freshness', 0, 15, '2026-06-06 05:00:00', 'HIGH']

Expected output ['low_severity_count']:
  [20]
*/


-- Write your SQL solution below:

SELECT COUNT(*) AS low_severity_count FROM dq_checks WHERE severity = 'low' AND strftime('%Y', run_at) = '2026'
