"""PySpark solution for: Lowest CPU Pods per Namespace
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F, Window

# Add dense rank within each namespace ordered by cpu_used ascending
window_spec = Window.partitionBy("nspace").orderBy(F.col("cpu_used").asc())
ranked = k8s_pods.withColumn("rnk", F.dense_rank().over(window_spec))

# Filter to top 5 ranks per namespace and select required columns
result = ranked.filter(F.col("rnk") <= 5) \
    .select("pod_name", "nspace", "cpu_used", "mem_used") \
    .orderBy("nspace", "rnk")

result.show()
