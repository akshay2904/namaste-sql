"""PySpark solution for: Experiment Impact
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Filter out null outcomes and aggregate by experiment/variant
exp_avgs = (
    experiments
    .filter(F.col("outcome").isNotNull())
    .groupBy("exp_name", "variant")
    .agg(
        F.avg("outcome").alias("avg_out"),
        F.count("*").alias("participants")
    )
)

# Tier standing: dense rank
tier_window = Window.partitionBy("variant").orderBy(F.col("avg_out").desc())
result = exp_avgs.withColumn("tier", F.dense_rank().over(tier_window))

# Competition standing: self-join to count strictly higher averages
result_alias1 = result.alias("e1")
result_alias2 = result.alias("e2")

competition = result_alias1.join(
    result_alias2,
    (F.col("e1.variant") == F.col("e2.variant")) & (F.col("e2.avg_out") > F.col("e1.avg_out")),
    "left"
).groupBy(
    "e1.exp_name", "e1.variant", "e1.avg_out", "e1.participants", "e1.tier"
).agg(
    (F.count("e2.exp_name") + 1).alias("rnk")
)

result = competition.select(
    "exp_name", "variant", "avg_out", "participants", "rnk", "tier"
).orderBy("variant", "rnk", "exp_name")

result.show()
