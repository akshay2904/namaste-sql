"""PySpark solution for: Time Served
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter active tokens
active_tokens = api_tokens.withColumn("is_active", F.expr("expires IS NULL OR expires >= CURRENT_DATE")) \
                           .filter(F.col("is_active")) \
                           .select("scope", "issued") \
                           .drop("is_active")  # Cleanup

# Calculate min and max issued dates per scope
bounds = active_tokens.groupBy("scope") \
                      .agg(F.min("issued").alias("min_issued"), F.max("issued").alias("max_issued"))

# Join and calculate day spread & token counts
result = bounds.join(active_tokens, on="scope", how="inner") \
                .withColumn("day_spread", (F.to_date("max_issued") - F.to_date("min_issued")).cast("integer")) \
                .groupBy("scope", "day_spread", "min_issued", "max_issued") \
                .agg(
                    F.count(F.when(F.col("issued") == F.col("min_issued"), "issued")).alias("tokens_at_earliest"),
                    F.count(F.when(F.col("issued") == F.col("max_issued"), "issued")).alias("tokens_at_latest")
                ) \
                .select("scope", "day_spread", "tokens_at_earliest", "tokens_at_latest") \
                .orderBy(F.col("day_spread").desc(), F.col("scope"))
