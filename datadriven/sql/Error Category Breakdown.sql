-- ======================================================================
-- Error Category Breakdown
-- ======================================================================
-- Difficulty : Hard
-- Company    : City and County of San Francisco
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/error_category_breakdown
-- ======================================================================

/*
During an incident postmortem, the on-call engineer needs to categorize error tracks into three buckets by their error type: those related to timeouts, those related to connections, and those related to memory. For each category, show its label and how many error-track rows fall into it (a count of matching rows, not a sum of the count column).

Table: err_tracks(err_id, err_type, message, svc_name, severity, count, first_at)

Sample data - err_tracks ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at']:
  [137, 'TypeError', 'Cannot read property of undefined', 'payment-api', 'error', 8, '2026-02-02 01:11:00']
  [174, 'ConnectionTimeout', 'Connection timed out after 30s', 'user-svc', 'warning', 15, '2026-03-03 02:22:00']
  [211, 'OutOfMemory', 'Heap space exhausted', 'search-api', 'info', 22, '2026-04-04 03:33:00']
  [248, 'FileNotFound', 'File /tmp/data.csv not found', 'gateway', 'Fatal', 29, '2026-05-05 04:44:00']
  [285, 'PermissionDenied', 'Access denied for user root', 'worker', 'ERROR', 36, '2026-06-06 05:55:00']

Expected output ['error_category', 'error_count']:
  ['application', 160]
  ['security', 20]
  ['network', 20]
*/


-- Write your SQL solution below:

SELECT
    CASE
        WHEN err_type LIKE '%timeout%' OR err_type LIKE '%connection%' THEN 'network'
        WHEN err_type LIKE '%auth%' OR err_type LIKE '%permission%' THEN 'security'
        ELSE 'application'
    END AS error_category,
    COUNT(*) AS error_count
FROM err_tracks
GROUP BY error_category
ORDER BY error_count DESC
