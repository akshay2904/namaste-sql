"""PySpark solution for: Unsold Product Categories
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Get distinct product ids from transactions
sold_product_ids = transactions.select("product_id").distinct()

# Left join with products to identify unsold products
unsold_products = products.join(sold_product_ids, "product_id", "left_outer") \
                           .withColumn("is_unsold", F.when(F.col("product_id").isNull(), 1).otherwise(0))

# Calculate unsold percentage per category
unsold_pct = unsold_products.groupBy("category") \
                             .agg(
                                 F.sum("is_unsold").alias("unsold_count"),
                                 F.countDistinct("product_id").alias("total_products")
                             ) \
                             .withColumn("unsold_pct", (F.col("unsold_count") / F.col("total_products")) * 100.0) \
                             .select("category", "unsold_pct")
