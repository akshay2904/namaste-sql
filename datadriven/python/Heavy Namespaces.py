"""PySpark solution for: Heavy Namespaces
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

k8s_pods.groupBy("nspace") \
    .agg(F.count("*").alias("pod_count")) \
    .filter(F.col("pod_count") > 3)
