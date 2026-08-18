"""PySpark solution for: Only Here
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import lower, avg, round, col
from pyspark.sql import Window

# Normalize dtype to lowercase
ml_features = ml_features.withColumn("dtype", lower(col("dtype")))

# Define transactions features and exclude those present in other sources
transactions_features = ml_features.filter(col("source") == "transactions")
other_sources_filter = ml_features.filter(col("source").isin(["page_views", "ad_impressions"]))

# Anti-join to exclude features present in other sources
unique_transactions_features = transactions_features.join(
    other_sources_filter.withColumnRenamed("feat_name", "other_feat_name").withColumnRenamed("dtype", "other_dtype"),
    (transactions_features.feat_name == col("other_feat_name")) & (transactions_features.dtype == col("other_dtype")),
    how="left_anti"
)

# Aggregate and round results
result = unique_transactions_features.groupBy("feat_name", "dtype").agg(
    round(avg("avg_val"), 2).alias("avg_val"),
    round(avg("null_pct"), 2).alias("null_pct")
).orderBy("feat_name", "dtype")

result.show()
