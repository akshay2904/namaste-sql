"""PySpark solution for: Yesterday's Crown
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define daily totals with bill_day as date (assuming bill_date is string or timestamp)
daily_totals = cloud_costs.withColumn("bill_day", F.to_date("bill_date")) \
    .groupBy("bill_day", "svc_name") \
    .agg(F.round(F.sum("amount"), 2).alias("total_amount"))

# Generate day grid with previous day, ensuring all distinct days are present
day_grid = daily_totals.select("bill_day").distinct() \
    .withColumn("prev_day", F.lag("bill_day").over(Window.orderBy("bill_day")))

# Rank services by spending per day, handling potential ties
ranked = daily_totals.withColumn("rnk", 
                                 F.dense_rank().over(Window.partitionBy("bill_day").orderBy(F.col("total_amount").desc())))

# Corrected join logic to link day_grid with ranked services based on previous day
result = day_grid.alias("g") \
    .join(ranked.alias("r"), (F.col("g.prev_day") == F.col("r.bill_day")) & (F.col("r.rnk") == 1), "inner") \
    .filter(F.col("g.prev_day").isNotNull()) \
    .select(F.col("g.bill_day").alias("bill_day"), F.col("r.svc_name"), F.col("r.total_amount")) \
    .orderBy("bill_day", "svc_name")
