"""PySpark solution for: Nodes by Region and Type
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

infra_nodes.groupBy("region", "node_type") \
            .count() \
            .withColumnRenamed("count", "node_count") \
            .orderBy("region") \
            .show()
