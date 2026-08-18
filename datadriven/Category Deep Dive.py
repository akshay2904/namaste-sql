"""PySpark solution for: Category Deep Dive
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Join products and transactions on product_id, group by category, and aggregate
result = (
    products.join(transactions, on="product_id", how="inner")
    .groupBy("category")
    .agg(
        F.sum("total_amount").alias("total_revenue"),
        F.sum("quantity").alias("total_units")
    )
)

# Add position using RANK() over revenue descending
window_spec = Window.orderBy(F.col("total_revenue").desc())
result = result.withColumn("position", F.rank().over(window_spec))

# Select required columns
result = result.select("category", "total_revenue", "total_units", "position")

result.show()
