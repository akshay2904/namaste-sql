# 46. Most Common Tag per Category

**Difficulty:** hard  
**Tags:** explode, rank, spark specific  
**Source:** https://spark.vutrinh.net/problems/most_common_tag

## Problem

Given a table `articles` with columns `article_id`, `title`, `category`, and `tags` (a comma-separated string of tags), find the **most frequently used tag within each category**.

Return columns: `category`, `tag`, `tag_count`

Only return the top-ranked tag per category (rank = 1). If there is a tie for top tag within a category, return all tied tags.

Order by `category` ASC.

## Schema

**`articles`**

| column | type |
|---|---|
| article_id | INT |
| title | STRING |
| category | STRING |
| tags | STRING |

## Sample Input

**`articles`**

| article_id | title | category | tags |
|---|---|---|---|
| 1 | Introduction to Spark | Data Engineering | spark,big-data,distributed |
| 2 | Python for Data Science | Machine Learning | python,data-science,ml |
| 3 | Deep Learning Basics | Machine Learning | ml,deep-learning,python |
| 4 | Spark Streaming Guide | Data Engineering | spark,streaming,big-data |
| 5 | SQL vs NoSQL | Data Engineering | sql,databases,big-data |

## Hints

<details><summary>Hint 1</summary>

`RANK()` is a window function that assigns the same rank to tied values but leaves gaps afterward. Here, each category gets its own ranking partition so that the tag with the highest count within that category gets rank 1. Combining `EXPLODE`/`SPLIT` with a window `RANK` is the standard Spark pattern for "top N per group" problems.

</details>

<details><summary>Hint 2</summary>

1. Use a subquery to `EXPLODE(SPLIT(tags, ','))` to get one row per tag per article.
2. In an intermediate layer, `GROUP BY category, tag` and `COUNT(*)` to get `tag_count`.
3. Apply `RANK() OVER (PARTITION BY category ORDER BY tag_count DESC)` to rank tags within each category.
4. Filter to `rnk = 1` and order by `category`.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT category, tag, tag_count
FROM (
  SELECT category, tag, COUNT(*) AS tag_count,
         RANK() OVER (PARTITION BY category ORDER BY COUNT(*) DESC) AS rnk
  FROM (
    SELECT category, EXPLODE(SPLIT(tags, ',')) AS tag
    FROM articles
  )
  GROUP BY category, tag
)
WHERE rnk = 1
ORDER BY category
```

</details>

## Solutions

### SQL

```sql
SELECT category, tag, tag_count
FROM (
  SELECT category, tag, COUNT(*) AS tag_count,
         RANK() OVER (PARTITION BY category ORDER BY COUNT(*) DESC) AS rnk
  FROM (
    SELECT category, EXPLODE(SPLIT(tags, ',')) AS tag
    FROM articles
  )
  GROUP BY category, tag
)
WHERE rnk = 1
ORDER BY category
```

**Why it works:**
- The innermost subquery explodes the comma-separated `tags` string into individual rows per category.
- The middle layer counts occurrences of each tag within each category.
- `RANK() OVER (PARTITION BY category ORDER BY COUNT(*) DESC)` ranks tags from most to least frequent within each category; ties both receive rank 1.
- The outer filter `WHERE rnk = 1` keeps only the top tag(s) per category.

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

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
```

**Why it works:**
- `F.explode(F.split(...))` unpacks the comma-separated tags into individual rows.
- After grouping and counting, a `Window` partitioned by `category` and ordered by `tag_count DESC` lets `F.rank()` assign the same rank to tied values.
- Filtering `rnk == 1` selects only the most common tag(s) per category.
