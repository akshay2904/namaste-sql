"""PySpark solution for: Spending Tiers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by user_id and calculate total spending
totals = transactions.groupBy('user_id').agg(F.sum('total_amount').alias('total'))

# Use when to create tier labels
tier_labels = totals.withColumn('tier', 
                                F.when(F.col('total') > 500, 'high')
                                .when(F.col('total') >= 200, 'medium')
                                .otherwise('low'))

# Select user_id and tier columns
result = tier_labels.select('user_id', 'tier')
