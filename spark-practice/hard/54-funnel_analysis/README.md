# 54. Funnel Analysis

**Difficulty:** hard  
**Tags:** window functions, ordered events, aggregation  
**Source:** https://spark.vutrinh.net/problems/funnel_analysis

## Problem

# Funnel Analysis

**Difficulty:** Hard
**Tags:** window functions, ordered events, aggregation

## Background

A conversion funnel tracks how many users progress through each stage of an e-commerce journey: view a product → add to cart → checkout → purchase. Marketing wants to see where users drop off.

## Schema

**user_events** (`fixture.csv`)

| Column | Type | Description |
|---|---|---|
| event_id | INT | Unique event identifier |
| user_id | INT | User who triggered the event |
| event_type | STRING | One of: view, cart, checkout, purchase |
| event_date | STRING | Date of the event (YYYY-MM-DD) |

## Task

Count how many **distinct users** reached each funnel stage (i.e., performed at least one event of that type).

Return: **stage, stage_order, users_reached**
Order by: **stage_order ASC**

Stages and their order:

| stage | stage_order |
|---|---|
| view | 1 |
| cart | 2 |
| checkout | 3 |
| purchase | 4 |

## Expected Output

| stage | stage_order | users_reached |
|---|---|---|
| view | 1 | 6 |
| cart | 2 | 5 |
| checkout | 3 | 4 |
| purchase | 4 | 3 |

## Sample Input

**`user_events`**

| event_id | user_id | event_type | event_date |
|---|---|---|---|
| 1 | 1 | view | 2024-01-01 |
| 2 | 1 | cart | 2024-01-01 |
| 3 | 1 | checkout | 2024-01-01 |
| 4 | 1 | purchase | 2024-01-01 |
| 5 | 2 | view | 2024-01-01 |

## Hints

<details><summary>Hint 1</summary>

# Concept: Funnel Analysis

A funnel measures the count of distinct users who performed each action at least once, regardless of order or repetition. The key insight is:

- **Per-stage aggregation**: for each stage, count `DISTINCT user_id` where that event type appears. No need for ordering within user events for this simpler form of funnel.
- **Stage metadata**: you need to attach the human-readable stage name and its order number — use a lookup table (inline values or a CASE expression).

## Two Common Approaches

### 1. Pivot / CASE aggregation
Compute all four counts in one pass using conditional aggregation:
```sql
COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_id END) AS view_users
```
Then `UNPIVOT` (or union) to return one row per stage.

### 2. GROUP BY + JOIN to stage map
```sql
SELECT event_type, COUNT(DISTINCT user_id)
FROM user_events
GROUP BY event_type
-- then join to a stage mapping table for stage_order
```

Approach 2 is simpler and easier to extend.

</details>

<details><summary>Hint 2</summary>

# Approach

## Step-by-Step Plan

1. **Aggregate** `COUNT(DISTINCT user_id)` grouped by `event_type` from `user_events`.
2. **Map** each `event_type` to a `stage_order` integer using a CASE expression or by joining to an inline stage-mapping table.
3. **Rename** `event_type` → `stage` and select `stage, stage_order, users_reached`.
4. **Order** by `stage_order ASC`.

## Stage Mapping

```
view      → 1
cart      → 2
checkout  → 3
purchase  → 4
```

## Pseudocode

```
counts = GROUP BY event_type → COUNT(DISTINCT user_id) AS users_reached

result = counts
    .withColumn("stage", event_type)
    .withColumn("stage_order", CASE event_type WHEN 'view' THEN 1 ...)
    .select("stage", "stage_order", "users_reached")
    .orderBy("stage_order")
```

</details>

<details><summary>Hint 3</summary>

# Query Hint

## SQL Skeleton

```sql
WITH stage_map AS (
    SELECT 'view'     AS stage, 1 AS stage_order UNION ALL
    SELECT 'cart'     AS stage, 2 AS stage_order UNION ALL
    SELECT 'checkout' AS stage, 3 AS stage_order UNION ALL
    SELECT 'purchase' AS stage, 4 AS stage_order
),
counts AS (
    SELECT event_type AS stage, COUNT(DISTINCT user_id) AS users_reached
    FROM user_events
    GROUP BY event_type
)
SELECT c.stage, s.stage_order, c.users_reached
FROM counts c
JOIN stage_map s ON c.stage = s.stage
ORDER BY s.stage_order
```

## DataFrame Skeleton

```python
from pyspark.sql import Row

stage_map = spark.createDataFrame([
    Row(stage="view", stage_order=1),
    Row(stage="cart", stage_order=2),
    Row(stage="checkout", stage_order=3),
    Row(stage="purchase", stage_order=4),
])

counts = (
    df.groupBy(F.col("event_type").alias("stage"))
      .agg(F.countDistinct("user_id").alias("users_reached"))
)

result = (
    counts.join(stage_map, on="stage")
          .select("stage", "stage_order", "users_reached")
          .orderBy("stage_order")
)
```

</details>

## Solutions

### SQL

# Solution: SQL

```sql
WITH stage_map AS (
    SELECT 'view'     AS stage, 1 AS stage_order UNION ALL
    SELECT 'cart'     AS stage, 2 AS stage_order UNION ALL
    SELECT 'checkout' AS stage, 3 AS stage_order UNION ALL
    SELECT 'purchase' AS stage, 4 AS stage_order
),
counts AS (
    SELECT
        event_type AS stage,
        COUNT(DISTINCT user_id) AS users_reached
    FROM user_events
    GROUP BY event_type
)
SELECT
    c.stage,
    s.stage_order,
    c.users_reached
FROM counts c
JOIN stage_map s ON c.stage = s.stage
ORDER BY s.stage_order
```

## Explanation

1. **`stage_map` CTE** — an inline lookup table that assigns a numeric order to each stage name.
2. **`counts` CTE** — aggregates `COUNT(DISTINCT user_id)` per `event_type`, giving the number of unique users who performed each action at least once.
3. **Final SELECT** — joins the two CTEs on stage name, selects the required columns, and orders by `stage_order` so the funnel progresses from top to bottom.

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

stage_order = {"view": 1, "cart": 2, "checkout": 3, "purchase": 4}

counts = (
    user_events
    .groupBy(F.col("event_type").alias("stage"))
    .agg(F.countDistinct("user_id").alias("users_reached"))
)

result = (
    counts
    .withColumn("stage_order",
        F.when(F.col("stage") == "view", 1)
         .when(F.col("stage") == "cart", 2)
         .when(F.col("stage") == "checkout", 3)
         .when(F.col("stage") == "purchase", 4)
    )
    .select("stage", "stage_order", "users_reached")
    .orderBy("stage_order")
)
```

**Why it works:**
- `F.countDistinct("user_id")` counts unique users per event type
- `F.when(...).when(...)` assigns stage_order without needing spark.createDataFrame
- `.orderBy("stage_order")` presents funnel from top to bottom
