# 56. Tally Election Results

**Difficulty:** hard  
**Tags:** aggregation, ranking, dense_rank  
**Source:** https://spark.vutrinh.net/problems/tally_election

## Problem

# Tally Election Results

**Difficulty:** Hard
**Tags:** aggregation, ranking, dense_rank

## Background

Three candidates (Alice, Bob, Charlie) contested an election across three districts (North, South, East). Each row in the votes table represents one ballot cast. Determine the winner in each district.

## Schema

**votes** (`fixture.csv`)

| Column | Type | Description |
|---|---|---|
| vote_id | INT | Unique ballot identifier |
| voter_id | INT | Unique voter identifier |
| candidate | STRING | Candidate name |
| district | STRING | District where the vote was cast |

## Task

Find the **winning candidate** (most votes) in each district. Return one row per district.

Return: **district, candidate, votes**
Order by: **district ASC**

## Expected Output

| district | candidate | votes |
|---|---|---|
| East | Charlie | 3 |
| North | Alice | 3 |
| South | Bob | 4 |

## Notes

- North: Alice 3, Bob 2, Charlie 1 → Alice wins
- South: Bob 4, Charlie 2, Alice 1 → Bob wins
- East: Charlie 3, Alice 2, Bob 2 → Charlie wins

## Sample Input

**`votes`**

| vote_id | voter_id | candidate | district |
|---|---|---|---|
| 1 | 101 | Alice | North |
| 2 | 102 | Alice | North |
| 3 | 103 | Bob | North |
| 4 | 104 | Alice | North |
| 5 | 105 | Charlie | North |

## Hints

<details><summary>Hint 1</summary>

# Concept: Ranking Aggregated Groups

Finding the winner per group is a two-step pattern:

1. **Aggregate** to get the count per group (here: votes per district–candidate pair).
2. **Rank within groups** to find the top entry per group and filter to rank = 1.

## Why Not Just MAX?

A plain `MAX(count) GROUP BY district` gives you the vote total for the winner but loses the candidate name. Ranking preserves the full row so you can return both.

## RANK vs DENSE_RANK vs ROW_NUMBER

| Function | Ties |
|---|---|
| `RANK` | Tied rows get same rank; next rank skips |
| `DENSE_RANK` | Tied rows get same rank; next rank does not skip |
| `ROW_NUMBER` | Tied rows get arbitrary distinct ranks |

For this problem `RANK` and `DENSE_RANK` both work when there are no ties. If there were ties and you wanted to surface all co-winners, use `RANK` or `DENSE_RANK` and filter `rank = 1` — multiple rows would pass the filter.

</details>

<details><summary>Hint 2</summary>

# Approach

## Step-by-Step Plan

1. **Aggregate** — `GROUP BY district, candidate` and `COUNT(*)` → `votes`.
2. **Rank** — `RANK() OVER (PARTITION BY district ORDER BY votes DESC)` → `rnk`.
3. **Filter** — keep only rows where `rnk = 1`.
4. **Select** — `district, candidate, votes`.
5. **Order** — by `district ASC`.

## Pseudocode

```
vote_counts = GROUP BY district, candidate → COUNT(*) AS votes

ranked = vote_counts
    .withColumn("rnk", RANK() OVER (PARTITION BY district ORDER BY votes DESC))

result = ranked
    .filter(rnk == 1)
    .select("district", "candidate", "votes")
    .orderBy("district")
```

## Alternative: Subquery / CTE

Use a CTE to compute counts first, then add the rank in the outer query. This is cleaner in SQL.

</details>

<details><summary>Hint 3</summary>

# Query Hint

## SQL Skeleton

```sql
WITH vote_counts AS (
    SELECT
        district,
        candidate,
        COUNT(*) AS votes
    FROM votes
    GROUP BY district, candidate
),
ranked AS (
    SELECT
        district,
        candidate,
        votes,
        RANK() OVER (PARTITION BY district ORDER BY votes DESC) AS rnk
    FROM vote_counts
)
SELECT district, candidate, votes
FROM ranked
WHERE rnk = 1
ORDER BY district
```

## DataFrame Skeleton

```python
w = Window.partitionBy("district").orderBy(F.col("votes").desc())

result = (
    votes.groupBy("district", "candidate")
         .agg(F.count("*").alias("votes"))
         .withColumn("rnk", F.rank().over(w))
         .filter(F.col("rnk") == 1)
         .select("district", "candidate", "votes")
         .orderBy("district")
)
```

</details>

## Solutions

### SQL

# Solution: SQL

```sql
WITH vote_counts AS (
    SELECT
        district,
        candidate,
        COUNT(*) AS votes
    FROM votes
    GROUP BY district, candidate
),
ranked AS (
    SELECT
        district,
        candidate,
        votes,
        RANK() OVER (PARTITION BY district ORDER BY votes DESC) AS rnk
    FROM vote_counts
)
SELECT
    district,
    candidate,
    votes
FROM ranked
WHERE rnk = 1
ORDER BY district
```

## Explanation

1. **`vote_counts` CTE** — aggregates the ballot table to get the total votes per district–candidate pair.
2. **`ranked` CTE** — applies `RANK()` within each district ordered by votes descending. The candidate with the most votes gets `rnk = 1`.
3. **Final SELECT** — filters to only the top-ranked candidate per district and orders alphabetically by district.

### DataFrame API

# Solution: DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

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
```

## Explanation

- `groupBy("district", "candidate").agg(count("*"))` tallies each candidate's votes per district.
- `rank().over(w)` ranks candidates within each district by vote count descending. The leading candidate gets rank 1.
- Filtering `rnk == 1` retains only the winner(s) per district.
- `select` and `orderBy` produce the clean final output.
