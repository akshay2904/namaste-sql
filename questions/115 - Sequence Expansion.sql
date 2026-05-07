-- ======================================================================
-- 115 - Sequence Expansion
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Zepto
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/115-sequence-expansion
-- ======================================================================

/*
You have a table named numbers containing a single column n. You are required to generate an output that expands each number n into a sequence where the number appears n times.

 
Table: numbers 
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| n           |   int     |    
+-------------+-----------+
*/


-- Write your SQL solution below:

```sql
SELECT n
FROM numbers
CROSS JOIN (
  SELECT 1 AS seq
  UNION ALL
  SELECT seq + 1
  FROM (
    WITH RECURSIVE cnt(seq) AS (
      SELECT 1
      UNION ALL
      SELECT seq + 1
      FROM cnt
      WHERE seq < (SELECT MAX(n) FROM numbers)
    )
    SELECT seq FROM cnt
  ) sub
  WHERE seq <= (SELECT MAX(n) FROM numbers)
) seq_table
WHERE seq <= n
ORDER BY n, seq;
```

A simpler PostgreSQL-specific solution:

```sql
SELECT n
FROM numbers
CROSS JOIN LATERAL generate_series(1, n) AS gs(seq)
ORDER BY n, seq;
```

A MySQL-compatible solution:

```sql
WITH RECURSIVE seq_generator AS (
  SELECT 1 AS num
  UNION ALL
  SELECT num + 1
  FROM seq_generator
  WHERE num < (SELECT MAX(n) FROM numbers)
)
SELECT n
FROM numbers
CROSS JOIN seq_generator
WHERE seq_generator.num <= numbers.n
ORDER BY n, seq_generator.num;
```
