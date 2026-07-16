# 65. Slowly Changing Dimension Type 2 Modelling

**Difficulty:** hard  
**Tags:** window functions, scd, data modelling  
**Source:** https://spark.vutrinh.net/problems/scd_type2_modelling

## Problem

Given a table `players` with one snapshot row per player per season — columns `player_name`, `scoring_class`, `is_active`, `season` — model it as a **Slowly Changing Dimension Type 2** table.

For each player, collapse consecutive seasons where both `scoring_class` and `is_active` stayed the same into a single row, and emit:

- `start_season` — first season in the run
- `end_season` — last season in the run
- `current_season` — the most recent season observed for that player (i.e. `MAX(season)` per player)

A new row should start whenever `scoring_class` changes, `is_active` changes, or it is the player's first season.

Return columns in this order: `player_name`, `scoring_class`, `is_active`, `current_season`, `start_season`, `end_season`.

Order the result by `player_name` ascending, then `start_season` ascending.

## Schema

**`players`**

| column | type |
|---|---|
| player_name | STRING |
| scoring_class | STRING |
| is_active | BOOLEAN |
| season | INT |

## Sample Input

**`players`**

| player_name | scoring_class | is_active | season |
|---|---|---|---|
| Mike | Star | true | 2018 |
| Mike | Star | true | 2019 |
| Mike | Good | true | 2020 |
| Mike | Good | false | 2021 |
| Mike | Good | true | 2022 |

## Hints

<details><summary>Hint 1</summary>

SCD Type 2 *modelling* takes an event/snapshot table (one row per entity per period) and collapses it into one row per "run" of unchanged attributes. Each run is bounded by a `start_season` and `end_season`. This pattern compresses dimensional history while preserving every change — instead of one row per season, you keep one row per *state*. It is the classic gap-and-island problem.

</details>

<details><summary>Hint 2</summary>

1. For each player, use `LAG(scoring_class)` and `LAG(is_active)` over `(PARTITION BY player_name ORDER BY season)` to compare each row to its predecessor.
2. Mark a row as the start of a new run when the previous value is NULL (first season) or when either attribute differs from the previous row.
3. Take a cumulative `SUM` of that "is_change" flag over the same window — the running total is a stable id for each run of unchanged attributes.
4. Group by `(player_name, run_id, scoring_class, is_active)` and aggregate `MIN(season)` as `start_season`, `MAX(season)` as `end_season`.
5. Use `MAX(season) OVER (PARTITION BY player_name)` to attach `current_season` to each row.
6. Order by `player_name`, then `start_season`.

</details>

<details><summary>Hint 3</summary>

```sql
WITH changes AS (
    SELECT
        player_name,
        scoring_class,
        is_active,
        season,
        CASE
            WHEN LAG(scoring_class) OVER w IS NULL
              OR scoring_class <> LAG(scoring_class) OVER w
              OR is_active     <> LAG(is_active) OVER w
            THEN 1 ELSE 0
        END AS is_change
    FROM players
    WINDOW w AS (PARTITION BY player_name ORDER BY season)
),
runs AS (
    SELECT
        *,
        SUM(is_change) OVER (PARTITION BY player_name ORDER BY season) AS streak_id,
        MAX(season)   OVER (PARTITION BY player_name)                  AS current_season
    FROM changes
)
SELECT
    player_name,
    scoring_class,
    is_active,
    current_season,
    MIN(season) AS start_season,
    MAX(season) AS end_season
FROM runs
GROUP BY player_name, streak_id, scoring_class, is_active, current_season
ORDER BY player_name, start_season
```

</details>

## Solutions

### SQL

```sql
WITH changes AS (
    SELECT
        player_name,
        scoring_class,
        is_active,
        season,
        CASE
            WHEN LAG(scoring_class) OVER w IS NULL
              OR scoring_class <> LAG(scoring_class) OVER w
              OR is_active     <> LAG(is_active) OVER w
            THEN 1 ELSE 0
        END AS is_change
    FROM players
    WINDOW w AS (PARTITION BY player_name ORDER BY season)
),
runs AS (
    SELECT
        *,
        SUM(is_change) OVER (PARTITION BY player_name ORDER BY season) AS streak_id,
        MAX(season)   OVER (PARTITION BY player_name)                  AS current_season
    FROM changes
)
SELECT
    player_name,
    scoring_class,
    is_active,
    current_season,
    MIN(season) AS start_season,
    MAX(season) AS end_season
FROM runs
GROUP BY player_name, streak_id, scoring_class, is_active, current_season
ORDER BY player_name, start_season
```

**Why it works:**
- `LAG` over `(PARTITION BY player_name ORDER BY season)` gives each row a peek at the immediately preceding season's attributes for the same player.
- The `CASE` flags any row that starts a new run — first season for the player, or a change in either `scoring_class` or `is_active`.
- A cumulative `SUM` of that 0/1 flag over the same window produces a stable `streak_id` that increments only at transitions, so all rows in the same run share one id.
- Grouping by `(player_name, streak_id, scoring_class, is_active)` collapses each run to one row, with `MIN/MAX(season)` becoming the run's bounds.
- `MAX(season) OVER (PARTITION BY player_name)` is included in the grouping (it is constant within a player) so it survives the aggregation and lands on every row as `current_season`.

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

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
```

**Why it works:**
- `F.lag("scoring_class")` and `F.lag("is_active")` over `(player_name, season)` give each row its predecessor's attributes within the same player.
- `is_change = 1` whenever either previous attribute is missing (first row) or differs, so it lights up only on transitions.
- A cumulative `F.sum("is_change")` over the same ordered window yields `streak_id`: every row in the same run shares the same id.
- An unordered `F.max("season").over(Window.partitionBy("player_name"))` attaches `current_season` to each row before the aggregation, so it survives the grouping without an extra join.
- Grouping by `(player_name, streak_id, scoring_class, is_active, current_season)` and aggregating `min`/`max` on `season` collapses each run into a single row with its bounds.
- The explicit `.select(...)` pins the column order to match the expected output.
