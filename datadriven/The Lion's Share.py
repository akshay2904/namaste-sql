"""PySpark solution for: The Lion's Share
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Perform inner join on product_id
joined_df = transactions.join(products, "product_id", "inner")

# Calculate total revenue and transaction count per category
category_revenue = joined_df.groupBy("category").agg(
    F.sum("total_amount").alias("total_revenue"),
    F.count("*").alias("transaction_count")
)

# Calculate total revenue across all categories for percentage calculation
total_revenue_sum = category_revenue.agg(F.sum("total_revenue").alias("total_revenue_sum")).collect()[0]["total_revenue_sum"]

# Calculate revenue share and sort
category_revenue_with_share = (
    category_revenue
    .withColumn("revenue_share_pct", F.round(F.col("total_revenue") * 100.0 / F.lit(total_revenue_sum), 2))
    .orderBy(F.col("total_revenue").desc(), F.col("category").asc())
    .select("category", "total_revenue", "transaction_count", "revenue_share_pct")
)

# Show the result
category_revenue_with_share.show()
