"""PySpark solution for: The Last Checkout
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
import pyspark.sql.functions as F

# Add a rank column per user, ordered by transaction date descending
window_spec = Window.partitionBy("user_id").orderBy(F.col("transaction_date").desc())
ranked = transactions.withColumn("rnk", F.rank().over(window_spec))

# Filter to only the most recent transaction date per user
most_recent = ranked.filter(F.col("rnk") == 1)

# Group by date and user to count purchases on that day
result = (
    most_recent.groupBy("transaction_date", "user_id")
    .agg(F.count("*").alias("purchase_count"))
    .orderBy("transaction_date")
)

result.show()
