-- ======================================================================
-- Error Severity Buckets
-- ======================================================================
-- Difficulty : Easy
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/error_severity_buckets
-- ======================================================================

/*
On-call wants every recorded error tagged with a severity label based on how often it has fired: 0 occurrences is NONE, 1 to 5 is LOW, 6 to 20 is MODERATE, 21 to 50 is HIGH, and anything above 50 is CRITICAL. Treat any error whose occurrence count was never recorded as CRITICAL, since on-call escalates anything it cannot size. Skip rows that aren't attributed to a service, and show each error type alongside its label.

Table: err_tracks(err_id, err_type, message, svc_name, severity, count, first_at)

Sample data - err_tracks ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at']:
  [137, 'TypeError', 'Cannot read property of undefined', 'payment-api', 'error', 8, '2026-02-02 01:11:00']
  [174, 'ConnectionTimeout', 'Connection timed out after 30s', 'user-svc', 'warning', 15, '2026-03-03 02:22:00']
  [211, 'OutOfMemory', 'Heap space exhausted', 'search-api', 'info', 22, '2026-04-04 03:33:00']
  [248, 'FileNotFound', 'File /tmp/data.csv not found', 'gateway', 'Fatal', 29, '2026-05-05 04:44:00']
  [285, 'PermissionDenied', 'Access denied for user root', 'worker', 'ERROR', 36, '2026-06-06 05:55:00']

Expected output ['err_type', 'severity_label']:
  ['TypeError', 'MODERATE']
  ['ConnectionTimeout', 'MODERATE']
  ['OutOfMemory', 'HIGH']
  ['FileNotFound', 'HIGH']
  ['nullpointerexception', 'CRITICAL']
*/


-- Write your SQL solution below:

SELECT
    err_type,
    CASE
        WHEN count = 0 THEN 'NONE'
        WHEN count BETWEEN 1 AND 5 THEN 'LOW'
        WHEN count BETWEEN 6 AND 20 THEN 'MODERATE'
        WHEN count BETWEEN 21 AND 50 THEN 'HIGH'
        ELSE 'CRITICAL'
    END AS severity_label
FROM err_tracks
WHERE svc_name IS NOT NULL
