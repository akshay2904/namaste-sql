"""PySpark solution for: Overloaded Infrastructure Nodes
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import col

overloaded_nodes = infra_nodes.filter((col('cpu_pct') > 90) | (col('mem_pct') > 85)) \
                              .select('hostname', 'region', 'node_type') \
                              .distinct()
