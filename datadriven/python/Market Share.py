"""PySpark solution for: Market Share
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join transactions with products to get category
joined_df = transactions.join(products, transactions.product_id == products.product_id)

# Calculate total revenue per category and platform total
total_revenue = joined_df.agg(F.sum("total_amount").alias("total")).collect()[0][0]

result = (joined_df
    .groupBy("category")
    .agg((F.sum("total_amount") * 100.0 / total_revenue).alias("revenue_share_pct"))
    .withColumn("revenue_share_pct", F.round("revenue_share_pct", 2))
    .orderBy(F.desc("revenue_share_pct")))

result.select("category", "revenue_share_pct").show()
