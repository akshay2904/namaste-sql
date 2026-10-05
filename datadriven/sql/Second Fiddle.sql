-- ======================================================================
-- Second Fiddle
-- ======================================================================
-- Difficulty : Hard
-- Company    : Vesta Innovations
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/2nd_most_common_content_type
-- ======================================================================

/*
We measure each content format by how many items registered account holders have published, so an item whose creator has no matching user record does not add to a format's total. Take the format sitting second by that total (include every format tied for second) and return the complete records of all its items, whoever the creator is.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [587, 'Exploring Web Development', 'livestream', 483, None, '2026-10-10']
  [802, 'Mastering Tech Startups', 'livestream', 718, 1458, '2025-03-15']
  [1017, 'Exploring Web Development', 'livestream', 953, 1943, '2026-08-20']
  [1232, 'Mastering Tech Startups', 'livestream', 1188, 2428, '2025-01-25']
*/


-- Write your SQL solution below:

WITH type_counts AS (
    SELECT
        content_type,
        COUNT(*) AS cnt,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM content_items
    WHERE creator_id IN (SELECT user_id FROM users)
    GROUP BY content_type
)
SELECT ci.*
FROM content_items ci
INNER JOIN type_counts tc ON ci.content_type = tc.content_type
WHERE tc.rnk = 2
ORDER BY ci.content_id
