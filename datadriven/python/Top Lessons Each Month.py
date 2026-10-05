"""PySpark solution for: Top Lessons Each Month
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Step 1: Aggregate completion counts by month and page_url
monthly = page_views.groupBy(
    F.date_format("viewed_at", "yyyy-MM").alias("month"),
    "page_url"
).agg(F.count("*").alias("completion_count"))

# Step 2: Rank pages by completion count within each month
window = Window.partitionBy("month").orderBy(F.col("completion_count").desc())
ranked = monthly.withColumn("rnk", F.rank().over(window))

# Step 3: Filter top 3 ranks and select required columns
result = ranked.filter(F.col("rnk") <= 3).select(
    "month", "page_url", "completion_count", F.col("rnk").alias("rank")
).orderBy("month", "rnk")

result.show()
