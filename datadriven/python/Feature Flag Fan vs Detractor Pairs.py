"""PySpark solution for: Feature Flag Fan vs Detractor Pairs
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
import pyspark.sql.functions as F

# Rank enabled users by rollout descending, disabled users by rollout ascending
fan_window = Window.orderBy(F.col("rollout").desc(), F.col("flag_id").asc())
opponent_window = Window.orderBy(F.col("rollout").asc(), F.col("flag_id").asc())

fans = feat_flags.filter(F.col("enabled") == 1) \
    .select("owner", F.row_number().over(fan_window).alias("rn"))

opponents = feat_flags.filter(F.col("enabled") == 0) \
    .select("owner", F.row_number().over(opponent_window).alias("rn"))

# Pair fans with opponents by rank, using aliases to avoid ambiguity
result = fans.alias("f").join(opponents.alias("o"), F.col("f.rn") == F.col("o.rn")) \
    .select(
        F.col("f.owner").alias("fan_owner"),
        F.col("o.owner").alias("opponent_owner")
    ) \
    .orderBy("f.rn")

result.show()
