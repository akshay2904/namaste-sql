"""PySpark solution for: Where the Fleet Lives
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

regions = ['us-east-1', 'us-west-2', 'eu-west-1', 'eu-central-1', 'ap-southeast-1', 'ap-northeast-1']

filtered_nodes = infra_nodes.filter(infra_nodes.region.isin(regions))
node_counts = filtered_nodes.groupBy('region').count()  # Removed .alias('node_count') here
ordered_node_counts = node_counts.orderBy(F.col('count').desc(), F.col('region'))  # Changed 'node_count' to 'count'
result = ordered_node_counts.select('region', 'count')  # Changed 'node_count' to 'count'
result.show()
