"""PySpark solution for: The Costliest Trio
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Ranking top 200 expensive products (assuming 'price' is non-null already as per SQL)
ranked = products.orderBy(F.col("price").desc()).limit(200)

# Self-join with conditions to ensure a < b < c alphabetically
bundles = ranked.alias("a") \
    .join(ranked.alias("b"), F.col("a.product_name") < F.col("b.product_name")) \
    .join(ranked.alias("c"), F.col("b.product_name") < F.col("c.product_name"))

# Combine product names and calculate total cost
result = bundles.select(
    F.concat(F.col("a.product_name"), F.lit(","),
              F.col("b.product_name"), F.lit(","),
              F.col("c.product_name")).alias("combo"),
    (F.col("a.price") + F.col("b.price") + F.col("c.price")).alias("total_cost")
) \
    .orderBy(F.col("total_cost").desc(), F.col("combo").asc()) \
    .limit(100)
