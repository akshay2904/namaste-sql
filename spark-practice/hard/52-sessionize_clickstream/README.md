# 52. Sessionize Clickstream Data

**Difficulty:** hard  
**Tags:** window functions, session, lag  
**Source:** https://spark.vutrinh.net/problems/sessionize_clickstream

## Problem

# Sessionize Clickstream Data

**Difficulty:** Hard
**Tags:** window functions, session, lag

## Background

A clickstream captures every page visit a user makes on a website. For analytics purposes, visits are grouped into *sessions* — contiguous bursts of activity. A new session begins whenever a user is idle for more than 30 minutes.

## Schema

**clickstream** (`fixture.csv`)

| Column | Type | Description |
|---|---|---|
| event_id | INT | Unique event identifier |
| user_id | INT | User who triggered the event |
| page | STRING | Page visited |
| event_time | STRING | Timestamp of the event (YYYY-MM-DD HH:MM:SS) |

## Task

Assign a `session_id` to each event. A new session starts when the gap between consecutive events for the same user exceeds **30 minutes** (1800 seconds). Session IDs are sequential integers starting at 1 per user.

Return: **event_id, user_id, page, event_time, session_id**
Order by: **user_id ASC, event_time ASC**

## Expected Output (first few rows)

| event_id | user_id | page | event_time | session_id |
|---|---|---|---|---|
| 1 | 1 | home | 2024-01-01 10:00:00 | 1 |
| 2 | 1 | products | 2024-01-01 10:10:00 | 1 |
| 3 | 1 | product_detail | 2024-01-01 10:20:00 | 1 |
| 4 | 1 | cart | 2024-01-01 11:05:00 | 2 |
| 5 | 1 | checkout | 2024-01-01 11:15:00 | 2 |
| ... | ... | ... | ... | ... |

## Sample Input

**`clickstream`**

| event_id | user_id | page | event_time |
|---|---|---|---|
| 1 | 1 | home | 2024-01-01 10:00:00 |
| 2 | 1 | products | 2024-01-01 10:10:00 |
| 3 | 1 | product_detail | 2024-01-01 10:20:00 |
| 4 | 1 | cart | 2024-01-01 11:05:00 |
| 5 | 1 | checkout | 2024-01-01 11:15:00 |

## Hints

<details><summary>Hint 1</summary>

# Concept: Session Windows with Window Functions

A **session** is a sequence of events where no two consecutive events are separated by more than a threshold gap (here, 30 minutes).

## Key Idea: Cumulative Sum of Boundary Flags

The trick to sessionizing without a loop is:

1. **Detect boundaries** — for each event, check if the gap from the *previous* event (by the same user) exceeds the threshold. If so, this event starts a new session.
2. **Assign session IDs** — a running `SUM` of boundary flags gives each event a monotonically increasing group number. Add 1 to start at session 1.

```
event_time    prev_time    gap(min)    new_flag    cumsum    session_id
10:00         NULL         NULL        1           1         2  ← add 1
10:10         10:00        10          0           1         2
10:20         10:10        10          0           1         2
11:05         10:20        45          1           2         3
11:15         11:05        10          0           2         3
```

Wait — the first event always gets flag=1 (no previous event). After the cumulative sum + 1 the session IDs will be correct relative to each other per user, as long as you consistently treat NULL gaps as new sessions.

## Window Functions Used

- `LAG(col, 1)` — retrieve the previous row's value within the partition
- `SUM(...) OVER (... ROWS UNBOUNDED PRECEDING)` — running total

</details>

<details><summary>Hint 2</summary>

# Approach

## Step-by-Step Plan

1. **Create a window** partitioned by `user_id`, ordered by `event_time`.
2. **Get the previous event time** using `LAG(event_time, 1)` over the window.
3. **Compute gap in seconds**: `UNIX_TIMESTAMP(event_time) - UNIX_TIMESTAMP(prev_time)`.
4. **Flag new sessions**: `CASE WHEN gap > 1800 OR prev_time IS NULL THEN 1 ELSE 0 END`.
5. **Running sum of flags** over the same window gives a session counter per user (starts at 1 for the first event).
6. **Select** the required columns and order the result.

## Pseudocode

```
w = PARTITION BY user_id ORDER BY event_time

prev_time  = LAG(event_time, 1) OVER w
gap_secs   = UNIX_TIMESTAMP(event_time) - UNIX_TIMESTAMP(prev_time)
new_flag   = CASE WHEN gap_secs > 1800 OR prev_time IS NULL THEN 1 ELSE 0 END
session_id = SUM(new_flag) OVER w   -- running total within user
```

Note: `SUM(new_flag) OVER w` with no explicit ROWS clause defaults to RANGE UNBOUNDED PRECEDING to CURRENT ROW, which is what you want for a running total.

</details>

<details><summary>Hint 3</summary>

# Query Hint

## SQL Skeleton

```sql
WITH lagged AS (
    SELECT
        event_id,
        user_id,
        page,
        event_time,
        LAG(event_time) OVER (PARTITION BY user_id ORDER BY event_time) AS prev_time
    FROM clickstream
),
flagged AS (
    SELECT
        *,
        CASE
            WHEN prev_time IS NULL
                 OR UNIX_TIMESTAMP(event_time) - UNIX_TIMESTAMP(prev_time) > 1800
            THEN 1
            ELSE 0
        END AS new_session_flag
    FROM lagged
)
SELECT
    event_id,
    user_id,
    page,
    event_time,
    SUM(new_session_flag) OVER (PARTITION BY user_id ORDER BY event_time) AS session_id
FROM flagged
ORDER BY user_id, event_time
```

## DataFrame Skeleton

```python
w_lag = Window.partitionBy("user_id").orderBy("event_time")

df = df.withColumn("prev_time", F.lag("event_time", 1).over(w_lag))
df = df.withColumn(
    "gap_secs",
    F.unix_timestamp("event_time") - F.unix_timestamp("prev_time")
)
df = df.withColumn(
    "new_flag",
    F.when(F.col("prev_time").isNull() | (F.col("gap_secs") > 1800), 1).otherwise(0)
)
w_sum = Window.partitionBy("user_id").orderBy("event_time").rowsBetween(
    Window.unboundedPreceding, Window.currentRow
)
df = df.withColumn("session_id", F.sum("new_flag").over(w_sum))
```

</details>

## Solutions

### SQL

# Solution: SQL

```sql
WITH lagged AS (
    SELECT
        event_id,
        user_id,
        page,
        event_time,
        LAG(event_time) OVER (PARTITION BY user_id ORDER BY event_time) AS prev_time
    FROM clickstream
),
flagged AS (
    SELECT
        event_id,
        user_id,
        page,
        event_time,
        CASE
            WHEN prev_time IS NULL
                 OR UNIX_TIMESTAMP(event_time) - UNIX_TIMESTAMP(prev_time) > 1800
            THEN 1
            ELSE 0
        END AS new_session_flag
    FROM lagged
)
SELECT
    event_id,
    user_id,
    page,
    event_time,
    SUM(new_session_flag) OVER (
        PARTITION BY user_id
        ORDER BY event_time
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS session_id
FROM flagged
ORDER BY user_id, event_time
```

## Explanation

1. **`lagged` CTE** — pull the previous event time for each user using `LAG`.
2. **`flagged` CTE** — compare the current and previous timestamps. If the gap exceeds 1800 seconds (30 min) or there is no previous event (start of user's history), mark `new_session_flag = 1`.
3. **Final SELECT** — `SUM(new_session_flag)` as a running total gives each event a session counter. Because the first event always gets flag 1, session IDs naturally start at 1.

### DataFrame API

# Solution: DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

# Window for LAG and running SUM — ordered by event_time within each user
w = Window.partitionBy("user_id").orderBy("event_time")
w_running = Window.partitionBy("user_id").orderBy("event_time").rowsBetween(
    Window.unboundedPreceding, Window.currentRow
)

result = (
    clickstream
    .withColumn("prev_time", F.lag("event_time", 1).over(w))
    .withColumn(
        "gap_secs",
        F.unix_timestamp("event_time") - F.unix_timestamp("prev_time")
    )
    .withColumn(
        "new_flag",
        F.when(
            F.col("prev_time").isNull() | (F.col("gap_secs") > 1800), 1
        ).otherwise(0)
    )
    .withColumn("session_id", F.sum("new_flag").over(w_running))
    .select("event_id", "user_id", "page", "event_time", "session_id")
    .orderBy("user_id", "event_time")
)

result.show()
```

## Explanation

- `lag("event_time", 1).over(w)` retrieves the timestamp of the immediately preceding event per user.
- The gap in seconds is computed by converting both timestamps via `unix_timestamp`.
- `new_flag` is 1 when the gap exceeds 30 minutes or there is no prior event.
- `F.sum("new_flag").over(w_running)` accumulates the flags into a monotonically increasing session counter. Because every user's first event receives flag 1, session IDs start at 1.
