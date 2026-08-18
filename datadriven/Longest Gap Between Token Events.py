"""PySpark solution for: Longest Gap Between Token Events
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
from pyspark.sql.functions import col, lag, datediff, max

# Calculate gap between consecutive issued dates
issue_window = Window.orderBy("issued")
issue_gaps = api_tokens.withColumn(
    "gap",
    datediff(col("issued"), lag("issued").over(issue_window))
)

# Calculate gap between consecutive expiration dates, ignoring nulls
expire_gaps = (
    api_tokens.filter(col("expires").isNotNull())
    .withColumn("gap", datediff(col("expires"), lag("expires").over(Window.orderBy("expires"))))
)

max_issue_gap = issue_gaps.agg(max("gap").alias("max_issue_gap_days"))
max_expire_gap = expire_gaps.agg(max("gap").alias("max_expire_gap_days"))

result = max_issue_gap.crossJoin(max_expire_gap).select(
    "max_issue_gap_days", "max_expire_gap_days"
)

result.show()
