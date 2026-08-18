"""PySpark solution for: Going Once
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F, Window

# Window spec to rank transactions per product by total_amount desc, then transaction_id
window_spec = Window.partitionBy("product_id").orderBy(
    F.col("total_amount").desc(), "transaction_id"
)

ranked_bids = transactions.withColumn(
    "rn", F.row_number().over(window_spec)
).filter(F.col("rn") == 1).select("product_id", "user_id")

# Aggregate transactions count and max amount per product
transaction_stats = transactions.groupBy("product_id").agg(
    F.count("transaction_id").alias("bid_count"),
    F.max("total_amount").alias("highest_bid")
)

result = (
    products.filter(F.col("in_stock") == 1)
    .join(transaction_stats, "product_id", "left")
    .join(ranked_bids, "product_id", "left")
    .select(
        "product_id",
        "product_name",
        F.coalesce("bid_count", F.lit(0)).alias("bid_count"),
        "highest_bid",
        F.col("user_id").alias("winner")
    )
    .orderBy("product_id")
)

result.show()
