-- ======================================================================
-- The Weight of Words
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/word_count_per_message
-- ======================================================================

/*
A chat analytics team is profiling how wordy each message is, treating every space in the content as a divider between words. Return each message's ID alongside its word count.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['msg_id', 'word_count']:
  [147, 4]
  [194, 5]
  [241, 3]
  [382, None]
  [429, 1]
*/


-- Write your SQL solution below:

SELECT
    msg_id,
    LENGTH(content) - LENGTH(REPLACE(content, ' ', '')) + 1 AS word_count
FROM chat_msgs
