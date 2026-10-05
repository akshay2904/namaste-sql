"""PySpark solution for: Consistent High-Quantity Revenue
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    transactions
    .groupBy("user_id", "product_id")
    .agg(
        F.sum("total_amount").alias("total_revenue"),
        F.min("quantity").alias("min_quantity")
    )
    .filter(F.col("min_quantity") >= 2)
    .drop("min_quantity")
    .orderBy(F.col("user_id").asc(), F.col("total_revenue").desc())
)

result.show()
