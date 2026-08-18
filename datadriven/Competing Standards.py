"""PySpark solution for: Competing Standards
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Step 1: Calculate framework counts and average accuracy per model-framework
fw_counts = ml_models.groupBy('mdl_name', 'framework').agg(
    F.countDistinct('version').alias('ver_count'),
    F.avg('accuracy').alias('avg_acc')
)

# Step 2: Rank frameworks per model by version count (desc) and avg accuracy (desc)
window_primary = Window.partitionBy('mdl_name').orderBy(
    F.col('ver_count').desc(),
    F.col('avg_acc').desc()
)
primary_fw = fw_counts.withColumn('rn', F.row_number().over(window_primary))

# Step 3: Select primary framework per model (top rank)
best = primary_fw.filter(F.col('rn') == 1).select('mdl_name', 'framework', 'avg_acc')

# Step 4: Rank best frameworks by average accuracy (desc) with dense ranking
window_ranked = Window.orderBy(F.col('avg_acc').desc())
ranked = best.withColumn('rnk', F.dense_rank().over(window_ranked))

# Step 5: Filter top 3 ranked and sort by average accuracy (desc)
result = ranked.filter(F.col('rnk') <= 3).orderBy(F.col('avg_acc').desc()).select('mdl_name', 'framework', 'avg_acc')

result.show()
