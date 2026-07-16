"""
Tally Election Results  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/tally_election

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("tally_election").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_votes_rows = [{"vote_id": "1", "voter_id": "101", "candidate": "Alice", "district": "North"}, {"vote_id": "2", "voter_id": "102", "candidate": "Alice", "district": "North"}, {"vote_id": "3", "voter_id": "103", "candidate": "Bob", "district": "North"}, {"vote_id": "4", "voter_id": "104", "candidate": "Alice", "district": "North"}, {"vote_id": "5", "voter_id": "105", "candidate": "Charlie", "district": "North"}]
votes = _make_df(_votes_rows, ['vote_id', 'voter_id', 'candidate', 'district']).select(
    F.col("vote_id").cast("int").alias("vote_id"),
    F.col("voter_id").cast("int").alias("voter_id"),
    F.col("candidate"),
    F.col("district")
)

df = votes  # single input table also bound as df

# ---- solution ----
w = Window.partitionBy("district").orderBy(F.col("votes").desc())

result = (
    votes
    .groupBy("district", "candidate")
    .agg(F.count("*").alias("votes"))
    .withColumn("rnk", F.rank().over(w))
    .filter(F.col("rnk") == 1)
    .select("district", "candidate", "votes")
    .orderBy("district")
)

result.show()


spark.stop()
