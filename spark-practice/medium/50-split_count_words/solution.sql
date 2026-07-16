SELECT word, COUNT(*) AS count
FROM (
  SELECT LOWER(TRIM(word_raw)) AS word
  FROM reviews
  LATERAL VIEW EXPLODE(SPLIT(review_text, ' ')) t AS word_raw
)
WHERE LENGTH(word) >= 3
  AND word NOT IN ('the', 'and', 'for', 'this', 'was', 'very', 'are', 'with', 'that')
GROUP BY word
ORDER BY count DESC, word ASC
LIMIT 5
