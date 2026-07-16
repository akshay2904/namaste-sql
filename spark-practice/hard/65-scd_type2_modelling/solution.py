"""
Slowly Changing Dimension Type 2 Modelling  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/scd_type2_modelling

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("scd_type2_modelling").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_players_rows = [{"player_name": "Mike", "scoring_class": "Star", "is_active": "true", "season": "2018"}, {"player_name": "Mike", "scoring_class": "Star", "is_active": "true", "season": "2019"}, {"player_name": "Mike", "scoring_class": "Good", "is_active": "true", "season": "2020"}, {"player_name": "Mike", "scoring_class": "Good", "is_active": "false", "season": "2021"}, {"player_name": "Mike", "scoring_class": "Good", "is_active": "true", "season": "2022"}]
players = _make_df(_players_rows, ['player_name', 'scoring_class', 'is_active', 'season']).select(
    F.col("player_name"),
    F.col("scoring_class"),
    F.col("is_active").cast("boolean").alias("is_active"),
    F.col("season").cast("int").alias("season")
)

df = players  # single input table also bound as df

# ---- solution ----
w = Window.partitionBy("player_name").orderBy("season")

changes = (
    df
    .withColumn("prev_class", F.lag("scoring_class").over(w))
    .withColumn("prev_active", F.lag("is_active").over(w))
    .withColumn(
        "is_change",
        F.when(
            F.col("prev_class").isNull()
            | (F.col("scoring_class") != F.col("prev_class"))
            | (F.col("is_active") != F.col("prev_active")),
            1,
        ).otherwise(0),
    )
    .withColumn("streak_id", F.sum("is_change").over(w))
    .withColumn(
        "current_season",
        F.max("season").over(Window.partitionBy("player_name")),
    )
)

result = (
    changes
    .groupBy(
        "player_name",
        "streak_id",
        "scoring_class",
        "is_active",
        "current_season",
    )
    .agg(
        F.min("season").alias("start_season"),
        F.max("season").alias("end_season"),
    )
    .select(
        "player_name",
        "scoring_class",
        "is_active",
        "current_season",
        "start_season",
        "end_season",
    )
    .orderBy("player_name", "start_season")
)

result.show(truncate=False)

spark.stop()
