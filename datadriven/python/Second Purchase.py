"""PySpark solution for: Second Purchase
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Create a window that partitions by user_id and orders by transaction_date
window = Window.partitionBy("user_id").orderBy("transaction_date")

# Apply the window to number rows and filter for the second transaction
second_purchases = transactions \
    .withColumn("rn", F.row_number().over(window)) \
    .filter(F.col("rn") == 2) \
    .select("user_id", "total_amount", "transaction_date")

# Show results (optional, for verification)
second_purchases.show()
