"""PySpark solution for: Cost Share Within Category
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Filter categories
filtered_df = cost_allocs.filter(
    F.col("category").isin("compute", "storage", "network")
)

# Calculate percentage of category total using window function
window_spec = Window.partitionBy("category")
result_df = filtered_df.withColumn(
    "pct_of_category",
    F.col("amount") / F.sum("amount").over(window_spec)
).select("alloc_id", "category", "amount", "pct_of_category")

# Order results
result_df = result_df.orderBy("category", "alloc_id")
