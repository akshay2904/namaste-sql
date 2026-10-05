"""PySpark solution for: Error Category Breakdown
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Create category using CASE WHEN logic on error type
df_with_category = err_tracks.withColumn(
    "error_category",
    F.when(
        F.col("err_type").contains("timeout") | F.col("err_type").contains("connection"),
        "network"
    ).when(
        F.col("err_type").contains("auth") | F.col("err_type").contains("permission"),
        "security"
    ).otherwise("application")
)

# Group by category and count rows
result = df_with_category.groupBy("error_category").agg(
    F.count("*").alias("error_count")
).orderBy(F.desc("error_count"))

result.show()
