"""PySpark solution for: Pod CPU to Memory Ratio
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter pending pods and calculate cpu to memory ratio
pending_pods = k8s_pods.filter((F.col("status") == "Pending") & (F.col("mem_used") > 0)) \
                       .withColumn("cpu_mem_ratio", F.col("cpu_used") / F.col("mem_used"))

# Calculate average ratio per namespace and rank them
result = pending_pods.groupBy("nspace").agg(F.avg("cpu_mem_ratio").alias("avg_cpu_mem_ratio")) \
                     .orderBy(F.col("avg_cpu_mem_ratio").desc())

result.show()
