"""PySpark solution for: Three-Value Sum Combinations
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (employee_metrics.alias("e1")
          .crossJoin(employee_metrics.alias("e2"))
          .crossJoin(employee_metrics.alias("e3"))
          .where((F.col("e1.metric_id") < F.col("e2.metric_id")) & 
                 (F.col("e2.metric_id") < F.col("e3.metric_id")) & 
                 (F.col("e1.metric_value") + F.col("e2.metric_value") + F.col("e3.metric_value") == 25))
          .select(F.col("e1.metric_value").alias("val1"), 
                  F.col("e2.metric_value").alias("val2"), 
                  F.col("e3.metric_value").alias("val3")))
