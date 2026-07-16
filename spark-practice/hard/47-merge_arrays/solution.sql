SELECT user_id, ARRAY_JOIN(ARRAY_SORT(COLLECT_SET(TRIM(item))), ',') AS all_items
FROM (
  SELECT user_id, EXPLODE(SPLIT(items, ',')) AS item
  FROM user_purchases
)
GROUP BY user_id
ORDER BY user_id
