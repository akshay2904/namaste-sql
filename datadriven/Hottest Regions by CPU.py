"""PySpark solution for: Hottest Regions by CPU
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by region, compute average cpu_pct rounded to 2 decimals, order by avg descending, limit 3
result = (infra_nodes
          .groupBy("region")
          .agg(F.round(F.avg("cpu_pct"), 2).alias("avg_cpu"))
          .orderBy(F.col("avg_cpu").desc())
          .limit(3))

result.show()
