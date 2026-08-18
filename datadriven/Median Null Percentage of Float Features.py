"""PySpark solution for: Median Null Percentage of Float Features
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

float_features = ml_features.filter(
    F.lower(F.col("dtype")).contains("float") & F.col("null_pct").isNotNull()
).select("null_pct")

# Compute total count for median calculation
total_count = float_features.count()

# Create a window ordered by null_pct to assign row numbers
window_spec = Window.orderBy("null_pct")
ranked = float_features.withColumn(
    "rn", F.row_number().over(window_spec)
).withColumn("total", F.lit(total_count))

# For even total, average the two middle values; for odd, single middle value
result = ranked.filter(
    (F.col("rn") == (F.col("total") + 1) / 2) |
    (F.col("rn") == (F.col("total") + 2) / 2)
).agg(F.avg("null_pct").alias("median_null_pct"))

# Display result (optional in real use; here to show output)
median_null_pct = result.select("median_null_pct")
median_null_pct.show()
