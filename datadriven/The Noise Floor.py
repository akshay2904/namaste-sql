"""PySpark solution for: The Noise Floor
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Define a function to calculate high urgency percentage
def calculate_high_urgency(df):
    return df.groupBy("svc_name") \
        .agg(F.round(100.0 * F.sum(F.when(F.lower(F.col("severity")).isin(['critical', 'high']), 1).otherwise(0)) / F.count("*"), 1).alias("high_urgency_pct")) \
        .filter(F.col("high_urgency_pct") / 100.0 > 0.5) \
        .orderBy(F.col("high_urgency_pct").desc(), F.col("svc_name"))

# Calculate high urgency percentage for alert_events
high_urgency_df = calculate_high_urgency(alert_events)

# Show the results
high_urgency_df.show()
