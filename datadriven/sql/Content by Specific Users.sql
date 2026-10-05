-- ======================================================================
-- Content by Specific Users
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/content_by_specific_users
-- ======================================================================

/*
The community team is auditing a small group of creators. Pull every piece of content authored by users 'alice', 'aaron42', and 'amelia'. Show the content ID, title, content type, and creator ID, sorted by content ID.

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

Expected output ['content_id', 'title', 'content_type', 'creator_id']:
  [243, 'The Ultimate Guide to AI Trends', 'article', 197]
  [286, 'Top 10 Mobile Apps', 'podcast', 294]
  [2350, 'How to Data Science', 'video', 100]
  [2393, 'The Ultimate Guide to AI Trends', 'article', 197]
  [2436, 'Top 10 Mobile Apps', 'podcast', 294]
*/


-- Write your SQL solution below:

SELECT ci.content_id, ci.title, ci.content_type, ci.creator_id
FROM content_items ci
JOIN users u ON ci.creator_id = u.user_id
WHERE u.username IN ('alice', 'aaron42', 'amelia')
ORDER BY ci.content_id
