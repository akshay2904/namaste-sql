"""PySpark solution for: The Accumulator
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Group by bill_date to calculate daily spend
daily_spend_df = cloud_costs.groupBy("bill_date").agg(F.sum("amount").alias("daily_spend"))

# Window to calculate cumulative spend, ordered by bill_date
window_spec = Window.orderBy("bill_date")

# Calculate cumulative spend using the window
result_df = daily_spend_df.withColumn(
    "cumulative_spend", 
    F.sum("daily_spend").over(window_spec)
).orderBy("bill_date")  # Order the final result

# Select only the required columns (though already filtered in groupBy/agg)
result_df = result_df.select("bill_date", "daily_spend", "cumulative_spend")
