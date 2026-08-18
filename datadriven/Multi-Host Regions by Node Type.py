"""PySpark solution for: Multi-Host Regions by Node Type
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = infra_nodes \
    .filter(F.col("node_type").isin(['compute', 'storage', 'network', 'gpu'])) \
    .groupBy("region") \
    .agg(F.countDistinct("hostname").alias("unique_hostnames")) \
    .filter(F.col("unique_hostnames") > 2) \
    .orderBy("region") \
    .select("region")
