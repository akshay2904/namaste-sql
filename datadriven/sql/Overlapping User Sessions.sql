-- ======================================================================
-- Overlapping User Sessions
-- ======================================================================
-- Difficulty : Medium
-- Company    : Vanguard
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/overlapping_user_sessions
-- ======================================================================

/*
The user_sessions table records session windows with a start and end time. Some users have sessions that overlap in time. Find all pairs of overlapping sessions for the same user. Two sessions overlap if one starts before the other ends and vice versa. Return the user_id, the session_ids of both overlapping sessions, and their respective start times. Do not return a session paired with itself.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id', 'session_id_1', 'session_id_2', 'start_1', 'start_2']:
  [100, 13161, 13222, '2026-06-15 10:00:00', '2026-06-15 11:00:00']
  [100, 13161, 13283, '2026-06-15 10:00:00', '2026-06-15 11:30:00']
  [100, 13222, 13283, '2026-06-15 11:00:00', '2026-06-15 11:30:00']
*/


-- Write your SQL solution below:

SELECT
    a.user_id,
    a.session_id AS session_id_1,
    b.session_id AS session_id_2,
    a.session_start AS start_1,
    b.session_start AS start_2
FROM user_sessions a
JOIN user_sessions b
  ON a.user_id = b.user_id
  AND a.session_id < b.session_id
WHERE a.session_start < datetime(b.session_start, '+' || b.session_duration_sec || ' seconds')
  AND b.session_start < datetime(a.session_start, '+' || a.session_duration_sec || ' seconds')
