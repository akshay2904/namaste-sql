"""PySpark solution for: Diverse Shoppers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    users.join(transactions, users.user_id == transactions.user_id, "inner")
    .groupBy(users.user_id, users.username)
    .agg(
        F.countDistinct("product_id").alias("distinct_products"),
        F.sum("total_amount").alias("total_spend")
    )
    .filter(F.col("distinct_products") >= 2)
    .orderBy(F.col("total_spend").desc())
    .select("username", "distinct_products", "total_spend")
)
result.show()
