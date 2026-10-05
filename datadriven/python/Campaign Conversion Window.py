"""PySpark solution for: Campaign Conversion Window
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Convert impression_time to date for joins
ad_impressions = ad_impressions.withColumn("impression_date", F.to_date("impression_time"))

# Join with transactions on user_id, clicked=1, and transaction within 0-7 days of impression
joined_df = ad_impressions.alias("ai").join(
    transactions.alias("t"),
    (F.col("ai.user_id") == F.col("t.user_id")) & 
    (F.col("ai.clicked") == 1) & 
    (F.datediff(F.col("t.transaction_date"), F.col("ai.impression_date")).between(0, 7)),
    "left"
)

# Aggregate per campaign
result_df = joined_df.groupBy("ai.ad_campaign").agg(
    F.count("*").alias("impressions"),
    F.sum("ai.clicked").alias("clicks"),
    F.round(F.sum("ai.clicked") / F.count("*") * 100, 2).alias("ctr_pct"),
    # Count distinct users who clicked and converted
    F.countDistinct(
        F.when((F.col("ai.clicked") == 1) & (F.col("t.transaction_id").isNotNull()), F.col("ai.user_id"))
    ).alias("conversions"),
    # Conversion rate = conversions / distinct clickers * 100
    F.round(
        F.countDistinct(
            F.when((F.col("ai.clicked") == 1) & (F.col("t.transaction_id").isNotNull()), F.col("ai.user_id"))
        ) / 
        F.when(
            F.countDistinct(F.when(F.col("ai.clicked") == 1, F.col("ai.user_id"))) > 0,
            F.countDistinct(F.when(F.col("ai.clicked") == 1, F.col("ai.user_id")))
        ).otherwise(None) * 100,
        2
    ).alias("conversion_rate_pct")
)

# Filter campaigns with at least 3 impressions and sort
final_result = result_df \
    .filter(F.col("impressions") >= 3) \
    .orderBy(F.col("conversion_rate_pct").desc())

# Select columns in expected order
final_result = final_result.select("ad_campaign", "impressions", "clicks", "ctr_pct", "conversions", "conversion_rate_pct")

final_result.show()
