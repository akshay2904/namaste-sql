"""PySpark solution for: Push Opens by Platform and Campaign
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter for opened notifications, then count distinct users per platform
openers_count = (
    push_notifs
    .filter(F.col("opened") == 1)
    .groupBy("platform")
    .agg(F.countDistinct("user_id").alias("unique_openers"))
    # Sort by count in descending order
    .orderBy(F.col("unique_openers").desc())
)

# Show the result (assuming a SparkSession 'spark' is already configured)
openers_count.show()
