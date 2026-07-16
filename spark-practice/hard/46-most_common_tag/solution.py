"""
Most Common Tag per Category  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/most_common_tag

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("most_common_tag").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_articles_rows = [{"article_id": "1", "title": "Introduction to Spark", "category": "Data Engineering", "tags": "spark,big-data,distributed"}, {"article_id": "2", "title": "Python for Data Science", "category": "Machine Learning", "tags": "python,data-science,ml"}, {"article_id": "3", "title": "Deep Learning Basics", "category": "Machine Learning", "tags": "ml,deep-learning,python"}, {"article_id": "4", "title": "Spark Streaming Guide", "category": "Data Engineering", "tags": "spark,streaming,big-data"}, {"article_id": "5", "title": "SQL vs NoSQL", "category": "Data Engineering", "tags": "sql,databases,big-data"}]
articles = _make_df(_articles_rows, ['article_id', 'title', 'category', 'tags']).select(
    F.col("article_id").cast("int").alias("article_id"),
    F.col("title"),
    F.col("category"),
    F.col("tags")
)

df = articles  # single input table also bound as df

# ---- solution ----
exploded = df.select("category", F.explode(F.split("tags", ",")).alias("tag"))

counts = exploded.groupBy("category", "tag").agg(F.count("*").alias("tag_count"))

w = Window.partitionBy("category").orderBy(F.col("tag_count").desc())

result = (
    counts
    .withColumn("rnk", F.rank().over(w))
    .filter(F.col("rnk") == 1)
    .select("category", "tag", "tag_count")
    .orderBy("category")
)

result.show(truncate=False)

spark.stop()
