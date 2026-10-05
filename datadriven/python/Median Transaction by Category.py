"""PySpark solution for: Median Transaction by Category
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
import pyspark.sql.functions as F

# Join transactions and products to get category info
joined_df = transactions.join(products, transactions.product_id == products.product_id, "inner") \
    .select(products.category, transactions.total_amount)

# Define window for row numbering and counting per category
window_spec = Window.partitionBy("category").orderBy("total_amount")

# Add row number and count per category
ranked_df = joined_df \
    .withColumn("rn", F.row_number().over(window_spec)) \
    .withColumn("cnt", F.count("*").over(Window.partitionBy("category")))

# Select rows where rn is the middle position(s) for median calculation
median_rows = ranked_df.filter(
    (F.col("rn") == (F.col("cnt") + 1) / 2) | 
    (F.col("rn") == (F.col("cnt") + 2) / 2)
)

# Calculate median as average of the middle row(s) per category
result = median_rows.groupBy("category") \
    .agg(F.avg("total_amount").alias("median_amount")) \
    .orderBy("category")

result.show()
