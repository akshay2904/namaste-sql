# 57. Ledger Reconciliation

**Difficulty:** hard  
**Tags:** full outer join, variance  
**Source:** https://spark.vutrinh.net/problems/ledger_reconciliation

## Problem

# Ledger Reconciliation

**Difficulty:** Hard
**Tags:** full outer join, variance

## Background

The finance team needs to reconcile the internal system ledger against the bank statement. Some transactions match exactly, some have amount discrepancies, and some appear in only one source.

## Schema

**system_ledger** (`system_ledger.csv`)

| Column | Type | Description |
|---|---|---|
| txn_id | INT | Transaction identifier |
| amount | DOUBLE | Amount recorded in the system |
| category | STRING | Expense category |

**bank_ledger** (`bank_ledger.csv`)

| Column | Type | Description |
|---|---|---|
| txn_id | INT | Transaction identifier |
| amount | DOUBLE | Amount recorded by the bank |
| category | STRING | Expense category |

## Task

Identify all **discrepancies** between the two ledgers. A discrepancy exists when:
- The amounts differ for the same `txn_id`, OR
- A transaction appears in only one ledger (NULL on the other side).

Compute `variance = bank_amount - system_amount`. If either side is NULL, `variance` should also be NULL.

Return: **txn_id, system_amount, bank_amount, variance**
Order by: **txn_id ASC**

## Expected Discrepancies

| txn_id | system_amount | bank_amount | variance |
|---|---|---|---|
| 1002 | 80.50 | 82.00 | 1.50 |
| 1004 | 45.00 | NULL | NULL |
| 1006 | 150.00 | 155.00 | 5.00 |
| 1008 | 500.00 | 510.00 | 10.00 |
| 1010 | 275.00 | NULL | NULL |
| 1011 | NULL | 400.00 | NULL |
| 1012 | NULL | 35.00 | NULL |

## Notes

- Transactions 1001, 1003, 1005, 1007, 1009 match exactly — exclude them.
- Transaction 1004 and 1010 are only in the system ledger.
- Transactions 1011 and 1012 are only in the bank ledger.

## Sample Input

**`system_ledger`**

| txn_id | amount | category |
|---|---|---|
| 1001 | 250.00 | payroll |
| 1002 | 80.50 | utilities |
| 1003 | 1200.00 | rent |
| 1004 | 45.00 | office_supplies |
| 1005 | 320.75 | software |

**`bank_ledger`**

| txn_id | amount | category |
|---|---|---|
| 1001 | 250.00 | payroll |
| 1002 | 82.00 | utilities |
| 1003 | 1200.00 | rent |
| 1005 | 320.75 | software |
| 1006 | 155.00 | travel |

## Hints

<details><summary>Hint 1</summary>

# Concept: Full Outer Join for Reconciliation

A **FULL OUTER JOIN** returns all rows from both tables, filling in NULL for columns from the side that has no matching row. This is the natural tool for reconciliation tasks where you need to surface:

- Rows present in **both** sources (for comparison)
- Rows present in **only the left** source (missing from the right)
- Rows present in **only the right** source (missing from the left)

## Filtering to Discrepancies Only

After the full outer join, filter out exactly-matching rows:
```sql
WHERE s.amount != b.amount
   OR s.txn_id IS NULL
   OR b.txn_id IS NULL
```

An easier way: keep any row where the amounts are NOT equal or either side is NULL.

## NULL Arithmetic

In SQL and Spark, any arithmetic involving NULL produces NULL:
```
bank_amount - system_amount = NULL  (if either is NULL)
```

This is the desired behaviour for `variance` — you naturally get NULL when a transaction is one-sided.

</details>

<details><summary>Hint 2</summary>

# Approach

## Step-by-Step Plan

1. **FULL OUTER JOIN** `system_ledger` and `bank_ledger` on `txn_id`.
2. **Select columns**:
   - `COALESCE(s.txn_id, b.txn_id)` → `txn_id`
   - `s.amount` → `system_amount`
   - `b.amount` → `bank_amount`
   - `b.amount - s.amount` → `variance` (NULL when either is NULL — that's correct)
3. **Filter** to rows where amounts differ or one side is missing:
   - `s.amount != b.amount OR s.txn_id IS NULL OR b.txn_id IS NULL`
4. **Order** by `txn_id ASC`.

## DataFrame Tip

In Spark's DataFrame API, after a full outer join both `txn_id` columns exist. Use `COALESCE` or alias them carefully before the join:

```python
system_ledger.alias("s").join(bank_ledger.alias("b"), on="txn_id", how="full")
```

When joining `on="txn_id"` Spark automatically coalesces the join key into a single column.

</details>

<details><summary>Hint 3</summary>

# Query Hint

## SQL Skeleton

```sql
SELECT
    COALESCE(s.txn_id, b.txn_id) AS txn_id,
    s.amount                      AS system_amount,
    b.amount                      AS bank_amount,
    b.amount - s.amount           AS variance
FROM system_ledger s
FULL OUTER JOIN bank_ledger b ON s.txn_id = b.txn_id
WHERE s.amount != b.amount
   OR s.txn_id IS NULL
   OR b.txn_id IS NULL
ORDER BY txn_id
```

## DataFrame Skeleton

```python
joined = (
    system_ledger.alias("s")
    .join(bank_ledger.alias("b"), on="txn_id", how="full")
    .select(
        F.col("txn_id"),
        F.col("s.amount").alias("system_amount"),
        F.col("b.amount").alias("bank_amount"),
        (F.col("b.amount") - F.col("s.amount")).alias("variance"),
    )
)

result = (
    joined.filter(
        (F.col("system_amount") != F.col("bank_amount"))
        | F.col("system_amount").isNull()
        | F.col("bank_amount").isNull()
    )
    .orderBy("txn_id")
)
```

</details>

## Solutions

### SQL

# Solution: SQL

```sql
SELECT
    COALESCE(s.txn_id, b.txn_id) AS txn_id,
    s.amount                      AS system_amount,
    b.amount                      AS bank_amount,
    b.amount - s.amount           AS variance
FROM system_ledger s
FULL OUTER JOIN bank_ledger b ON s.txn_id = b.txn_id
WHERE s.amount != b.amount
   OR s.txn_id IS NULL
   OR b.txn_id IS NULL
ORDER BY txn_id
```

## Explanation

1. **`FULL OUTER JOIN`** — produces all combinations: matching rows, system-only rows (bank side is NULL), and bank-only rows (system side is NULL).
2. **`COALESCE(s.txn_id, b.txn_id)`** — ensures `txn_id` is non-NULL regardless of which side the row came from.
3. **`b.amount - s.amount`** — computes variance; NULL arithmetic naturally yields NULL when either operand is missing.
4. **`WHERE` clause** — excludes transactions that match exactly on both sides.
5. **`ORDER BY txn_id`** — consistent, predictable ordering.

### DataFrame API

# Solution: DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

# Rename amount columns before joining so both are accessible after
sys_df  = system_ledger.select(F.col("txn_id"), F.col("amount").alias("system_amount"))
bank_df = bank_ledger.select(F.col("txn_id"), F.col("amount").alias("bank_amount"))

joined = sys_df.join(bank_df, on="txn_id", how="full")

result = (
    joined
    .withColumn("variance", F.col("bank_amount") - F.col("system_amount"))
    .filter(
        (F.col("system_amount") != F.col("bank_amount"))
        | F.col("system_amount").isNull()
        | F.col("bank_amount").isNull()
    )
    .select("txn_id", "system_amount", "bank_amount", "variance")
    .orderBy("txn_id")
)

result.show()
```

## Explanation

- Renaming `amount` in each DataFrame before the join prevents column ambiguity and makes subsequent expressions clear.
- `how="full"` ensures rows missing from either side are preserved with NULL.
- The filter removes perfectly matching rows, leaving only discrepancies.
- `bank_amount - system_amount` naturally yields NULL for one-sided transactions.
