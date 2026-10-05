"""PySpark solution for: Top Spender
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Compute max product price
max_product_price = products.select(F.max("price").alias("max_price")).first().max_price

# Join, aggregate, filter, and sort
result = (
    users
    .join(transactions, "user_id", "inner")
    .groupBy("user_id", "username")
    .agg(F.sum("total_amount").alias("total_spend"))
    .filter(F.col("total_spend") > max_product_price)
    .orderBy(F.col("total_spend").desc(), F.col("username").asc())
    .select("username", "total_spend")
)

# Display or show results (depending on Spark environment)
result.show()
