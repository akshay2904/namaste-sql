"""PySpark solution for: Top 10 CPU-Heavy Nodes
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import col
from pyspark.sql import Window

infra_nodes.select('node_id', 'hostname', 'cpu_pct') \
    .orderBy(col('cpu_pct').desc(), col('node_id').asc()) \
    .limit(10)
