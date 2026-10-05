"""PySpark solution for: Two Sides of the Ledger
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Union cloud_costs and cost_allocs with proper alias handling
all_events = (
    cloud_costs
    .withColumn("amt", -F.col("amount").cast("double"))  # Use withColumn for clarity
    .withColumn("event_date", F.substring("bill_date", 1, 7))
    .select("region", "amt", "event_date")
    .unionByName(  # Use unionByName for aligned column names
        cost_allocs
        .withColumn("amt", F.col("amount").cast("double"))
        .withColumn("event_date", F.col("period"))
        .select("region", "amt", "event_date")  # Select only relevant columns
    )
)

# Group by region and event_date to sum amounts
monthly = all_events.groupBy("region", "event_date").agg(F.sum("amt").alias("amt"))

# Define window spec for running balance calculation
window_spec = Window.partitionBy("region").orderBy("event_date").rowsBetween(Window.unboundedPreceding, Window.currentRow)

# Calculate running balance and order results
result = (
    monthly
    .withColumn("running_balance", F.sum("amt").over(window_spec))
    .orderBy("region", "event_date")
    .select("region", "event_date", "amt", "running_balance")  # Select in desired order
)

# Display the result (optional, for verification)
result.show()
