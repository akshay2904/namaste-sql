"""PySpark solution for: Speed and Substance
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Calculate average duration and net output per pipeline
pipe_stats = (
    data_pipes
    .withColumn("net_output", F.col("rows_out") - 0.1 * F.col("rows_in"))
    .groupBy("pipe_name")
    .agg(
        F.avg(F.col("dur_secs")).alias("avg_dur"),
        F.avg(F.col("net_output")).alias("avg_net_output")
    )
)

# Calculate overall means of average duration and net output
means = (
    pipe_stats
    .agg(
        F.avg(F.col("avg_dur")).alias("dur_mean"),
        F.avg(F.col("avg_net_output")).alias("out_mean")
    )
)

# Perform Pearson correlation calculation
correlation = (
    pipe_stats
    .join(means, how="cross")
    .withColumn("dur_diff", F.col("avg_dur") - F.col("dur_mean"))
    .withColumn("out_diff", F.col("avg_net_output") - F.col("out_mean"))
    .withColumn("numerator", F.col("dur_diff") * F.col("out_diff"))
    .withColumn("denominator_dur", F.pow(F.col("dur_diff"), 2))
    .withColumn("denominator_out", F.pow(F.col("out_diff"), 2))
    .agg(
        F.sum(F.col("numerator")).alias("sum_numerator"),
        F.sum(F.col("denominator_dur")).alias("sum_denominator_dur"),
        F.sum(F.col("denominator_out")).alias("sum_denominator_out")
    )
    .withColumn(
        "correlation",
        F.round(
            F.col("sum_numerator") / \
            F.sqrt(F.col("sum_denominator_dur") * F.col("sum_denominator_out")),
            2
        )
    )
    .select("correlation")
)

correlation.show()
