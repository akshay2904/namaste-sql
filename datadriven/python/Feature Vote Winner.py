"""PySpark solution for: Feature Vote Winner
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Count votes per owner
voter_counts = (
    feat_flags
    .filter(F.col("owner").isNotNull())
    .groupBy("owner")
    .agg(F.count("*").alias("num_votes"))
)

# Calculate effective votes per flag
weighted = (
    feat_flags
    .filter(F.col("owner").isNotNull())
    .join(voter_counts, on="owner", how="inner")
    .groupBy("flag_name")
    .agg(F.sum(1.0 / F.col("num_votes")).alias("effective_votes"))
)

# Find max effective votes and filter ties
max_votes = weighted.agg(F.max("effective_votes")).collect()[0][0]

result = (
    weighted
    .filter(F.col("effective_votes") == max_votes)
    .select("flag_name", "effective_votes")
    .orderBy("flag_name")
)
