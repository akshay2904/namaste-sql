"""PySpark solution for: Above the Line
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Monthly total spend per service
monthly_svc = cloud_costs.filter(F.col("bill_date").isNotNull()) \
    .groupBy("svc_name", F.date_format("bill_date", "yyyy-MM").alias("month")) \
    .agg(F.sum("amount").alias("total_spend"))

# Percentage of services hitting the threshold
result = monthly_svc.groupBy("month") \
    .agg(F.sum(F.when(F.col("total_spend") >= 100, 1).otherwise(0)).alias("hitting_threshold"),
         F.count("*").alias("total_services")) \
    .select("month", (F.col("hitting_threshold") / F.col("total_services")) * 100.0) \
    .withColumnRenamed("(hitting_threshold / total_services) * 100.0", "pct_hitting_threshold") \
    .orderBy("month")
