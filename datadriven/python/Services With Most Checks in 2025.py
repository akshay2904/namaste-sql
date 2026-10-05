"""PySpark solution for: Services With Most Checks in 2025
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate yearly check counts with alias 'chk_count'
yearly_counts = svc_health.groupBy("svc_name", F.year("checked").alias("chk_year")).agg(F.count("*").alias("chk_count"))

# Correctly reference 'chk_count' in aggregation
max_other_year_count = yearly_counts.filter(F.col("chk_year") != 2026).groupBy("svc_name").agg(F.max("chk_count").alias("max_other_year_count"))

# Join yearly counts with max other year counts
yearly_counts_joined = yearly_counts.join(max_other_year_count, on="svc_name", how="left")

# Filter for services whose 2026 check count matches or beats every other year
# Handle cases where a service only has 2026 data (left join may return NULL)
y2026_counts = yearly_counts_joined.filter((F.col("chk_year") == 2026) & (
    (F.col("chk_count") >= F.col("max_other_year_count")) |
    F.col("max_other_year_count").isNull()  # Handle services with only 2026 data
)).select("svc_name", "chk_count")

# Sort by check count in descending order and then by svc_name in ascending order
result = y2026_counts.orderBy(F.col("chk_count").desc(), F.col("svc_name").asc())
