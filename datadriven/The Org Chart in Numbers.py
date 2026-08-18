"""PySpark solution for: The Org Chart in Numbers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Aggregate counts per department and quarter, then pivot
result = (
    employee_metrics
    .groupBy("department", "fiscal_quarter")
    .agg(F.count("metric_id").alias("cnt"))
    .groupBy("department")
    .pivot("fiscal_quarter", ["Q1", "Q2", "Q3", "Q4"])
    .agg(F.coalesce(F.first("cnt"), F.lit(0)).alias("cnt"))
    .select(
        "department",
        F.col("Q1").alias("q1"),
        F.col("Q2").alias("q2"),
        F.col("Q3").alias("q3"),
        F.col("Q4").alias("q4")
    )
)

result.show()
