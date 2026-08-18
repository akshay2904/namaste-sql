-- ======================================================================
-- Double Vision
-- ======================================================================
-- Difficulty : Easy
-- Company    : UKG
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_duplicate_detection_sprint
-- ======================================================================

/*
Ahead of a CRM migration, the data quality team is hunting for email addresses that were entered against more than one account. For each email tied to multiple accounts, return the address, how many accounts carry it, and the earliest and most recent signup dates, with the most-repeated addresses first.

Table: users(user_id, email, signup_date)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['email', 'occurrence_count', 'earliest_signup', 'latest_signup']:
  ['haruki@example.com', 2, '2025-07-07', '2026-06-26']
  ['hayley_b@example.com', 2, '2024-07-27', '2026-02-12']
  ['henry@example.com', 2, '2023-05-25', '2024-04-24']
  ['hiro@example.com', 2, '2024-12-02', '2025-05-25']
*/


-- Write your SQL solution below:

SELECT email, COUNT(*) AS occurrence_count, MIN(signup_date) AS earliest_signup, MAX(signup_date) AS latest_signup FROM users WHERE email IS NOT NULL GROUP BY email HAVING COUNT(*) > 1 ORDER BY occurrence_count DESC, email ASC
