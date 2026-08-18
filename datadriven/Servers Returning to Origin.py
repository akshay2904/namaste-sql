"""PySpark solution for: Servers Returning to Origin
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define window for each node_id to get first and last region
window_spec = Window.partitionBy("node_id").orderBy("node_id").rowsBetween(Window.unboundedPreceding, Window.unboundedFollowing)

# Calculate first and last region for each node_id
infra_nodes_with_regions = infra_nodes.withColumn("first_region", F.first("region").over(window_spec)) \
                                      .withColumn("last_region", F.last("region").over(window_spec))

# Filter and count nodes where first and last regions match
servers_returning = infra_nodes_with_regions.filter(F.col("first_region") == F.col("last_region")) \
                                             .select(F.countDistinct("node_id").alias("servers_returning"))

# Display the result (assuming you want to see the output)
servers_returning.show()
