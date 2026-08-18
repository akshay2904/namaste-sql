"""PySpark solution for: The Undone
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    migrations
    .groupBy("db_name")
    .agg(
        F.count("*").alias("total_migrations"),
        F.sum(F.when(F.lower(F.col("status")) == "rolled_back", 1).otherwise(0)).alias("total_rollbacks")
    )
    .filter(F.col("total_rollbacks") > 0)
    .orderBy(F.col("total_rollbacks").desc(), F.col("db_name"))
)

result.select("db_name", "total_migrations", "total_rollbacks").show()
