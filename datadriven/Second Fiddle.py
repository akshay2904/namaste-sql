"""PySpark solution for: Second Fiddle
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Filter content_items to only those with registered users as creators
registered_items = content_items.join(
    users.select("user_id"),
    content_items.creator_id == users.user_id,
    "inner"
)

# Count items per content_type and rank with DENSE_RANK
type_counts = registered_items.groupBy("content_type").agg(
    F.count("*").alias("cnt")
).withColumn(
    "rnk",
    F.dense_rank().over(Window.orderBy(F.col("cnt").desc()))
)

# Filter type_counts to rank = 2 and join back to get all items
result = content_items.alias("ci").join(
    type_counts.select("content_type", "rnk").alias("tc"),
    F.col("ci.content_type") == F.col("tc.content_type"),
    "inner"
).filter(F.col("tc.rnk") == 2).select(
    "ci.content_id",
    "ci.title",
    "ci.content_type",
    "ci.duration_seconds",
    "ci.creator_id",
    "ci.publish_date"
).orderBy("ci.content_id")

result.show()
