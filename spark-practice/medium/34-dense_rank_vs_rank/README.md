# 34. Dense Rank vs Rank

**Difficulty:** medium  
**Tags:** window functions, rank, dense_rank  
**Source:** https://spark.vutrinh.net/problems/dense_rank_vs_rank

## Problem

Given a table `scores` with columns `student_id`, `name`, `subject`, and `score`, compute both `RANK()` and `DENSE_RANK()` for each student ordered by `score` descending.

Return columns: `student_id`, `name`, `score`, `rank`, `dense_rank`

Order by `score` descending, then `student_id` ascending.

**Key learning:** When scores are tied, `RANK()` skips subsequent rank numbers (e.g., two students at rank 1 means the next rank is 3), while `DENSE_RANK()` assigns the next consecutive number (rank 2).

## Schema

**`scores`**

| column | type |
|---|---|
| student_id | INT |
| name | STRING |
| subject | STRING |
| score | INT |

## Sample Input

**`scores`**

| student_id | name | subject | score |
|---|---|---|---|
| 1 | Alice | Math | 95 |
| 2 | Bob | Math | 88 |
| 3 | Carol | Math | 95 |
| 4 | Dave | Math | 72 |
| 5 | Eve | Math | 88 |

## Hints

<details><summary>Hint 1</summary>

Both `RANK()` and `DENSE_RANK()` assign positions to rows, but they handle ties differently. With `RANK()`, tied rows share a rank and the next rank is skipped. With `DENSE_RANK()`, tied rows share a rank but no numbers are skipped — ranks are always consecutive.

</details>

<details><summary>Hint 2</summary>

Apply both `RANK()` and `DENSE_RANK()` over the same window: `ORDER BY score DESC`. Since there is no partitioning here (all students are in one group), the window spec has only an ORDER BY clause.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT student_id, name, score,
       RANK() OVER (ORDER BY score DESC) AS rank,
       DENSE_RANK() OVER (ORDER BY score DESC) AS dense_rank
FROM scores
ORDER BY score DESC, student_id
```

</details>

## Solutions

### SQL

```sql
SELECT student_id,
       name,
       score,
       RANK() OVER (ORDER BY score DESC) AS rank,
       DENSE_RANK() OVER (ORDER BY score DESC) AS dense_rank
FROM scores
ORDER BY score DESC, student_id
```

**Why it works:**
- No `PARTITION BY` means all students are ranked together
- `RANK()` leaves gaps after ties: if two students tie for rank 1, the next student gets rank 3
- `DENSE_RANK()` never leaves gaps: the student after the two-way tie at 1 gets rank 2
- `ORDER BY score DESC, student_id` ensures a deterministic output order for tied scores

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

w = Window.orderBy(F.col("score").desc())

result = (
    df
    .withColumn("rank", F.rank().over(w))
    .withColumn("dense_rank", F.dense_rank().over(w))
    .select("student_id", "name", "score", "rank", "dense_rank")
    .orderBy(F.col("score").desc(), "student_id")
)
```

**Why it works:**
- `Window.orderBy(F.col("score").desc())` ranks all rows globally by score
- `F.rank()` and `F.dense_rank()` are applied over the same window
- The final `orderBy` ensures a deterministic row order when scores are tied
