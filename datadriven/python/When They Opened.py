"""PySpark solution for: When They Opened
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import month, col

# Filter opened notifications
opened_notifs = push_notifs.filter(col("opened") == 1)

# Group by month and count
opened_count = opened_notifs.groupBy(month("sent_at").alias("month")).count()

# Order by count in descending order and then by month
result = opened_count.orderBy(col("count").desc(), col("month"))

# Rename count column to opened_count
result = result.withColumnRenamed("count", "opened_count")
