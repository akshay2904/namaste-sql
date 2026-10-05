"""PySpark solution for: The Clean Aisle Numbers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Deduplicate transactions, keeping the earliest transaction_id per group
window_spec = Window.partitionBy(
    "user_id", "product_id", "total_amount", "transaction_date"
).orderBy("transaction_id")

deduped = transactions.withColumn(
    "rn", F.row_number().over(window_spec)
).filter(F.col("rn") == 1)

# Join with products, filter positive amounts, and aggregate by category
result = (
    deduped.alias("d")
    .join(products.alias("p"), F.col("d.product_id") == F.col("p.product_id"))
    .filter(F.col("d.total_amount") > 0)
    .groupBy("p.category")
    .agg(F.sum("d.total_amount").alias("total_sales"))
    .select("category", "total_sales")
)

result.show()
