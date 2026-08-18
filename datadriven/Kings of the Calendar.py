"""PySpark solution for: Kings of the Calendar
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Filter out refunds and join with products
joined_df = transactions.filter(F.col("total_amount") >= 0) \
    .join(products, transactions.product_id == products.product_id, "inner") \
    .withColumn("month", F.date_format("transaction_date", "yyyy-MM"))

# Aggregate total quantity per product per month
agg_df = joined_df.groupBy("month", "product_name") \
    .agg(F.sum("quantity").alias("total_quantity"))

# Rank products within each month by total quantity (dense rank)
window_spec = Window.partitionBy("month").orderBy(F.desc("total_quantity"))
ranked_df = agg_df.withColumn(
    "rnk",
    F.dense_rank().over(window_spec)
)

# Filter top 10 per month and order by month, then rank
result_df = ranked_df.filter(F.col("rnk") <= 10) \
    .select("month", "product_name", "total_quantity", "rnk") \
    .orderBy("month", "rnk")

result_df.show()
