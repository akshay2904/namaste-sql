"""PySpark solution for: The Footprint
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

infra_nodes.groupBy('region') \
            .count() \
            .withColumnRenamed('count', 'node_count') \
            .orderBy('node_count', 'region', ascending=False) \
            .show()
