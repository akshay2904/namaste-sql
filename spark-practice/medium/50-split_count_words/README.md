# 50. Split and Count Words

**Difficulty:** medium  
**Tags:** split, explode, string functions  
**Source:** https://spark.vutrinh.net/problems/split_count_words

## Problem

Given a table `reviews` with columns `review_id`, `product_id`, and `review_text`, find the top 5 most common words across all reviews.

Rules:
- Convert all words to lowercase before counting.
- Exclude words shorter than 3 characters.
- Exclude these stop words: `the`, `and`, `for`, `this`, `was`, `very`, `are`, `with`, `that`.
- Words are separated by spaces.

Return columns: `word`, `count`

Order by `count` DESC, then `word` ASC. Limit to 5 rows.

## Schema

**`reviews`**

| column | type |
|---|---|
| review_id | INT |
| product_id | INT |
| review_text | STRING |

## Sample Input

**`reviews`**

| review_id | product_id | review_text |
|---|---|---|
| 1 | 101 | great product love quality great packaging great delivery |
| 2 | 101 | love product amazing quality product works great |
| 3 | 102 | product quality excellent love packaging excellent |
| 4 | 102 | quality product amazing delivery love great product |
| 5 | 103 | excellent product love quality delivery fast amazing |

## Hints

<details><summary>Hint 1</summary>

To count word frequencies you need to first "explode" each review into individual words, then aggregate by word.

Key functions:
- `SPLIT(str, delimiter)` — splits a string into an array of strings
- `EXPLODE(array)` — turns each array element into a separate row
- `LOWER(str)` — converts string to lowercase
- `LENGTH(str)` — number of characters in a string
- `GROUP BY` + `COUNT(*)` — count occurrences of each word

</details>

<details><summary>Hint 2</summary>

1. Use `LOWER(review_text)` to normalize case.
2. Use `SPLIT(text, ' ')` to split each review into an array of words.
3. Use `EXPLODE(...)` to turn each word into its own row.
4. Filter out words shorter than 3 characters with `LENGTH(word) >= 3`.
5. Filter out stop words with `word NOT IN ('the', 'and', ...)`.
6. `GROUP BY word` and `COUNT(*)` to get frequencies.
7. Order by `count DESC`, then `word ASC`, and `LIMIT 5`.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT word, COUNT(*) AS count
FROM (
  SELECT LOWER(EXPLODE(SPLIT(review_text, ' '))) AS word
  FROM reviews
)
WHERE LENGTH(word) >= 3
  AND word NOT IN ('the', 'and', 'for', 'this', 'was', 'very', 'are', 'with', 'that')
GROUP BY word
ORDER BY count DESC, word ASC
LIMIT 5
```

</details>

## Solutions

### SQL

```sql
SELECT word, COUNT(*) AS count
FROM (
  SELECT LOWER(TRIM(word_raw)) AS word
  FROM reviews
  LATERAL VIEW EXPLODE(SPLIT(review_text, ' ')) t AS word_raw
)
WHERE LENGTH(word) >= 3
  AND word NOT IN ('the', 'and', 'for', 'this', 'was', 'very', 'are', 'with', 'that')
GROUP BY word
ORDER BY count DESC, word ASC
LIMIT 5
```

**Why it works:**
- `LATERAL VIEW EXPLODE(SPLIT(...))` is the Spark SQL way to unnest arrays
- `LOWER(TRIM(...))` normalizes the word after exploding (not nested inside EXPLODE)
- `WHERE LENGTH(word) >= 3` filters short words
- `NOT IN (...)` removes common stop words

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

stop_words = ["the", "and", "for", "this", "was", "very", "are", "with", "that"]

result = (
    df
    .select(F.explode(F.split(F.lower(F.col("review_text")), " ")).alias("word"))
    .filter(F.length(F.col("word")) >= 3)
    .filter(~F.col("word").isin(stop_words))
    .groupBy("word")
    .agg(F.count("*").alias("count"))
    .orderBy(F.col("count").desc(), F.col("word").asc())
    .limit(5)
)
```

**Why it works:**
- `F.lower` + `F.split` converts each review into a lowercased array of words.
- `F.explode` turns the array into individual rows — one word per row.
- `.filter(F.length(...) >= 3)` drops short words; `.filter(~col.isin(...))` drops stop words.
- `.groupBy("word").agg(F.count("*"))` counts each word's frequency.
- `.orderBy(count desc, word asc).limit(5)` returns the top 5 with a deterministic tiebreaker.
