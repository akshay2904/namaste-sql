"""PySpark solution for: Services With Multi-Quarter Uptime
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import to_date, month, col, lower, floor, count_distinct, year

# Derive quarter from month and filter healthy checks in 2026
healthy_checks_2026 = svc_health.filter(
    (lower(col("status")) == "healthy") & 
    (year(col("checked")) == 2026)
).withColumn(
    "quarter", 
    floor((month(col("checked")) + 2) / 3).cast("integer")
).select("svc_name", "quarter")

# Count distinct quarters per service and filter those with >= 2 quarters
stable_services = healthy_checks_2026.groupBy("svc_name").agg(
    count_distinct("quarter").alias("quarter_count")
).filter(
    col("quarter_count") >= 2
).select("svc_name")

# Sort by svc_name as per SQL solution
stable_services = stable_services.orderBy("svc_name")

# Show the result (for demonstration; remove or replace with desired action)
stable_services.show()
