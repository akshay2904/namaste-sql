"""PySpark solution for: Top CPU Pods per Namespace
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Rank pods by CPU usage within each namespace
ranked = k8s_pods.withColumn("rn", 
                            F.row_number().over(
                                Window.partitionBy("nspace").orderBy(F.col("cpu_used").desc(), F.col("pod_name").asc())
                            ))
        
# Filter top 2 rows per namespace and pivot
top_pods = ranked.filter(F.col("rn") <= 2)
result = top_pods.groupBy("nspace").agg(
    F.max(F.when(F.col("rn") == 1, F.col("pod_name"))).alias("highest_cpu_pod"),
    F.max(F.when(F.col("rn") == 2, F.col("pod_name"))).alias("second_highest_cpu_pod")
).orderBy("nspace")

#Result DataFrame is now 'result'
