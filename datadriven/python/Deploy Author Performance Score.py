"""PySpark solution for: Deploy Author Performance Score
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Find the most recent year and the year before
max_year = deploy_logs.agg(F.year(F.max("deploy_at")).alias("max_year")).collect()[0]["max_year"]
min_year = max_year - 1

# Filter and aggregate by lowercased author
author_stats = (
    deploy_logs
    .filter(F.year("deploy_at") >= min_year)
    .groupBy(F.lower("author").alias("author"))
    .agg(
        F.round(F.avg("dur_secs"), 2).alias("avg_duration"),
        F.count("*").alias("deploy_count"),
        F.round((F.lit(100) - F.avg("dur_secs")) * F.count("*"), 2).alias("score")
    )
    .drop("deploy_count")
)

# Add dense rank ordered by score descending
window_spec = Window.orderBy(F.desc("score"))
result = author_stats.withColumn("rnk", F.dense_rank().over(window_spec)).orderBy(F.desc("score"))

result.show()
