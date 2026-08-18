"""PySpark solution for: The A/B Verdict
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F

# Import necessary functions
from pyspark.sql.functions import sum, when, col

# Group by exp_name and calculate conversions for control and treatment variants
result = (experiments
          .groupBy("exp_name")
          .agg(
              sum(when((col("variant") == "control") & (col("outcome") > 0), 1).otherwise(0)).alias("control_conversions"),
              sum(when((col("variant") == "treatment") & (col("outcome") > 0), 1).otherwise(0)).alias("treatment_conversions")
          )
          .orderBy("exp_name"))

result.show()
