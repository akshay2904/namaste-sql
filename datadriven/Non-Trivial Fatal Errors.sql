-- ======================================================================
-- Non-Trivial Fatal Errors
-- ======================================================================
-- Difficulty : Medium
-- Company    : Capital One
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/non_trivial_fatal_errors
-- ======================================================================

/*
We categorize error messages by length: 'short' (under 25 chars), 'mid' (25 to 35), and 'long' (over 35). Find errors that are not 'short' and have fatal severity (matching 'Fatal' or 'fatal' exactly). Show error ID, message, service name, and the length category, with one row per error.

Table: err_tracks(err_id, err_type, message, svc_name, severity, count, first_at)

Sample data - err_tracks ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at']:
  [137, 'TypeError', 'Cannot read property of undefined', 'payment-api', 'error', 8, '2026-02-02 01:11:00']
  [174, 'ConnectionTimeout', 'Connection timed out after 30s', 'user-svc', 'warning', 15, '2026-03-03 02:22:00']
  [211, 'OutOfMemory', 'Heap space exhausted', 'search-api', 'info', 22, '2026-04-04 03:33:00']
  [248, 'FileNotFound', 'File /tmp/data.csv not found', 'gateway', 'Fatal', 29, '2026-05-05 04:44:00']
  [285, 'PermissionDenied', 'Access denied for user root', 'worker', 'ERROR', 36, '2026-06-06 05:55:00']

Expected output ['err_id', 'message', 'svc_name', 'length_category']:
  [248, 'File /tmp/data.csv not found', 'gateway', 'mid']
  [322, 'Too many requests from 10.0.0.1', 'auth-svc', 'mid']
  [470, 'Unexpected null value at line 42', 'gateway', 'mid']
  [544, 'Connection timed out after 30s', 'auth-svc', 'mid']
  [766, 'Stack overflow in recursive call', 'auth-svc', 'mid']
*/


-- Write your SQL solution below:

SELECT
    err_id,
    message,
    svc_name,
    CASE
        WHEN LENGTH(message) <= 35 THEN 'mid'
        ELSE 'long'
    END AS length_category
FROM err_tracks
WHERE severity IN ('Fatal', 'fatal')
  AND LENGTH(message) >= 25
