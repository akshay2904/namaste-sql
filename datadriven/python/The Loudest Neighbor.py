"""PySpark solution for: The Loudest Neighbor
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define window to partition by namespace and order by memory used (desc), then pod name
window = Window.partitionBy("nspace").orderBy(F.col("mem_used").desc(), F.col("pod_name"))

# Filter out pods with no memory usage reported, then apply window and rank
ranked_pods = k8s_pods.filter(F.col("mem_used").isNotNull()) \
                       .withColumn("mem_rank", F.row_number().over(window)) \
                       .filter(F.col("mem_rank") == 1)

# Select desired columns and sort by memory used (desc), then namespace
result = ranked_pods.select("nspace", "pod_name", "mem_used") \
                     .orderBy(F.col("mem_used").desc(), F.col("nspace"))

# Display the result (in a real scenario, you'd likely write to a destination or assign to a variable)
result.show()
