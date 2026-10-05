"""PySpark solution for: Content Page Spreads
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Full outer join on the spread pairing condition
joined = content_items.alias("l").join(
    content_items.alias("r"),
    (F.col("l.content_id") + 1 == F.col("r.content_id")) &
    (F.col("l.content_id") % 2 == 0) &
    (F.col("r.content_id") % 2 == 1),
    "full_outer"
)

# Filter to keep only left pages (even) or right pages (odd)
result = joined.filter(
    (F.col("l.content_id") % 2 == 0) | (F.col("r.content_id") % 2 == 1)
).select(
    F.col("l.content_id").alias("left_id"),
    F.col("l.title").alias("left_title"),
    F.col("r.title").alias("right_title")
)

result.show()
