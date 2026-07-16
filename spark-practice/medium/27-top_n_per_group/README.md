# 27. Top N per Group

**Difficulty:** medium  
**Tags:** window functions, ranking  
**Source:** https://spark.vutrinh.net/problems/top_n_per_group

## Problem

Given a table `employees` with columns `department`, `employee`, and `salary`, return the **top 2 highest-paid employees per department**.

Return columns: `department`, `employee`, `salary`, `rank`

Order the result by `department` ascending, then `rank` ascending.

**Hint:** Use a window function with `RANK()` or `ROW_NUMBER()` partitioned by `department`.

## Schema

**`employees`**

| column | type |
|---|---|
| department | STRING |
| employee | STRING |
| salary | INT |

## Sample Input

**`employees`**

| department | employee | salary |
|---|---|---|
| Engineering | Alice | 95000 |
| Engineering | Bob | 88000 |
| Engineering | Charlie | 102000 |
| Engineering | Diana | 91000 |
| Marketing | Eve | 75000 |

## Hints

<details><summary>Hint 1</summary>

To find the top N within each group, you need to **rank rows within each partition** and then filter by rank.

</details>

<details><summary>Hint 2</summary>

Use a **window function** with `PARTITION BY department ORDER BY salary DESC` to rank employees within each department.

</details>

<details><summary>Hint 3</summary>

Use `RANK()` or `ROW_NUMBER()` over the window, assign it as `rank`, then wrap in a subquery and filter `WHERE rank <= 2`.

```sql
SELECT * FROM (
  SELECT *, RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
  FROM employees
) WHERE rank <= 2
```

</details>

## Solutions

### SQL

```sql
SELECT department, employee, salary, rank
FROM (
  SELECT department, employee, salary,
         RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
  FROM employees
)
WHERE rank <= 2
ORDER BY department, rank
```

**Why it works:**
- `RANK() OVER (PARTITION BY department ORDER BY salary DESC)` assigns a rank within each department, highest salary = rank 1
- The outer query filters `rank <= 2` to keep only the top 2
- `ORDER BY department, rank` gives the required sort order

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

window = Window.partitionBy("department").orderBy(F.desc("salary"))

result = df \
    .withColumn("rank", F.rank().over(window)) \
    .filter(F.col("rank") <= 2) \
    .orderBy("department", "rank")
```

**Why it works:**
- `Window.partitionBy("department").orderBy(F.desc("salary"))` defines a window per department sorted by salary descending
- `F.rank().over(window)` assigns rank 1 to the highest salary in each department
- `.filter(F.col("rank") <= 2)` keeps only top 2 per department
