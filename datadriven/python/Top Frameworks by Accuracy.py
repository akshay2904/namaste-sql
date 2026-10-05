"""PySpark solution for: Top Frameworks by Accuracy
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window specification
window = Window.orderBy(F.col('avg_accuracy').desc())

# Calculate the average accuracy for each framework and rank them
result = (ml_models
          .filter(F.col('accuracy').isNotNull())
          .filter(F.col('status') == 'Deployed')  # Filter for production models
          .groupBy(F.lower(F.col('framework')).alias('framework'))
          .agg(F.avg(F.col('accuracy')).alias('avg_accuracy'))
          .withColumn('rnk', F.rank().over(window))
          .filter(F.col('rnk') <= 3)
          .orderBy(F.col('avg_accuracy').desc())
          .select('framework', 'avg_accuracy'))

# Print the result
result.show()
